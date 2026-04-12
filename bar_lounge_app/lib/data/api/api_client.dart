import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/router/app_router.dart';

/// Dio client configured per Section 1 of api_contract.md
class ApiClient {
  static const String _tokenKey = 'access_token';
  static const String _clientIdKey = 'cliente_id';

  /// On Android emulator, `localhost` refers to the emulator itself.
  /// Use 10.0.2.2 to reach the host machine's localhost:8001.
  static String get _baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8001/api/v1';
    }
    return 'http://localhost:8001/api/v1';
  }

  final Dio dio;
  final FlutterSecureStorage _storage;

  ApiClient({Dio? dio, FlutterSecureStorage? storage})
      : dio = dio ?? Dio(),
        _storage = storage ?? const FlutterSecureStorage() {
    this.dio.options = BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    // ── Auth interceptor FIRST so the token is in the header before logging ──
    this.dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final path = options.path;
          // Skip auth header for registration and login endpoints
          final isAuthEndpoint = path.contains('/auth/registro') ||
              path.contains('/auth/login');

          if (!isAuthEndpoint) {
            final token = await _storage.read(key: _tokenKey);
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
              print('[AUTH] Token injected for $path → ${token.substring(0, token.length.clamp(0, 20))}...');
            } else {
              print('[AUTH] WARNING: No token found in storage for $path');
            }
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          final statusCode = error.response?.statusCode;
          final path = error.requestOptions.path;
          print('[DIO ERROR] $path → $statusCode ${error.message}');
          print('[DIO ERROR] Response body: ${error.response?.data}');
          print('[DIO ERROR] Request headers: ${error.requestOptions.headers}');

          if (statusCode == 401) {
            final storedToken = await _storage.read(key: _tokenKey);
            if (storedToken == null || storedToken.isEmpty) {
              // Token is truly gone – force re-login.
              await _storage.delete(key: _clientIdKey);
              try {
                appRouter.go('/login', extra: 'Your session has expired, please log in again');
              } catch (e) {
                print('Failed to route to login: $e');
              }
            } else {
              print('[AUTH] 401 but token IS present in storage (${storedToken.substring(0, storedToken.length.clamp(0, 20))}...). Server rejected for another reason.');
            }
          }
          handler.next(error);
        },
      ),
    );

    // ── Logger AFTER auth so the Authorization header shows in logs ──
    this.dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        logPrint: (o) => print('[DIO] $o'),
      ),
    );
  }

  Future<void> saveToken(String token, {int? clienteId}) async {
    await _storage.write(key: _tokenKey, value: token);
    if (clienteId != null) {
      await _storage.write(key: _clientIdKey, value: clienteId.toString());
    }
  }

  Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  Future<int?> getClienteId() async {
    final val = await _storage.read(key: _clientIdKey);
    return val != null ? int.tryParse(val) : null;
  }

  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _clientIdKey);
  }
}

// ignore_for_file: avoid_print

import 'dart:io';

import '../api_client.dart';
import '../dto/api_models.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class ApiService {

  final ApiClient _client;

  ApiService(this._client);


  Future<RegistroResponse> registro(RegistroRequest request) async {
    final response = await _client.dio.post(
      '/clientes/auth/registro',
      data: request.toJson(),
    );
    return RegistroResponse.fromJson(response.data);
  }


  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _client.dio.post(
      '/clientes/auth/login',
      data: request.toJson(),
    );

    final loginResponse = LoginResponse.fromJson(response.data);

    await _client.saveToken(loginResponse.access_token, clienteId: loginResponse.cliente_id);

    _registerFCMToken();

    return loginResponse;
  }


  Future<void> _registerFCMToken() async {
    try {
      String plataforma = Platform.isAndroid ? "Android" : "iOS"; 
      final String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await _client.dio.post(
          '/clientes/auth/registrar-dispositivo',
          data: {'fcm_token': token,
        'plataforma': plataforma,},
        );
        print('[FCM] Token successfully registered');
      }
    } catch (e) {
      print('[FCM Error] Could not register token: $e');
    }
  }


  Future<void> syncFCMToken() async {
    await _registerFCMToken();
  }


  Future<List<dynamic>> getCategorias({int? lastSyncTimestamp}) async {
    final response = await _client.dio.get(
      '/productos/categorias',
      queryParameters: lastSyncTimestamp != null ? {'last_sync': lastSyncTimestamp} : null,
    );
    return response.data as List;
  }


  Future<List<dynamic>> getCatalogo({int? lastSyncTimestamp}) async {
    final response = await _client.dio.get(
      '/productos/',
      queryParameters: lastSyncTimestamp != null ? {'last_sync': lastSyncTimestamp} : null,
    );
    return response.data as List;
  }


  Future<List<dynamic>> getProductos(int categoriaId, {int? lastSyncTimestamp}) async {
    final response = await _client.dio.get(
      '/productos/por-categoria/$categoriaId',
      queryParameters: lastSyncTimestamp != null ? {'last_sync': lastSyncTimestamp} : null,
    );
    return response.data as List;
  }

  Future<List<dynamic>> getPromocionesActivas() async {
    final response = await _client.dio.get('/promociones/');
    return response.data as List;
  }


  Future<VincularMesaResponse> vincularMesa(
      VincularMesaRequest request) async {
    final response = await _client.dio.post(
      '/clientes/mesas/vincular',
      data: request.toJson(),
    );
    return VincularMesaResponse.fromJson(response.data);
  }


  Future<PedidoResponse> crearPedido(PedidoCreateRequest request) async {
    final response = await _client.dio.post(
      '/pedidos/',
      data: request.toJson(),
    );
    return PedidoResponse.fromJson(response.data);
  }


  Future<AgregarPedidoResponse> agregarAPedido(
    String facturaLocalUuid,
    AgregarItemsRequest request,
  ) async {
    final response = await _client.dio.patch(
      '/clientes/pedidos/$facturaLocalUuid/agregar-items',
      data: request.toJson(),
    );
    return AgregarPedidoResponse.fromJson(response.data);
  }


  Future<ResumenCuentaResponse> getResumenCuenta(
      String facturaLocalUuid) async {
    final response = await _client.dio.get(
      '/clientes/pedidos/$facturaLocalUuid/resumen',
    );
    return ResumenCuentaResponse.fromJson(response.data);
  }


  Future<MensajeResponse> solicitarCuenta(
    String facturaLocalUuid,
    SolicitarCuentaRequest request,
  ) async {
    final response = await _client.dio.post(
      '/clientes/pedidos/$facturaLocalUuid/solicitar-cuenta',
      data: request.toJson(),
    );
    return MensajeResponse.fromJson(response.data);
  }


  Future<MensajeResponse> llamarMesero(
    int numeroMesa,
    LlamarMeseroRequest request,
  ) async {
    final response = await _client.dio.post(
      '/clientes/mesas/$numeroMesa/llamar-mesero',
      data: request.toJson(),
    );
    return MensajeResponse.fromJson(response.data);
  }
  
  /// Cancels the order identified by [facturaLocalUuid] within the
  /// customer self-cancel window.  The server authorises the request via
  /// the bearer token; no empleado_id is required.
  Future<void> cancelarPedido(String facturaLocalUuid) async {
    await _client.dio.post(
      '/pedidos/$facturaLocalUuid/cancelar',
      data: {'motivo': 'CLIENTE_CANCELO_VENTANA'},
    );
  }

  Future<void> logout() async {
    await _client.clearToken();
  }


  // ─── Password Reset ──────────────────────────────────────────────────────

  /// Requests a password reset email for the given [email].
  /// Returns the generic success message from the server.
  Future<ResetResponse> solicitarReset(String email) async {
    final response = await _client.dio.post(
      '/clientes/auth/solicitar-reset',
      data: SolicitarResetRequest(email: email).toJson(),
    );
    return ResetResponse.fromJson(response.data as Map<String, dynamic>);
  }

  /// Confirms a password reset using the [token] from the deep link
  /// and sets [passwordNuevo] as the new password.
  Future<ResetResponse> confirmarReset({
    required String token,
    required String passwordNuevo,
  }) async {
    final response = await _client.dio.post(
      '/clientes/auth/confirmar-reset',
      data: ConfirmarResetRequest(
        token: token,
        password_nuevo: passwordNuevo,
      ).toJson(),
    );
    return ResetResponse.fromJson(response.data as Map<String, dynamic>);
  }
}

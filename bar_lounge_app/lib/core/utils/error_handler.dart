import 'package:dio/dio.dart';

class ErrorHandler {
  /// Parses an exception (especially DioException) into a user-friendly string message.
  /// Prevents backend logic and database errors from bleeding into the UI.
  static String getMessage(dynamic error, {String fallback = 'An unexpected error occurred. Please try again.'}) {
    if (error is DioException) {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        return 'Connection timed out. Please check your internet connection and try again.';
      }

      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.unknown && error.message?.contains('SocketException') == true) {
        return 'Unable to connect to the server. Please check your internet connection.';
      }

      final data = error.response?.data;
      if (data != null && data is Map) {
        final detail = data['detail'];
        if (detail != null && detail is String) {
          final lowerDetail = detail.toLowerCase();
          // Filter out specific backend leaks
          if (lowerDetail.contains('duplicate key') || 
              lowerDetail.contains('registrado') || 
              lowerDetail.contains('ya est')) {
            return 'This email address is already registered. Please log in or use a different email.';
          }
          if (lowerDetail.contains('sql') ||
              lowerDetail.contains('database') ||
              lowerDetail.contains('foreign key') ||
              lowerDetail.contains('constraint') ||
              lowerDetail.contains('syntax')) {
            return 'A system error occurred while processing your request. Please try again later.';
          }
          if (lowerDetail.contains('incorrecta')) {
            return 'Your current password is incorrect.';
          }
          if (lowerDetail.contains('stock insuficiente')) {
            return 'Some items are no longer available in the requested quantity. Please review your order and try again.';
          }
          return _translateBackendMessage(detail);
        }
        if (detail is List && detail.isNotEmpty) {
          final first = detail.first;
          if (first is Map && first['msg'] is String) {
            return _translateBackendMessage(first['msg'] as String);
          }
        }
      }

      if (error.message != null && error.message!.isNotEmpty) {
        final lowerMessage = error.message!.toLowerCase();
        if (lowerMessage.contains('core no disponible') ||
            lowerMessage.contains('core unavailable')) {
          return 'We could not process your request right now. Please try again in a moment.';
        }
      }

      // Handle HTTP status codes explicitly if no detail is provided
      final statusCode = error.response?.statusCode;
      if (statusCode != null) {
        if (statusCode >= 500) {
          return 'The server encountered an error. Please try again later.';
        }
        if (statusCode == 404) {
          return 'The requested resource could not be found.';
        }
        if (statusCode == 403) {
          return 'You do not have permission to perform this action.';
        }
        if (statusCode == 401) {
          return 'Your session has expired or you are not authorized. Please log in again.';
        }
      }
      return 'A network error occurred. Please try again.';
    }

    if (error is Exception) {
      return error.toString().replaceAll('Exception: ', '');
    }

    return fallback;
  }

  static String _translateBackendMessage(String message) {
    return message
        .replaceAll('La contraseÃ±a actual es incorrecta.', 'Your current password is incorrect.')
        .replaceAll('La contraseña actual es incorrecta.', 'Your current password is incorrect.')
        .replaceAll('CORE no disponible. intente mas tarde.', 'We could not process your request right now. Please try again in a moment.')
        .replaceAll('CORE no disponible. Intente mas tarde.', 'We could not process your request right now. Please try again in a moment.')
        .replaceAll('El token de recuperaciÃ³n ha expirado. Solicita uno nuevo.', 'This reset link has expired. Please request a new one.')
        .replaceAll('El token de recuperación ha expirado. Solicita uno nuevo.', 'This reset link has expired. Please request a new one.')
        .replaceAll('Token de recuperaciÃ³n invÃ¡lido o ya utilizado.', 'This reset link is invalid or has already been used.')
        .replaceAll('Token de recuperación inválido o ya utilizado.', 'This reset link is invalid or has already been used.')
        .replaceAll('Value error, La nueva contraseÃ±a debe contener al menos una mayÃºscula.', 'Password must include at least one uppercase letter.')
        .replaceAll('Value error, La nueva contraseña debe contener al menos una mayúscula.', 'Password must include at least one uppercase letter.')
        .replaceAll('Value error, La nueva contraseÃ±a debe contener al menos una minÃºscula.', 'Password must include at least one lowercase letter.')
        .replaceAll('Value error, La nueva contraseña debe contener al menos una minúscula.', 'Password must include at least one lowercase letter.')
        .replaceAll('Value error, La nueva contraseÃ±a debe contener al menos un nÃºmero.', 'Password must include at least one number.')
        .replaceAll('Value error, La nueva contraseña debe contener al menos un número.', 'Password must include at least one number.');
  }
}

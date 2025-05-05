class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({required this.message, this.statusCode});
}

class CacheException implements Exception {
  final String message;

  CacheException({required this.message});
}

class NetworkException implements Exception {
  final String message;

  NetworkException({required this.message});
}

class AuthenticationException implements Exception {
  final String message;

  AuthenticationException({required this.message});
}

class PermissionException implements Exception {
  final String message;

  PermissionException({required this.message});
}

class ValidationException implements Exception {
  final String message;

  ValidationException({required this.message});
}

class NotFoundException implements Exception {
  final String message;

  NotFoundException({required this.message});
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});
}

class FileSystemException implements Exception {
  final String message;

  FileSystemException({required this.message});
}

class SubscriptionException implements Exception {
  final String message;

  SubscriptionException({required this.message});
}
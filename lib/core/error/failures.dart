import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? errorCode;

  const Failure({required this.message, this.errorCode});

  @override
  List<Object?> get props => [message, errorCode];
}

// Ошибки сети
class ServerFailure extends Failure {
  const ServerFailure({
    required String message,
    int? errorCode,
  }) : super(message: message, errorCode: errorCode);
}

class ConnectionFailure extends Failure {
  const ConnectionFailure({
    required String message,
    int? errorCode,
  }) : super(message: message, errorCode: errorCode);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({
    required String message,
    int? errorCode,
  }) : super(message: message, errorCode: errorCode);
}

// Ошибки базы данных
class DatabaseFailure extends Failure {
  const DatabaseFailure({
    required String message,
    int? errorCode,
  }) : super(message: message, errorCode: errorCode);
}

class CacheFailure extends Failure {
  const CacheFailure({
    required String message,
    int? errorCode,
  }) : super(message: message, errorCode: errorCode);
}

// Ошибки аутентификации
class AuthenticationFailure extends Failure {
  const AuthenticationFailure({
    required String message,
    int? errorCode,
  }) : super(message: message, errorCode: errorCode);
}

class PermissionFailure extends Failure {
  const PermissionFailure({
    required String message,
    int? errorCode,
  }) : super(message: message, errorCode: errorCode);
}

// Ошибки ввода данных
class ValidationFailure extends Failure {
  const ValidationFailure({
    required String message,
    int? errorCode,
  }) : super(message: message, errorCode: errorCode);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({
    required String message,
    int? errorCode,
  }) : super(message: message, errorCode: errorCode);
}

// Общие ошибки
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    required String message,
    int? errorCode,
  }) : super(message: message, errorCode: errorCode);
}

// Ошибки API
class ApiFailure extends Failure {
  const ApiFailure({
    required String message,
    int? errorCode,
  }) : super(message: message, errorCode: errorCode);
}

// Ошибки файловой системы
class FileSystemFailure extends Failure {
  const FileSystemFailure({
    required String message,
    int? errorCode,
  }) : super(message: message, errorCode: errorCode);
}

// Ошибки подписки
class SubscriptionFailure extends Failure {
  const SubscriptionFailure({
    required String message,
    int? errorCode,
  }) : super(message: message, errorCode: errorCode);
}
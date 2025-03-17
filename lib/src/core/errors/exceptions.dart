/// Base exception class for all app exceptions
abstract class AppException implements Exception {
  final String message;
  
  const AppException({required this.message});
  
  @override
  String toString() => message;
}

/// Exception thrown when there is a network-related issue
class NetworkException extends AppException {
  const NetworkException({required String message}) : super(message: message);
}

/// Exception thrown when there is an issue with the server
class ServerException extends AppException {
  const ServerException({required String message}) : super(message: message);
}

/// Exception thrown when the user is not authorized to access a resource
class UnauthorizedException extends AppException {
  const UnauthorizedException({required String message}) : super(message: message);
}

/// Exception thrown when the user is forbidden from accessing a resource
class ForbiddenException extends AppException {
  const ForbiddenException({required String message}) : super(message: message);
}

/// Exception thrown when a requested resource is not found
class NotFoundException extends AppException {
  const NotFoundException({required String message}) : super(message: message);
}

/// Exception thrown when there is an issue parsing data
class DataParsingException extends AppException {
  const DataParsingException({required String message}) : super(message: message);
}

/// Exception thrown when there is a cache-related issue
class CacheException extends AppException {
  const CacheException({required String message}) : super(message: message);
}

/// Exception thrown when there is an issue with user input validation
class ValidationException extends AppException {
  const ValidationException({required String message}) : super(message: message);
}

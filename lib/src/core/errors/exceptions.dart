// Define custom exceptions here
class AppException implements Exception {
  final String message;
  AppException({this.message = 'An unexpected error occurred.'});

  @override
  String toString() => 'AppException: $message';
}

class CacheException extends AppException {
  CacheException({super.message = 'Failed to retrieve data from cache.'});
}

class ServerException extends AppException {
  ServerException({super.message = 'Failed to retrieve data from the server.'});
}

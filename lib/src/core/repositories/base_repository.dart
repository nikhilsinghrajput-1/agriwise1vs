import 'package:myapp/src/core/errors/exceptions.dart';
import 'package:myapp/src/core/network/connectivity_service.dart';

/// A class that represents the result of a repository operation
class Result<T> {
  final T? data;
  final AppException? error;
  final bool isSuccess;
  
  const Result._({
    this.data,
    this.error,
    required this.isSuccess,
  });
  
  /// Creates a successful result with data
  factory Result.success(T data) => Result._(
    data: data,
    isSuccess: true,
  );
  
  /// Creates a failed result with an error
  factory Result.failure(AppException error) => Result._(
    error: error,
    isSuccess: false,
  );
  
  /// Maps the result to a new type using the provided function
  Result<R> map<R>(R Function(T data) mapper) {
    if (isSuccess && data != null) {
      return Result.success(mapper(data));
    } else {
      return Result._(
        error: error,
        isSuccess: false,
      );
    }
  }
}

/// Base repository class that all repositories should extend
abstract class BaseRepository {
  final ConnectivityService _connectivityService;
  
  BaseRepository({
    required ConnectivityService connectivityService,
  }) : _connectivityService = connectivityService;
  
  /// Executes a repository operation with error handling
  Future<Result<T>> safeApiCall<T>(Future<T> Function() apiCall) async {
    try {
      // Check for internet connection
      final hasConnection = await _connectivityService.hasInternetConnection();
      if (!hasConnection) {
        return Result.failure(
          const NetworkException(
            message: 'No internet connection. Please check your network.',
          ),
        );
      }
      
      // Execute the API call
      final data = await apiCall();
      return Result.success(data);
    } on AppException catch (e) {
      return Result.failure(e);
    } catch (e) {
      return Result.failure(
        ServerException(
          message: 'An unexpected error occurred: ${e.toString()}',
        ),
      );
    }
  }
  
  /// Executes a repository operation with cached fallback
  Future<Result<T>> safeApiCallWithCache<T>({
    required Future<T> Function() apiCall,
    required Future<T?> Function() getCachedData,
    required Future<void> Function(T data) cacheData,
  }) async {
    try {
      // Check for internet connection
      final hasConnection = await _connectivityService.hasInternetConnection();
      
      if (hasConnection) {
        // If we have internet, make the API call
        final data = await apiCall();
        
        // Cache the data for offline use
        await cacheData(data);
        
        return Result.success(data);
      } else {
        // If no internet, try to get cached data
        final cachedData = await getCachedData();
        
        if (cachedData != null) {
          return Result.success(cachedData);
        } else {
          return Result.failure(
            const NetworkException(
              message: 'No internet connection and no cached data available.',
            ),
          );
        }
      }
    } on AppException catch (e) {
      // For app exceptions, try to get cached data as fallback
      try {
        final cachedData = await getCachedData();
        
        if (cachedData != null) {
          return Result.success(cachedData);
        } else {
          return Result.failure(e);
        }
      } catch (_) {
        return Result.failure(e);
      }
    } catch (e) {
      // For unexpected exceptions, try to get cached data as fallback
      try {
        final cachedData = await getCachedData();
        
        if (cachedData != null) {
          return Result.success(cachedData);
        } else {
          return Result.failure(
            ServerException(
              message: 'An unexpected error occurred: ${e.toString()}',
            ),
          );
        }
      } catch (_) {
        return Result.failure(
          ServerException(
            message: 'An unexpected error occurred: ${e.toString()}',
          ),
        );
      }
    }
  }
} 
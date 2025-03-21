import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/src/core/errors/exceptions.dart';

class ApiClient {
  final http.Client _client;
  final String _baseUrl;
  
  ApiClient({
    required http.Client client,
    required String baseUrl,
  }) : _client = client, _baseUrl = baseUrl;
  
  /// Makes a GET request to the specified endpoint with error handling and caching
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
    bool useCache = true,
    Duration cacheDuration = const Duration(hours: 1),
  }) async {
    try {
      // Check for cached data first if useCache is true
      if (useCache) {
        final cachedData = await _getCachedData(endpoint);
        if (cachedData != null) {
          return cachedData;
        }
      }
      
      // If no cached data or cache not requested, make the network request
      final uri = Uri.parse('$_baseUrl$endpoint');
      final response = await _client.get(
        uri,
        headers: headers ?? {'Content-Type': 'application/json'},
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw const NetworkException(
            message: 'Request timeout. Please check your internet connection.',
          );
        },
      );
      
      // Handle response
      final data = _handleResponse(response);
      
      // Cache the response if useCache is true
      if (useCache) {
        await _cacheData(endpoint, data, cacheDuration);
      }
      
      return data;
    } on SocketException {
      throw const NetworkException(
        message: 'No internet connection. Please check your network.',
      );
    } on HttpException {
      throw const NetworkException(
        message: 'Could not complete the request. Please try again.',
      );
    } on FormatException {
      throw const DataParsingException(
        message: 'Invalid response format. Please try again later.',
      );
    } catch (e) {
      if (e is NetworkException || e is DataParsingException) {
        rethrow;
      }
      throw ServerException(
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }
  
  /// Makes a POST request to the specified endpoint with error handling
  Future<Map<String, dynamic>> post(
    String endpoint, {
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final response = await _client.post(
        uri,
        headers: headers ?? {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw const NetworkException(
            message: 'Request timeout. Please check your internet connection.',
          );
        },
      );
      
      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException(
        message: 'No internet connection. Please check your network.',
      );
    } on HttpException {
      throw const NetworkException(
        message: 'Could not complete the request. Please try again.',
      );
    } on FormatException {
      throw const DataParsingException(
        message: 'Invalid response format. Please try again later.',
      );
    } catch (e) {
      if (e is NetworkException || e is DataParsingException) {
        rethrow;
      }
      throw ServerException(
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Makes a DELETE request to the specified endpoint with error handling
  Future<Map<String, dynamic>> delete(
      String endpoint, {
        Map<String, String>? headers,
      }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final response = await _client.delete(
        uri,
        headers: headers ?? {'Content-Type': 'application/json'},
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw const NetworkException(
            message: 'Request timeout. Please check your internet connection.',
          );
        },
      );

      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException(
        message: 'No internet connection. Please check your network.',
      );
    } on HttpException {
      throw const NetworkException(
        message: 'Could not complete the request. Please try again.',
      );
    } on FormatException {
      throw const DataParsingException(
        message: 'Invalid response format. Please try again later.',
      );
    } catch (e) {
      if (e is NetworkException || e is DataParsingException) {
        rethrow;
      }
      throw ServerException(
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }
  
  /// Handles HTTP response and returns parsed data or throws appropriate exception
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        return jsonDecode(response.body);
      } catch (e) {
        throw const DataParsingException(
          message: 'Failed to parse response data. Please try again later.',
        );
      }
    } else if (response.statusCode == 401) {
      throw const UnauthorizedException(
        message: 'Unauthorized access. Please login again.',
      );
    } else if (response.statusCode == 403) {
      throw const ForbiddenException(
        message: 'You don\'t have permission to access this resource.',
      );
    } else if (response.statusCode == 404) {
      throw const NotFoundException(
        message: 'The requested resource was not found.',
      );
    } else if (response.statusCode >= 500) {
      throw const ServerException(
        message: 'Server error. Please try again later.',
      );
    } else {
      throw ServerException(
        message: 'Error: ${response.statusCode}. ${response.reasonPhrase}',
      );
    }
  }
  
  /// Retrieves cached data for the given endpoint if it exists and is not expired
  Future<Map<String, dynamic>?> _getCachedData(String endpoint) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = 'api_cache_$endpoint';
      final expiryKey = 'api_cache_expiry_$endpoint';
      
      // Check if cache exists
      if (!prefs.containsKey(cacheKey) || !prefs.containsKey(expiryKey)) {
        return null;
      }
      
      // Check if cache is expired
      final expiryTime = DateTime.fromMillisecondsSinceEpoch(
        prefs.getInt(expiryKey) ?? 0
      );
      if (DateTime.now().isAfter(expiryTime)) {
        // Cache expired, remove it
        await prefs.remove(cacheKey);
        await prefs.remove(expiryKey);
        return null;
      }
      
      // Return cached data
      final cachedData = prefs.getString(cacheKey);
      if (cachedData != null) {
        return jsonDecode(cachedData);
      }
      
      return null;
    } catch (e) {
      // If there's any error with cache, just return null and proceed with network request
      return null;
    }
  }
  
  /// Caches the response data for the given endpoint with an expiry time
  Future<void> _cacheData(
    String endpoint,
    Map<String, dynamic> data,
    Duration cacheDuration,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = 'api_cache_$endpoint';
      final expiryKey = 'api_cache_expiry_$endpoint';
      
      // Calculate expiry time
      final expiryTime = DateTime.now().add(cacheDuration);
      
      // Save data and expiry time
      await prefs.setString(cacheKey, jsonEncode(data));
      await prefs.setInt(expiryKey, expiryTime.millisecondsSinceEpoch);
    } catch (e) {
      // If caching fails, just log and continue
      print('Failed to cache data: $e');
    }
  }
  
  /// Clears all cached API responses
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      
      for (final key in keys) {
        if (key.startsWith('api_cache_')) {
          await prefs.remove(key);
        }
      }
    } catch (e) {
      print('Failed to clear cache: $e');
    }
  }
}

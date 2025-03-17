import 'dart:async';
import 'dart:io';

/// A service to check and monitor network connectivity
class ConnectivityService {
  /// Checks if the device has an active internet connection
  Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } catch (_) {
      return false;
    }
  }
  
  /// Periodically checks for internet connection until it's available
  /// Returns a stream that emits true when connection is established
  Stream<bool> waitForInternetConnection({
    Duration checkInterval = const Duration(seconds: 3),
  }) async* {
    while (true) {
      final hasConnection = await hasInternetConnection();
      yield hasConnection;
      
      if (hasConnection) {
        break;
      }
      
      await Future.delayed(checkInterval);
    }
  }
} 
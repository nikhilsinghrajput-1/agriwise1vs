import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:myapp/src/core/errors/exceptions.dart';
import 'package:myapp/src/core/network/api_client.dart';
import 'package:myapp/src/features/home/data/models/advisory_model.dart';
import 'package:myapp/src/features/home/domain/entities/advisory.dart';

class AdvisoryRemoteDataSource {
  final ApiClient apiClient;
  
  AdvisoryRemoteDataSource({required this.apiClient});

  Future<List<Advisory>> getAdvisories() async {
    try {
      // In a real app, this would be an API call
      // For now, we'll load from a local JSON file or return mock data
      return _getMockAdvisories();
      
      // When API is ready, use this code instead:
      // final response = await apiClient.get('/advisories');
      // final List<dynamic> advisoriesJson = response['data'];
      // return advisoriesJson
      //     .map((json) => Advisory.fromModel(AdvisoryModel.fromJson(json)))
      //     .toList();
    } on Exception {
      throw ServerException(message: 'Failed to load advisories');
    }
  }

  List<Advisory> _getMockAdvisories() {
    return [
      Advisory.fromModel(AdvisoryModel.fromJson({
        'type': 'warning',
        'description': 'Heavy rainfall expected in the next 24 hours. Protect your crops.',
        'icon': 'warning',
        'color': 'orange',
        'priority': 'High',
      })),
      Advisory.fromModel(AdvisoryModel.fromJson({
        'type': 'info',
        'description': 'Optimal time for wheat irrigation is early morning to reduce evaporation loss.',
        'icon': 'info',
        'color': 'blue',
        'priority': 'Medium',
      })),
      Advisory.fromModel(AdvisoryModel.fromJson({
        'type': 'success',
        'description': 'Your rice crop is in good health based on recent satellite imagery.',
        'icon': 'success',
        'color': 'green',
        'priority': 'Low',
      })),
    ];
  }
}

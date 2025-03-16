import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:myapp/src/features/home/data/models/crop_health_model.dart';

class CropHealthRemoteDataSource {
  Future<CropHealthModel> getCropHealthData() async {
    final String response =
        await rootBundle.loadString('assets/crop_health.json');
    final data = await json.decode(response);
    return CropHealthModel.fromJson(data);
  }
}

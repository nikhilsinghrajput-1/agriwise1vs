import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:myapp/src/features/home/data/models/soil_moisture_model.dart';

class SoilMoistureRemoteDataSource {
  Future<SoilMoistureModel> getSoilMoistureData() async {
    final String response =
        await rootBundle.loadString('assets/soil_moisture.json');
    final data = await json.decode(response);
    return SoilMoistureModel.fromJson(data);
  }
}

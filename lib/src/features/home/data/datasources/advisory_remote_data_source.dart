import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:myapp/src/features/home/data/models/advisory_model.dart';

class AdvisoryRemoteDataSource {
  Future<AdvisoryModel> getAdvisoryData() async {
    final String response =
        await rootBundle.loadString('assets/advisory.json');
    final data = await json.decode(response);
    return AdvisoryModel.fromJson(data);
  }
}

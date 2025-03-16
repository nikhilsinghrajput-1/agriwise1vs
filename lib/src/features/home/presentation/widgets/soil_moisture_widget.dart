import 'package:flutter/material.dart';
import 'package:myapp/src/features/home/data/datasources/soil_moisture_remote_data_source.dart';
import 'package:myapp/src/features/home/data/repositories/soil_moisture_repository_impl.dart';
import 'package:myapp/src/features/home/data/models/soil_moisture_model.dart';
import 'package:myapp/src/features/home/domain/usecases/get_soil_moisture_data.dart';

class SoilMoistureWidget extends StatelessWidget {
  const SoilMoistureWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final SoilMoistureRemoteDataSource remoteDataSource =
        SoilMoistureRemoteDataSource();
    final SoilMoistureRepositoryImpl repository =
        SoilMoistureRepositoryImpl(remoteDataSource: remoteDataSource);
    final GetSoilMoistureData getSoilMoistureData =
        GetSoilMoistureData(repository: repository);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<SoilMoistureModel>(
          future: getSoilMoistureData.execute(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Soil Moisture',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.opacity, color: Colors.blue),
                      const SizedBox(width: 5),
                      Text('Moisture: ${data.moisture}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

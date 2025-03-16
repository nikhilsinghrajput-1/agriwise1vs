import 'package:flutter/material.dart';
import 'package:myapp/src/features/home/data/datasources/crop_health_remote_data_source.dart';
import 'package:myapp/src/features/home/data/repositories/crop_health_repository_impl.dart';
import 'package:myapp/src/features/home/data/models/crop_health_model.dart';
import 'package:myapp/src/features/home/domain/usecases/get_crop_health_data.dart';

class CropHealthWidget extends StatelessWidget {
  const CropHealthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final CropHealthRemoteDataSource remoteDataSource =
        CropHealthRemoteDataSource();
    final CropHealthRepositoryImpl repository =
        CropHealthRepositoryImpl(remoteDataSource: remoteDataSource);
    final GetCropHealthData getCropHealthData =
        GetCropHealthData(repository: repository);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<CropHealthModel>(
          future: getCropHealthData.execute(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Crop Health',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.local_florist, color: Colors.green),
                      const SizedBox(width: 5),
                      Text(data.health,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Text('Optimal: ${data.optimal}',
                      style: const TextStyle(fontStyle: FontStyle.italic)),
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

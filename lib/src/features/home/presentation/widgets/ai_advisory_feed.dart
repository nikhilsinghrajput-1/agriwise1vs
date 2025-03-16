import 'package:flutter/material.dart';
import 'package:myapp/src/features/home/data/datasources/advisory_remote_data_source.dart';
import 'package:myapp/src/features/home/data/repositories/advisory_repository_impl.dart';
import 'package:myapp/src/features/home/domain/usecases/get_advisory_data.dart';

class AIAdvisoryFeed extends StatelessWidget {
  const AIAdvisoryFeed({super.key});

  @override
  Widget build(BuildContext context) {
    final AdvisoryRemoteDataSource remoteDataSource = AdvisoryRemoteDataSource();
    final AdvisoryRepositoryImpl repository =
        AdvisoryRepositoryImpl(remoteDataSource: remoteDataSource);
    final GetAdvisoryData getAdvisoryData =
        GetAdvisoryData(repository: repository);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: getAdvisoryData.execute(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!;
              // Extract relevant advisory information from the data
              final description = data['description'];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Advisory Summary',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.warning, color: Colors.yellow),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          description,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
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

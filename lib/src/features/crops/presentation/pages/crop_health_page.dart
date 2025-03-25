import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/crop_health_bloc.dart';
import '../bloc/crop_health_event.dart';
import '../bloc/crop_health_state.dart';
import '../widgets/health_record_card.dart';
import 'add_health_record_page.dart';
import '../../domain/entities/crop.dart'; // Added import

class CropHealthPage extends StatelessWidget {
  final Crop crop;

  const CropHealthPage({
    super.key,
    required this.crop,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CropHealthBloc(
        context.read(),
        crop.id,
      )..add(LoadCropHealthHistory()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('${crop.name} Health'),
        ),
        body: BlocBuilder<CropHealthBloc, CropHealthState>(
          builder: (context, state) {
            if (state is CropHealthLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CropHealthError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<CropHealthBloc>().add(LoadCropHealthHistory());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is CropHealthLoaded) {
              return state.records.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('No health records found'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddHealthRecordPage(crop: crop),
                                ),
                              );
                            },
                            child: const Text('Add First Record'),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.records.length,
                      itemBuilder: (context, index) {
                        final record = state.records[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: HealthRecordCard(
                            record: record,
                            onDelete: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Record'),
                                  content: const Text(
                                    'Are you sure you want to delete this health record?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context
                                            .read<CropHealthBloc>()
                                            .add(DeleteCropHealthRecord(record.id));
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
            }

            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddHealthRecordPage(crop: crop),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

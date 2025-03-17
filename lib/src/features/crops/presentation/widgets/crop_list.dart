import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependency_injection.dart';
import '../bloc/crop_bloc.dart';
import '../bloc/crop_event.dart';
import '../bloc/crop_state.dart';
import '../../domain/entities/crop.dart';
import '../pages/add_crop_page.dart';
import 'crop_card.dart';

class CropList extends StatelessWidget {
  const CropList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CropBloc>()..add(LoadUserCrops('current_user_id')),
      child: BlocBuilder<CropBloc, CropState>(
        builder: (context, state) {
          if (state is CropLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is CropError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CropBloc>().add(LoadUserCrops('current_user_id'));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is CropLoaded) {
            return Scaffold(
              body: state.crops.isEmpty
                  ? const Center(
                      child: Text('No crops found. Add your first crop!'),
                    )
                  : ListView.builder(
                      itemCount: state.crops.length,
                      itemBuilder: (context, index) {
                        final crop = state.crops[index];
                        return CropCard(crop: crop);
                      },
                    ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddCropPage(),
                    ),
                  );
                },
                child: const Icon(Icons.add),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
} 
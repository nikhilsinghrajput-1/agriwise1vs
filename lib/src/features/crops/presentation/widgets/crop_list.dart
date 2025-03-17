import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/crop_bloc.dart';
import '../bloc/crop_event.dart';
import '../bloc/crop_state.dart';
import '../../domain/entities/crop.dart';
import 'crop_card.dart';

class CropList extends StatelessWidget {
  final String userId;

  const CropList({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CropBloc(context.read())..add(LoadUserCrops(userId)),
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
                      context.read<CropBloc>().add(LoadUserCrops(userId));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is CropLoaded) {
            if (state.crops.isEmpty) {
              return const Center(
                child: Text('No crops found. Add your first crop!'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.crops.length,
              itemBuilder: (context, index) {
                final crop = state.crops[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: CropCard(
                    crop: crop,
                    onTap: () {
                      // TODO: Navigate to crop details
                    },
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
} 
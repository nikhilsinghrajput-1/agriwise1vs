import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/models/crop_model.dart';
import '../bloc/crop_health_bloc.dart';
import '../bloc/crop_health_event.dart';
import '../bloc/crop_health_state.dart';
import 'dart:io';

class CropDiseaseDetectionPage extends StatefulWidget {
  final Crop crop;

  const CropDiseaseDetectionPage({
    Key? key,
    required this.crop,
  }) : super(key: key);

  @override
  State<CropDiseaseDetectionPage> createState() => _CropDiseaseDetectionPageState();
}

class _CropDiseaseDetectionPageState extends State<CropDiseaseDetectionPage> {
  File? _image;
  bool _isAnalyzing = false;
  String? _diseaseResult;
  String? _confidence;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    
    if (image != null) {
      setState(() {
        _image = File(image.path);
        _isAnalyzing = true;
        _diseaseResult = null;
        _confidence = null;
      });
      
      // TODO: Implement actual disease detection logic
      // For now, we'll simulate the detection
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        _isAnalyzing = false;
        _diseaseResult = 'Leaf Blight';
        _confidence = '85%';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.crop.name} Disease Detection'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Instructions',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '1. Position the camera to capture the affected area clearly\n'
                      '2. Ensure good lighting conditions\n'
                      '3. Hold the camera steady\n'
                      '4. Take multiple photos if needed',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_image != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  _image!,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              if (_isAnalyzing)
                const Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Analyzing image...'),
                    ],
                  ),
                )
              else if (_diseaseResult != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Detection Result',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        _buildResultRow('Disease', _diseaseResult!),
                        const SizedBox(height: 8),
                        _buildResultRow('Confidence', _confidence!),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            context.read<CropHealthBloc>().add(
                              AddCropHealth(
                                cropId: widget.crop.id,
                                soilMoisture: 0, // These values will be updated
                                temperature: 0,  // when we implement actual
                                humidity: 0,     // sensor integration
                                diseaseStatus: _diseaseResult!,
                                notes: 'Disease detected: $_diseaseResult',
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Health record updated'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.save),
                          label: const Text('Save Result'),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Take Photo'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
} 
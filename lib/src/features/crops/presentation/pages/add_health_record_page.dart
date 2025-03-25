import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/crop_health_model.dart';
import '../bloc/crop_health_bloc.dart';
import '../bloc/crop_health_event.dart';
import '../bloc/crop_health_state.dart';
import '../../domain/entities/crop.dart';

class AddHealthRecordPage extends StatefulWidget {
  final Crop crop;

  const AddHealthRecordPage({
    super.key,
    required this.crop,
  });

  @override
  State<AddHealthRecordPage> createState() => _AddHealthRecordPageState();
}

class _AddHealthRecordPageState extends State<AddHealthRecordPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _soilMoistureController;
  late TextEditingController _temperatureController;
  late TextEditingController _humidityController;
  late TextEditingController _diseaseStatusController;
  late TextEditingController _notesController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _soilMoistureController = TextEditingController();
    _temperatureController = TextEditingController();
    _humidityController = TextEditingController();
    _diseaseStatusController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _soilMoistureController.dispose();
    _temperatureController.dispose();
    _humidityController.dispose();
    _diseaseStatusController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final record = CropHealth(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        cropId: widget.crop.id,
        date: DateTime.now(),
        soilMoisture: double.parse(_soilMoistureController.text),
        temperature: double.parse(_temperatureController.text),
        humidity: double.parse(_humidityController.text),
        diseaseStatus: _diseaseStatusController.text,
        notes: _notesController.text,
      );

      context.read<CropHealthBloc>().add(AddCropHealthRecord(record));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Health Record'),
      ),
      body: BlocListener<CropHealthBloc, CropHealthState>(
        listener: (context, state) {
          if (state is CropHealthRecordAdded) {
            Navigator.pop(context);
          } else if (state is CropHealthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            setState(() => _isLoading = false);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _soilMoistureController,
                  decoration: const InputDecoration(
                    labelText: 'Soil Moisture (%)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter soil moisture';
                    }
                    final number = double.tryParse(value);
                    if (number == null) {
                      return 'Please enter a valid number';
                    }
                    if (number < 0 || number > 100) {
                      return 'Soil moisture must be between 0 and 100';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _temperatureController,
                  decoration: const InputDecoration(
                    labelText: 'Temperature (°C)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter temperature';
                    }
                    final number = double.tryParse(value);
                    if (number == null) {
                      return 'Please enter a valid number';
                    }
                    if (number < -50 || number > 50) {
                      return 'Temperature must be between -50 and 50';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _humidityController,
                  decoration: const InputDecoration(
                    labelText: 'Humidity (%)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter humidity';
                    }
                    final number = double.tryParse(value);
                    if (number == null) {
                      return 'Please enter a valid number';
                    }
                    if (number < 0 || number > 100) {
                      return 'Humidity must be between 0 and 100';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _diseaseStatusController.text.isEmpty
                      ? null
                      : _diseaseStatusController.text,
                  decoration: const InputDecoration(
                    labelText: 'Disease Status',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Healthy',
                      child: Text('Healthy'),
                    ),
                    DropdownMenuItem(
                      value: 'Mild',
                      child: Text('Mild'),
                    ),
                    DropdownMenuItem(
                      value: 'Severe',
                      child: Text('Severe'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _diseaseStatusController.text = value ?? '';
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select disease status';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Add Record'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

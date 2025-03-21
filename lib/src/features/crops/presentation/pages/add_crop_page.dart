import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/crop_bloc.dart';
import '../bloc/crop_event.dart';
import '../bloc/crop_state.dart';
import '../../domain/entities/crop.dart';
import 'package:myapp/src/core/theme/colors.dart';

class AddCropPage extends StatefulWidget {
  final Crop? crop; // If null, we're adding a new crop. If not, we're editing.

  const AddCropPage({
    super.key,
    this.crop,
  });

  @override
  State<AddCropPage> createState() => _AddCropPageState();
}

class _AddCropPageState extends State<AddCropPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _varietyController;
  DateTime _plantingDate = DateTime.now();
  DateTime _expectedHarvestDate = DateTime.now().add(const Duration(days: 90));
  String _status = 'Planted';

  final List<String> _statusOptions = [
    'Planted',
    'Growing',
    'Harvested',
    'Failed',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.crop?.name ?? '');
    _varietyController = TextEditingController(text: widget.crop?.variety ?? '');
    if (widget.crop != null) {
      _plantingDate = widget.crop!.plantingDate;
      _expectedHarvestDate = widget.crop!.expectedHarvestDate;
      _status = widget.crop!.status;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _varietyController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isPlantingDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isPlantingDate ? _plantingDate : _expectedHarvestDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != (isPlantingDate ? _plantingDate : _expectedHarvestDate)) {
      setState(() {
        if (isPlantingDate) {
          _plantingDate = picked;
        } else {
          _expectedHarvestDate = picked;
        }
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final crop = Crop(
        id: widget.crop?.id ?? '',
        userId: widget.crop?.userId ?? '', // This should be set by the bloc
        name: _nameController.text,
        variety: _varietyController.text,
        plantingDate: _plantingDate,
        expectedHarvestDate: _expectedHarvestDate,
        status: _status,
        createdAt: widget.crop?.createdAt ?? DateTime.now(),
      );

      if (widget.crop == null) {
        context.read<CropBloc>().add(AddCrop(crop));
      } else {
        context.read<CropBloc>().add(UpdateCrop(crop));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.crop == null ? 'Add New Crop' : 'Edit Crop'),
backgroundColor: AppColors.primaryColor,
      ),
      body: BlocListener<CropBloc, CropState>(
        listener: (context, state) {
          if (state is CropAdded || state is CropUpdated) {
            Navigator.pop(context);
          } else if (state is CropError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
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
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Crop Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter crop name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _varietyController,
                  decoration: const InputDecoration(
                    labelText: 'Variety',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter variety';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Planting Date'),
                  subtitle: Text(
                    DateFormat('dd/MM/yyyy').format(_plantingDate),
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context, true),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Expected Harvest Date'),
                  subtitle: Text(
                    DateFormat('dd/MM/yyyy').format(_expectedHarvestDate),
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context, false),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _status,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                  ),
                  items: _statusOptions.map((String status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _status = newValue;
                      });
                    }
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    widget.crop == null ? 'Add Crop' : 'Update Crop',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

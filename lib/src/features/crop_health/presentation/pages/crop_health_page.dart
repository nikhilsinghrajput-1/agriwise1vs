import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CropHealthPage extends StatefulWidget {
  const CropHealthPage({super.key});

  @override
  State<CropHealthPage> createState() => _CropHealthPageState();
}

class _CropHealthPageState extends State<CropHealthPage> {
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Health & Diagnosis', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Image Upload Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Upload Image',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _pickImage(ImageSource.camera);
                        },
                        child: const Text('Take Photo'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _pickImage(ImageSource.gallery);
                        },
                        child: const Text('Choose from Gallery'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: _image != null
                        ? Image.file(
                            _image!,
                            fit: BoxFit.cover,
                          )
                        : const Center(
                            child: Text('Image Preview'),
                          ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement AI analysis functionality
                    },
                    child: const Text('Analyze'),
                  ),
                ],
              ),
            ),
          ),

          // Disease Detection Results Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Disease Detection Results',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text('No disease detected. Your crop looks healthy!'),
                ],
              ),
            ),
          ),

          // Manual Selection of Crop Diseases
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Manual Disease Selection',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<String>(
                    items: const [
                      DropdownMenuItem(value: 'disease1', child: Text('Disease 1')),
                      DropdownMenuItem(value: 'disease2', child: Text('Disease 2')),
                    ],
                    onChanged: (value) {
                      // TODO: Implement disease selection functionality
                    },
                    hint: const Text('Select Disease'),
                  ),
                ],
              ),
            ),
          ),

          // Recommended Solutions Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Recommended Solutions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text('No solutions available. Select a disease to view solutions.'),
                ],
              ),
            ),
          ),

          // Nearby Agricultural Support Centers
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Nearby Agricultural Support Centers',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text('No support centers found.'),
                ],
              ),
            ),
          ),

          // Report & Feedback Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Report & Feedback',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text('Report incorrect AI detections or provide feedback.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

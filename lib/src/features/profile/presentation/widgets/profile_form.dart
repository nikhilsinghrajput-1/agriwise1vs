import 'package:flutter/material.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key});

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _bio = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
              onSaved: (value) {
                _name = value!;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Bio'),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your bio';
                }
                return null;
              },
              onSaved: (value) {
                _bio = value!;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // TODO: Implement update profile logic
                  print('Name: $_name, Bio: $_bio');
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

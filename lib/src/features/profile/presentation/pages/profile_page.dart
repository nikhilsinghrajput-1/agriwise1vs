import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _name = '';
  String _location = '';
  String _cropType = '';
  String _language = 'en';
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? '';
      _location = prefs.getString('location') ?? '';
      _cropType = prefs.getString('cropType') ?? '';
      _language = prefs.getString('language') ?? 'en';
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    });
  }

  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _name);
    await prefs.setString('location', _location);
    await prefs.setString('cropType', _cropType);
    await prefs.setString('language', _language);
    await prefs.setBool('notificationsEnabled', _notificationsEnabled);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        children: [
          // User Information Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        child: Icon(Icons.person),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {},
                            iconSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Name'),
                    initialValue: _name,
                    onChanged: (value) {
                      setState(() {
                        _name = value;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Location'),
                    initialValue: _location,
                    onChanged: (value) {
                      setState(() {
                        _location = value;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Crop Type'),
                    initialValue: _cropType,
                    onChanged: (value) {
                      setState(() {
                        _cropType = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          // Settings Section
          Card(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Language'),
                  trailing: DropdownButton<String>(
                    value: _language,
                    items: const [
                      DropdownMenuItem(value: 'en', child: Text('English')),
                      DropdownMenuItem(value: 'hi', child: Text('Hindi')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _language = value!;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Notifications'),
                  trailing: Switch(
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // Save Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                _saveProfile();
              },
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}

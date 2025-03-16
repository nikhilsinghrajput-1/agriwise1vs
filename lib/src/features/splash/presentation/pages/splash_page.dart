import 'package:flutter/material.dart';
import 'package:myapp/src/features/authentication/presentation/pages/login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Simulate a delay before navigating to the login screen
    Future.delayed(const Duration(seconds: 3), () {
      // Replace this with your actual navigation logic to the login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Agriwise logo
            const FlutterLogo(size: 100),
            const SizedBox(height: 20),
            // App name
            const Text(
              'Agriwise',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

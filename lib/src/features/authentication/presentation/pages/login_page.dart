import 'package:flutter/material.dart';
import 'onboarding_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey[800],
              child: const Center(
                child: Text(
                  'Agriwise',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                      onPressed: () {
                        // Simulate successful login
                        // Navigate to onboarding page
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => OnboardingPage()),
                        );
                      },
                      child: const Text('Continue with Google'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

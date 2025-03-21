import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/src/core/di/dependency_injection.dart';
import 'src/features/splash/presentation/pages/splash_page.dart';
import 'src/features/authentication/presentation/pages/login_page.dart';
import 'src/features/authentication/presentation/pages/onboarding_page.dart';
import 'src/features/weather/presentation/pages/weather_details_page.dart';
import 'src/features/crop_health/presentation/pages/crop_health_page.dart';
import 'src/features/soil_irrigation/presentation/pages/soil_irrigation_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependencies
  final di = DependencyInjection();
  await di.init();
  
  // Check if user has seen onboarding
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

  // Check if user is already logged in
  final userResult = await di.getCurrentUser.execute();
  final isLoggedIn = userResult.isSuccess && userResult.data != null;

  Widget initialRoute;
  if (!hasSeenOnboarding) {
    initialRoute = OnboardingPage();
  } else if (!isLoggedIn) {
    initialRoute = LoginPage();
  } else {
    initialRoute = SplashPage();
  }

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final Widget initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agriwise',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => initialRoute,
        '/login': (context) => LoginPage(),
        '/onboarding': (context) => OnboardingPage(),
        '/weather_details': (context) => const WeatherDetailsPage(),
        '/crop_health': (context) => const CropHealthPage(),
        '/soil_irrigation': (context) => const SoilIrrigationPage(),
      },
    );
  }
}

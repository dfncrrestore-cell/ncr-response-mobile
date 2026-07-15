import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/emergency_request_screen.dart';
import 'screens/office_dashboard_screen.dart';
import 'screens/ai_scan_screen.dart';
import 'screens/job_status_screen.dart';
import 'screens/profile_screen.dart';

class NcrResponseApp extends StatelessWidget {
  const NcrResponseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NCR Response Mobile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => const SplashScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        RegisterScreen.routeName: (context) => const RegisterScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
        EmergencyRequestScreen.routeName: (context) => const EmergencyRequestScreen(),
        OfficeDashboardScreen.routeName: (context) => const OfficeDashboardScreen(),
        AiScanScreen.routeName: (context) => const AiScanScreen(),
        JobStatusScreen.routeName: (context) => const JobStatusScreen(),
        ProfileScreen.routeName: (context) => const ProfileScreen(),
      },
    );
  }
}

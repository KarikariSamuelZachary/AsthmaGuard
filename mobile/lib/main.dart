import 'package:flutter/material.dart';
import 'screens/auth/signup_page.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/dashboard_screen.dart';
import 'screens/auth/otp_verification_screen.dart';
import 'screens/auth/welcome_screen.dart'; // Import the new welcome screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/signup', // Or '/login' if you want to test that first
      routes: {
        '/signup': (context) => const SignupScreen(),
        '/otp': (context) => const OtpVerificationScreen(),
        '/login': (context) => const LoginScreen(),
        '/welcome': (context) =>
            const WelcomeScreen(), // Add the welcome screen route
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}

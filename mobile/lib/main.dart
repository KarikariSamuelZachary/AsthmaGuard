import 'package:flutter/material.dart';
import 'screens/auth/signup_page.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/dashboard_screen.dart';
import 'screens/auth/otp_verification_screen.dart';

void main() {
  runApp(MyApp());
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
      initialRoute: '/signup',
      routes: {
        '/signup': (context) => SignupScreen(),
        '/otp': (context) => OtpVerificationScreen(),
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => DashboardScreen(),
      },
    );
  }
}

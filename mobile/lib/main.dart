import 'package:flutter/material.dart';
import 'screens/auth/signup_page.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/dashboard_screen.dart';
import 'screens/auth/otp_verification_screen.dart';
import 'screens/auth/welcome_screen.dart'; // Import the new welcome screen
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/screens/pollution_tracker/pollution_tracker_screen.dart';
import 'screens/auth/forgotpassword_screen.dart'; // Import ForgotPasswordScreen
import 'screens/health_report/health_report.dart'; // Import HealthReport
import 'package:mobile/screens/health_tips/health_tips_screen.dart'; // Import HealthTipsScreen

Future<void> main() async {
  // Make main async
  WidgetsFlutterBinding.ensureInitialized(); // Ensure bindings are initialized
  await dotenv.load(fileName: ".env"); // Load .env file
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
        '/welcome': (context) => const WelcomeScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/pollution-tracker': (context) => const PollutionTrackerScreen(),
        '/forgot-password': (context) =>
            const ForgotPasswordScreen(), // Add route for forgot password
        '/health-report': (context) =>
            const HealthReport(), // Add HealthReport route
        '/health-tips': (context) =>
            const HealthTipsScreen(), // Add HealthTipsScreen route
      },
    );
  }
}

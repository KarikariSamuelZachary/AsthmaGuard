import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/screens/auth/dashboard_screen.dart';
import 'package:mobile/screens/auth/forgotpassword_screen.dart';
import 'package:mobile/screens/auth/login_screen.dart';
import 'package:mobile/screens/auth/otp_verification_screen.dart';
import 'package:mobile/screens/auth/signup_page.dart';
import 'package:mobile/screens/auth/welcome_screen.dart';
import 'package:mobile/screens/health_report/health_report.dart';
import 'package:mobile/screens/health_tips/health_tips_screen.dart';
import 'package:mobile/screens/home/home_screen.dart';
import 'package:mobile/screens/pollution_tracker/pollution_tracker_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
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
      initialRoute: '/login', // Set login as the default screen
      routes: {
        '/signup': (context) => const SignupScreen(),
        '/otp': (context) => const OtpVerificationScreen(),
        '/login': (context) => const LoginScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/home': (context) => const HomeScreen(),
        '/pollution-tracker': (context) => const PollutionTrackerScreen(),
        '/forgot-password': (context) =>
            const ForgotPasswordScreen(), // Add route for forgot password
        '/health-report': (context) =>
            const HealthReportScreen(), // Corrected to HealthReportScreen
        '/health-tips': (context) =>
            const HealthTipsScreen(), // Add HealthTipsScreen route
      },
    );
  }
}

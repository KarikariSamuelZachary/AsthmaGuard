import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve the full name from the route arguments
    final fullName = ModalRoute.of(context)!.settings.arguments as String?;
    final displayName =
        fullName != null && fullName.isNotEmpty ? fullName : 'User';

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF333333);
    final primaryColor = Colors.teal; // Consistent primary color

    // A simple motivational quote
    const motivationalQuote =
        "\"The greatest glory in living lies not in never falling, but in rising every time we fall.\" - Nelson Mandela";

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.celebration_outlined, // A welcoming icon
                  size: 100,
                  color: primaryColor,
                ),
                const SizedBox(height: 30),
                Text(
                  'Hello $displayName!', // Personalized greeting
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32, // Larger font for emphasis
                    fontWeight: FontWeight.bold,
                    color: primaryColor, // Use primary color for greeting
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Welcome to AsthmaGuard!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24, // Slightly smaller than greeting
                    fontWeight: FontWeight.w600, // Semi-bold
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 24),
                // "Something nice" - a motivational quote
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    motivationalQuote,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: isDark ? Colors.white70 : Colors.grey[700],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/dashboard');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 5, // Add some elevation
                  ),
                  child: const Text(
                    'Explore Dashboard', // Changed button text
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

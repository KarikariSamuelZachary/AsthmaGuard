import 'package:flutter/material.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpController = TextEditingController();
  bool _isLoading = false;

  void _verifyOtp() {
    final otp = _otpController.text.trim();
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a 6-digit OTP")),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulate verification delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isLoading = false);

      if (otp == "123456") {
        // Retrieve the full name passed from SignupScreen
        final fullName = ModalRoute.of(context)!.settings.arguments as String?;

        // Navigate to Welcome Screen instead of Dashboard, passing the full name
        Navigator.pushReplacementNamed(
          context,
          '/welcome',
          arguments: fullName, // Pass the full name to WelcomeScreen
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid OTP")),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Colors.teal; // Define primary color

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        title: Text(
          "OTP Verification",
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent, // Flatter look
        elevation: 0, // Remove shadow
        iconTheme: IconThemeData(color: primaryColor), // Back button color
      ),
      body: SingleChildScrollView(
        // Added SingleChildScrollView for smaller screens
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch children
          children: [
            // Icon Placeholder
            Icon(
              Icons.phonelink_lock_outlined, // Example icon for OTP
              size: 80,
              color: primaryColor,
            ),
            const SizedBox(height: 30),
            Text(
              "Enter Verification Code", // Updated title
              style: TextStyle(
                fontSize: 24, // Adjusted font size
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF333333),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              "Enter the 6-digit code sent to your registered email or phone number.", // More descriptive text
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white70 : Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center, // Center the OTP input
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 10), // Make OTP digits more prominent
              decoration: InputDecoration(
                labelText: "OTP Code",
                floatingLabelBehavior: FloatingLabelBehavior
                    .never, // Hide label when text is entered
                counterText: "", // Hide the character counter
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
                prefixIcon: Icon(Icons.password_outlined,
                    color: primaryColor), // Added prefix icon
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isLoading ? null : _verifyOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Verify",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // TODO: Implement resend OTP logic
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Resend OTP tapped (not implemented yet)")),
                );
              },
              child: Text(
                "Resend OTP",
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

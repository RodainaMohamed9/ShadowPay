import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shadow_pay_app/theme/colors.dart';
import 'package:shadow_pay_app/l10n/app_localizations.dart';
import 'package:shadow_pay_app/screens/AuthScreens/ForgetPassword/reset_password_screen.dart';
import 'package:shadow_pay_app/screens/AuthScreens/login/login_screen.dart';
import 'package:shadow_pay_app/services/auth_service.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  final String purpose;

  const OtpScreen({super.key, required this.email, required this.purpose});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> controllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> focusNodes =
      List.generate(6, (index) => FocusNode());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNodes[0]);
    });
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  bool get isOtpComplete {
    for (var controller in controllers) {
      if (controller.text.isEmpty) return false;
    }
    return true;
  }

  void verifyCode() async {
    final loc = AppLocalizations.of(context)!;

    if (!isOtpComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.enterCompleteCode),
          backgroundColor: context.errorColor,
        ),
      );
      return;
    }

    String otp = controllers.map((c) => c.text).join();

    final response = await AuthService.verifyOtp(
      email: widget.email,
      otp: otp,
      purpose: widget.purpose,
    );

    if (response.success) {
      if (widget.purpose == "register") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      } else if (widget.purpose == "forgot") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ResetPasswordScreen(
              email: widget.email,
              otp: otp,
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
          backgroundColor: context.errorColor,
        ),
      );
    }
  }

  void _onChanged(String value, int index) {
    setState(() {});

    if (value.isNotEmpty) {
      if (value.length == 1) {
        if (index < 5) {
          FocusScope.of(context).requestFocus(focusNodes[index + 1]);
        } else {
          FocusScope.of(context).unfocus();
        }
      }
    } else {
      if (index > 0) {
        FocusScope.of(context).requestFocus(focusNodes[index - 1]);
      }
    }
  }

  Widget otpBox(int index, bool isDarkMode) {
    return SizedBox(
      width: 45,
      height: 55,
      child: TextField(
        controller: controllers[index],
        focusNode: focusNodes[index],
        textAlign: TextAlign.center,
        maxLength: 1,
        keyboardType: TextInputType.number,
        style: TextStyle(
          color: context.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: context.progressBgColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: context.primaryColor,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDarkMode ? Colors.white24 : Colors.grey.shade400,
              width: 1,
            ),
          ),
        ),
        onChanged: (value) => _onChanged(value, index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDarkMode = context.isDarkMode;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [Color(0xff0a1628), Color(0xff0f1f3a), Color(0xff0a1628)]
                : [Color(0xfff5f7fa), Color(0xffe8ecf1), Color(0xfff5f7fa)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: context.primaryColor.withOpacity(0.3),
                        blurRadius: 25,
                        spreadRadius: 2,
                        offset: const Offset(0, 10),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 15,
                        spreadRadius: 1,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: OtpLogoWidget(isDarkMode: isDarkMode),
                ),
                const SizedBox(height: 25),

                Text(
                  loc.verifyCode,
                  style: TextStyle(
                    color: context.textPrimary,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                Text(
                  loc.enter6DigitCode,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: context.textSecondary,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 30),

                GlassCardOTP(
                  isDarkMode: isDarkMode,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:
                            List.generate(6, (index) => otpBox(index, isDarkMode)),
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: verifyCode,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                          ),
                          child: Text(
                            loc.verify,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: Text(
                          loc.backToLogin,
                          style: TextStyle(
                            color: context.textSecondary,
                            fontSize: 15,
                          ),
                        ),
                      )
                    ],
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

// OTP Logo Widget
class OtpLogoWidget extends StatelessWidget {
  final bool isDarkMode;
  const OtpLogoWidget({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDarkMode ? Colors.white10 : Colors.grey.shade200,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          'assets/icon/icon.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: isDarkMode ? Colors.white10 : Colors.grey.shade200,
              child: Icon(
                Icons.verified_user,
                color: context.textSecondary,
                size: 40,
              ),
            );
          },
        ),
      ),
    );
  }
}

// GlassCard Widget for OTP
class GlassCardOTP extends StatelessWidget {
  final Widget child;
  final bool isDarkMode;
  const GlassCardOTP({super.key, required this.child, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDarkMode
                ? Colors.white.withOpacity(0.05)
                : Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.white.withOpacity(0.5),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadow_pay_app/theme/colors.dart';
import 'package:shadow_pay_app/screens/AuthScreens/ForgetPassword/otp_screen.dart';
import 'package:shadow_pay_app/l10n/app_localizations.dart';
import 'package:shadow_pay_app/services/auth_service.dart';
import 'package:shadow_pay_app/screens/AuthScreens/login/login_screen.dart';
import 'package:shadow_pay_app/providers/theme_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  bool isLoading = false;

  String? validateEmail(String? value) {
    final loc = AppLocalizations.of(context)!;
    
    if (value == null || value.isEmpty) {
      return loc.emailRequired;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return loc.emailInvalid;
    }
    return null;
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> sendCode() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final result = await AuthService.sendOtp(
        email: emailController.text.trim(),
        purpose: "forgot",
      );

      if (!mounted) return;

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? "OTP sent to your email"),
            backgroundColor: context.primaryColor, // ✅改用 extension
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpScreen(
              email: emailController.text.trim(),
              purpose: "forgot",
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? "Email not found"),
            backgroundColor: context.errorColor, // ✅改用 extension
          ),
        );
      }
    } catch (e) {
      print("Send OTP error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Network error: $e"),
          backgroundColor: context.errorColor, // ✅改用 extension
        ),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';
    
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = context.isDarkMode; // ✅改用 extension

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
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: context.primaryColor.withOpacity(0.3), // ✅改用 extension
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
                  child: LogoWidget(isDarkMode: isDarkMode),
                ),
                const SizedBox(height: 30),

                Text(
                  loc.forgotPassword,
                  style: TextStyle(
                    color: context.textPrimary, // ✅改用 extension
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                Text(
                  loc.enterEmailResetCode,
                  style: TextStyle(
                    color: context.textSecondary, // ✅改用 extension
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                GlassCard(
                  isDarkMode: isDarkMode,
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        _buildField(
                          controller: emailController,
                          hint: loc.emailHint,
                          icon: Icons.email,
                          validator: validateEmail,
                          keyboardType: TextInputType.emailAddress,
                          isDarkMode: isDarkMode,
                        ),
                        const SizedBox(height: 25),

                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : sendCode,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.primaryColor, // ✅改用 extension
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 5,
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    loc.sendCode,
                                    style: const TextStyle(fontSize: 18),
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
                              color: context.textSecondary, // ✅改用 extension
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    required bool isDarkMode,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      style: TextStyle(
        color: context.textPrimary, // ✅改用 extension
        fontSize: 16,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: context.hintColor, // ✅改用 extension
        ),
        prefixIcon: Icon(
          icon,
          color: context.textSecondary, // ✅改用 extension
        ),
        filled: true,
        fillColor: context.progressBgColor, // ✅改用 extension
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.transparent : Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: context.primaryColor, // ✅改用 extension
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
}

// Logo Widget (keep as is, but can also use extension if needed)
class LogoWidget extends StatelessWidget {
  final bool isDarkMode;
  const LogoWidget({super.key, required this.isDarkMode});

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
                Icons.lock_reset,
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

// GlassCard Widget (keep as is)
class GlassCard extends StatelessWidget {
  final Widget child;
  final bool isDarkMode;
  const GlassCard({super.key, required this.child, required this.isDarkMode});

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
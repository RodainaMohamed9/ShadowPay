import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadow_pay_app/screens/home/home_screen.dart';
import 'package:shadow_pay_app/theme/colors.dart';
import 'package:shadow_pay_app/l10n/app_localizations.dart';
import 'package:shadow_pay_app/screens/AuthScreens/login/login_screen.dart';
import 'package:shadow_pay_app/services/shared_pref_service.dart';
import 'package:shadow_pay_app/services/auth_service.dart';
import 'package:shadow_pay_app/providers/theme_provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String? otp;

  const ResetPasswordScreen({super.key, required this.email, this.otp});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  bool showPassword = false;
  bool showConfirm = false;
  bool isLoading = false;

  Future<void> resetPassword() async {
    final loc = AppLocalizations.of(context)!;

    if (passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.passwordRequired)),
      );
      return;
    }

    if (passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.passwordTooShort)),
      );
      return;
    }

    if (passwordController.text != confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.passwordMismatch)),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final result = await ApiService.resetPassword(
        email: widget.email,
        otp: widget.otp ?? '',
        newPassword: passwordController.text,
        confirmPassword: confirmController.text,
      );

      if (!mounted) return;

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? loc.passwordResetSuccess),
            backgroundColor: context.primaryColor,
          ),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Failed to reset password'),
            backgroundColor: context.errorColor,
          ),
        );
      }
    } catch (e) {
      print("Reset password error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An unexpected error occurred: $e"),
          backgroundColor: context.errorColor,
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
                  child: ResetLogoWidget(isDarkMode: isDarkMode),
                ),
                const SizedBox(height: 25),

                Text(
                  loc.resetPassword,
                  style: TextStyle(
                    color: context.textPrimary,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),

                GlassCardReset(
                  isDarkMode: isDarkMode,
                  child: Column(
                    children: [
                      _buildField(
                        controller: passwordController,
                        hint: loc.newPassword,
                        icon: Icons.lock,
                        obscure: !showPassword,
                        isDarkMode: isDarkMode,
                        suffix: IconButton(
                          icon: Icon(
                            showPassword ? Icons.visibility_off : Icons.visibility,
                            color: context.textSecondary,
                          ),
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 15),

                      _buildField(
                        controller: confirmController,
                        hint: loc.confirmPassword,
                        icon: Icons.lock,
                        obscure: !showConfirm,
                        isDarkMode: isDarkMode,
                        suffix: IconButton(
                          icon: Icon(
                            showConfirm ? Icons.visibility_off : Icons.visibility,
                            color: context.textSecondary,
                          ),
                          onPressed: () {
                            setState(() {
                              showConfirm = !showConfirm;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 25),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : resetPassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.primaryColor,
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
                                  loc.resetPasswordButton,
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
                            color: context.textSecondary,
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

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
    required bool isDarkMode,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: TextStyle(
        color: context.textPrimary,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: context.hintColor,
        ),
        prefixIcon: Icon(
          icon,
          color: context.textSecondary,
        ),
        suffixIcon: suffix,
        filled: true,
        fillColor: context.progressBgColor,
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
            color: context.primaryColor,
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
}

// Reset Logo Widget
class ResetLogoWidget extends StatelessWidget {
  final bool isDarkMode;
  const ResetLogoWidget({super.key, required this.isDarkMode});

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

// GlassCard Widget for Reset Password
class GlassCardReset extends StatelessWidget {
  final Widget child;
  final bool isDarkMode;
  const GlassCardReset({super.key, required this.child, required this.isDarkMode});

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
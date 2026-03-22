import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shadow_pay_app/screens/home/home_screen.dart';
import 'package:shadow_pay_app/constants/colors.dart';
import 'package:shadow_pay_app/l10n/app_localizations.dart';
import 'package:shadow_pay_app/screens/login/login_Screen.dart';
import 'package:shadow_pay_app/services/shared_pref_service.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  bool showPassword = false;
  bool showConfirm = false;

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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(loc.passwordResetSuccess),
        backgroundColor: Colors.teal,
      ),
    );

    await SharedPrefService.setLoggedIn(true);

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff0a1628),
              Color(0xff0f1f3a),
              Color(0xff0a1628)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white10,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.lock_reset,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 25),

                Text(
                  loc.resetPassword,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),

                GlassCard(
                  child: Column(
                    children: [
                      buildField(
                        controller: passwordController,
                        hint: loc.newPassword,
                        icon: Icons.lock,
                        obscure: !showPassword,
                        suffix: IconButton(
                          icon: Icon(
                            showPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white70,
                          ),
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 15),

                      buildField(
                        controller: confirmController,
                        hint: loc.confirmPassword,
                        icon: Icons.lock,
                        obscure: !showConfirm,
                        suffix: IconButton(
                          icon: Icon(
                            showConfirm
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white70,
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
                          onPressed: resetPassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryTeal,
                            foregroundColor: Colors.white, 
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
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
                            )
                          );
                        },
                        child: Text(
                          loc.backToLogin,
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Colors.white54,
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.white70,
        ),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.black26,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;

  const GlassCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.05),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white10),
          ),
          child: child,
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:shadow_pay_app/constants/colors.dart';
import 'package:shadow_pay_app/l10n/app_localizations.dart';
import 'package:shadow_pay_app/screens/ForgetPassword/reset_password_screen.dart';
import 'package:shadow_pay_app/screens/login/login_Screen.dart';
import 'package:shadow_pay_app/services/auth_service.dart';
import 'dart:ui';

class OtpScreen extends StatefulWidget {
  final String email;
  final String purpose; // "register" or "forgot"

  OtpScreen({super.key, required this.email, required this.purpose});

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
    // أول خانة تاخد focus تلقائي لما الصفحة تفتح
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

  //======= API =======
  void verifyCode() async {
    final loc = AppLocalizations.of(context)!;

    if (!isOtpComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.enterCompleteCode),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    String otp = controllers.map((c) => c.text).join();

    final response = await ApiService.verifyOtp(
      email: widget.email, 
      otp: otp, 
      purpose: widget.purpose
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
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onChanged(String value, int index) {
    setState(() {});
    
    if (value.isNotEmpty) {
      // لو دخلت رقم
      if (value.length == 1) {
        // روح للخانة اللي بعدها
        if (index < 5) {
          FocusScope.of(context).requestFocus(focusNodes[index + 1]);
        } else {
          // لو آخر خانة، أخفي الكيبورد
          FocusScope.of(context).unfocus();
        }
      }
    } else {
      // لو الخانة فاضية (مسحت الرقم)
      if (index > 0) {
        // امسح الخانة اللي قبلها كمان (اختياري)
        // controllers[index - 1].clear();
        FocusScope.of(context).requestFocus(focusNodes[index - 1]);
      }
    }
  }

  Widget otpBox(int index) {
    return SizedBox(
      width: 45,
      height: 55,
      child: TextField(
        controller: controllers[index],
        focusNode: focusNodes[index],
        textAlign: TextAlign.center,
        maxLength: 1,
        keyboardType: TextInputType.number,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: Colors.black26,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors.primaryTeal,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.white24,
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
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
                    Icons.verified_user,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 25),

                Text(
                  loc.verifyCode,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                Text(
                  loc.enter6DigitCode,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 30),

                GlassCard(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(6, (index) => otpBox(index)),
                      ),
                      
                      const SizedBox(height: 25),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: verifyCode,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryTeal,
                            foregroundColor: Colors.white, // 👈 النص أبيض
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
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
                      
                      // Back to Login button
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
import 'package:flutter/material.dart';
import '../../services/shared_pref_service.dart';
import '../login/login_Screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // دالة تسجيل الخروج
  Future<void> _logout(BuildContext context) async {
    // حذف حالة تسجيل الدخول
    await SharedPrefService.logout();
    
    if (context.mounted) {
      // الرجوع لصفحة Login ومسح كل الشاشات السابقة
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false, // يمسح كل الشاشات عشان ميرجعش للخلف تاني
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.teal,
        // إضافة زر Logout في الـ AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => _logout(context),
            tooltip: 'تسجيل الخروج',
          ),
        ],
      ),
      body: const Center(
        child: Text(
          "Welcome to ShadowPay 🚀",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
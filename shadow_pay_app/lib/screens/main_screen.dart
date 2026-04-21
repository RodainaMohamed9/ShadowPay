// lib/screens/main_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadow_pay_app/providers/theme_provider.dart';
import 'package:shadow_pay_app/screens/home/home_screen.dart';
import 'package:shadow_pay_app/screens/CardManagement/CardManagementScreen.dart';
import 'package:shadow_pay_app/screens/report/report_screen.dart';
import 'package:shadow_pay_app/screens/profile/profile_screen.dart';
import 'package:shadow_pay_app/screens/TransactionScreens/add_transaction_screen.dart';
import 'package:shadow_pay_app/screens/home/home_widgets/bottom_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(onNavigate: _changeTab),           // index 0
      const CardManagementScreen(),                  // index 1 (Freeze)
      const ReportScreen(),                          // index 2 (Report)
      const ProfileScreen(),                         // index 3 (Profile)
      AddTransactionScreen(onBack: _goBackHome),    // index 4 (Add)
      // const CardDetailsScreen(),                  // index 5 (Details) لما تعملها
    ];
  }

  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _goBackHome() {
    setState(() {
      _currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex >= 0 && _currentIndex <= 3 ? _currentIndex : 0,
        isDarkMode: isDarkMode,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
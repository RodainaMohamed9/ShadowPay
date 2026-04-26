// lib/screens/main_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadow_pay_app/providers/theme_provider.dart';
import 'package:shadow_pay_app/screens/home/home_screen.dart';
import 'package:shadow_pay_app/screens/CardManagement/CardManagementScreen.dart';
import 'package:shadow_pay_app/screens/report/report_screen.dart';
import 'package:shadow_pay_app/screens/profile/profile_screen.dart';
import 'package:shadow_pay_app/screens/TransactionScreens/add_transaction_screen.dart';
import 'package:shadow_pay_app/screens/Analysis/risk_analysis_screen.dart';
import 'package:shadow_pay_app/screens/home/home_widgets/bottom_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  bool _showRiskScreen = false;

  // بيانات التحليل
  Map<String, dynamic> _riskData = {
    'amount': 0.0,
    'hour': 0,
    'category': 'grocery_pos',
    'zipCode': 0,
    'riskScore': 0.0,
    'riskLevel': 'Low Risk',
    'isFraud': false,
    'detectionMode': 'General',
  };

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(onNavigate: _changeTab), // index 0
      const CardManagementScreen(), // index 1
      const ReportScreen(), // index 2
      const ProfileScreen(), // index 3
      AddTransactionScreen(
        onBack: _goBackHome,
        onAnalyze: _showRiskAnalysis,
      ), // index 4
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

  void _showRiskAnalysis(Map<String, dynamic> riskData) {
    setState(() {
      _riskData = riskData;
      _showRiskScreen = true;
    });
  }

  void _closeRiskScreen() {
    setState(() {
      _showRiskScreen = false;
      _currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    final showBottomNav =
        _currentIndex >= 0 && _currentIndex <= 4 && !_showRiskScreen;

    return Scaffold(
      body: _showRiskScreen
          ? RiskAnalysisScreen(
              onBack: _closeRiskScreen,
              amount: _riskData['amount'] as double,
              hour: _riskData['hour'] as int,
              category: _riskData['category'] as String,
              zipCode: _riskData['zipCode'] as int,
              riskScore: _riskData['riskScore'] as double,
              riskLevel: _riskData['riskLevel'] as String,
              isFraud: _riskData['isFraud'] as bool,
              detectionMode: _riskData['detectionMode'] as String,
            )
          : _screens[_currentIndex],
      bottomNavigationBar: showBottomNav
          ? BottomNavBar(
              currentIndex: _currentIndex,
              isDarkMode: isDarkMode,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            )
          : null,
    );
  }
}

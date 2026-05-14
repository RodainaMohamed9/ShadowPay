import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shadow_pay_app/core/enums/category.dart';
import 'package:shadow_pay_app/database/models/transaction_model.dart';
import 'package:shadow_pay_app/logic/transaction/cubit/transaction_cubit.dart';
import 'package:shadow_pay_app/logic/transaction/cubit/transaction_state.dart';
import 'package:shadow_pay_app/providers/theme_provider.dart';
import 'package:shadow_pay_app/screens/home/home_screen.dart';
import 'package:shadow_pay_app/screens/CardManagement/CardManagementScreen.dart';
import 'package:shadow_pay_app/screens/report/report_screen.dart';
import 'package:shadow_pay_app/screens/profile/profile_screen.dart';
import 'package:shadow_pay_app/screens/TransactionScreens/add_transaction_screen.dart';
import 'package:shadow_pay_app/screens/Analysis/risk_analysis_screen.dart';
import 'package:shadow_pay_app/screens/home/home_widgets/bottom_nav_bar.dart';
import 'package:shadow_pay_app/screens/Analysis/analytics_screen.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  bool _showRiskScreen = false;

  TransactionModel? _analyzedTransaction;
  void _showRiskAnalysis(Map<String, dynamic> data) {
  context.read<TransactionCubit>().addTransaction(
    amount: data['amount'] as double,
    transactionHour: data['hour'] as int,
    category: idToCategory(data['category'] as int),
    zipCode: data['zipCode'] as int,
  );
}

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(onNavigate: _changeTab), // index 0
      CardManagementScreen(onBack: _goBackHome), // index 1
      ReportScreen(onBack: _goBackHome), // index 2
      const ProfileScreen(), // index 3
      AddTransactionScreen(
        onBack: _goBackHome,
        onAnalyze: _showRiskAnalysis,
      ), // index 4
      AnalyticsScreen(onBack: _goBackHome),
      
    ];
  }

 Future<void> _changeTab(int index) async {
  setState(() {
    _currentIndex = index;
  });
}

  void _goBackHome() {
    setState(() {
      _currentIndex = 0;
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
  final showBottomNav = _currentIndex >= 0 && _currentIndex <= 5 && !_showRiskScreen;

  return BlocConsumer<TransactionCubit, TransactionState>(
    listener: (context, state) {
      if (state is TransactionFailureState) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.errorMessage), backgroundColor: Colors.red),
        );
      } else if (state is TransactionAddedSuccessState) {
        setState(() {
          _analyzedTransaction = state.transaction;
          _showRiskScreen = true; 
        });
      }
    },
    builder: (context, state) {
      return Scaffold(
        body: Stack(
          children: [
            _showRiskScreen && _analyzedTransaction != null
                ? RiskAnalysisScreen(
                    onBack: _closeRiskScreen,
                    amount: _analyzedTransaction!.amount,
                    hour: _analyzedTransaction!.transactionHour,
                    category: categoryToId(_analyzedTransaction!.merchantCategory),
                    zipCode: _analyzedTransaction!.zipCode,
                    riskScore: _analyzedTransaction!.riskScore,
                    riskLevel: _analyzedTransaction!.riskLevel,
                    isFraud: _analyzedTransaction!.isFraud,
                    detectionMode: 'AI Microservice', 
                  )
                : IndexedStack(
    index: _currentIndex,
    children: _screens,
  ),

            if (state is TransactionLoadingState)
              Container(
                color: Colors.black.withOpacity(0.4),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
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
    },
  );
}
}

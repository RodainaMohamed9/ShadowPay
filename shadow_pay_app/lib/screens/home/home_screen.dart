import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadow_pay_app/l10n/app_localizations.dart';
import 'package:shadow_pay_app/theme/colors.dart';
import 'package:shadow_pay_app/providers/theme_provider.dart';
import 'package:shadow_pay_app/screens/CardManagement/CardManagementScreen.dart';
import 'package:shadow_pay_app/services/shared_pref_service.dart';
import 'package:shadow_pay_app/screens/home/home_widgets/bottom_nav_bar.dart';
import 'package:shadow_pay_app/screens/home/home_widgets/quick_actions.dart';
import 'package:shadow_pay_app/screens/home/home_widgets/recent_activity.dart';
import 'package:shadow_pay_app/screens/home/home_widgets/shield_status.dart';
import 'package:shadow_pay_app/screens/home/home_widgets/virtual_card.dart';
import 'package:shadow_pay_app/screens/home/home_widgets/welcome_header.dart';
import 'package:shadow_pay_app/screens/TransactionScreens/add_transaction_screen.dart';
import 'package:shadow_pay_app/screens/report/report_screen.dart';
import 'package:shadow_pay_app/screens/profile/profile_screen.dart';
import 'package:shadow_pay_app/screens/TransactionScreens/transaction_list.dart';
import '../AuthScreens/login/login_Screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const HomeContent(),
    const CardManagementScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        isDarkMode: isDarkMode,
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String userName = '';
  String cardNumber = '';
  String cardHolder = '';
  String cardExpiry = '';
  double cardBalance = 12480.90;
  bool isCardFrozen = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadCardStatus();
  }

  Future<void> _loadUserData() async {
    final fullName = await SharedPrefService.getUserFullNameAsync();
    final cardNum = await SharedPrefService.getUserCardNumber();
    final cardName = await SharedPrefService.getUserCardName();
    final expiry = await SharedPrefService.getUserCardExpiry();
    setState(() {
      userName = fullName ?? 'User';
      cardNumber = cardNum ?? '4829';
      cardHolder = cardName ?? 'Card Holder';
      cardExpiry = expiry ?? '09/29';
    });
  }

  Future<void> _loadCardStatus() async {
    final frozen = await SharedPrefService.getCardFrozenStatus();
    setState(() {
      isCardFrozen = frozen;
      isLoading = false;
    });
  }

  Future<void> _goToCardManagement() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CardManagementScreen(),
      ),
    );
    
    final newStatus = await SharedPrefService.getCardFrozenStatus();
    setState(() {
      isCardFrozen = newStatus;
    });
    
    if (mounted) {
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isCardFrozen 
                ? 'Card frozen successfully' 
                : 'Card unfrozen successfully',
          ),
          backgroundColor: isCardFrozen ? Colors.red : (isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary),
        ),
      );
    }
  }

  void _freezeCard() {
    _goToCardManagement();
  }

  void _manageCard() {
    _goToCardManagement();
  }

  void _goToReport() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ReportScreen()),
    );
  }

  void _goToAddTransaction() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTransactionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary,
                ),
              )
            : Column(
                children: [
                  WelcomeHeader(
                    userName: userName,
                    isFrozen: isCardFrozen,
                    onManageTap: isCardFrozen ? _manageCard : null,
                    isDarkMode: isDarkMode,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          ShieldStatus(isDarkMode: isDarkMode),
                          const SizedBox(height: 20),
                          VirtualCard(
                            cardNumber: cardNumber,
                            cardHolder: cardHolder,
                            expiry: cardExpiry,
                            balance: cardBalance,
                            isFrozen: isCardFrozen,
                            isDarkMode: isDarkMode,
                          ),
                          const SizedBox(height: 24),
                          QuickActions(
                            onAddTap: _goToAddTransaction,
                            onReportTap: _goToReport,
                            onDetailsTap: () {},
                            onFreezeTap: _freezeCard,
                            onManageTap: _manageCard,
                            isCardFrozen: isCardFrozen,
                            isDarkMode: isDarkMode,
                          ),
                          const SizedBox(height: 24),
                          RecentActivity(isDarkMode: isDarkMode),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
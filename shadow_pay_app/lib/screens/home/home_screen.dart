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
import '../AuthScreens/login/login_Screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _goToAddTransaction() {
    setState(() => _currentIndex = 4);
  }

  void _goToReport() {
    setState(() => _currentIndex = 2);
  }

  void _goToCards() {
    setState(() => _currentIndex = 1);
  }

  void _goBackHome() {
    setState(() => _currentIndex = 0);
  }

  Future<void> _goToCardManagement() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CardManagementScreen()),
    );
  }

  List<Widget> get _pages => [
    HomeContent(
      onAddTap: _goToAddTransaction,
      onReportTap: _goToReport,
      onCardsTap: _goToCards,
      onCardManagementTap: _goToCardManagement,
    ),
    const CardManagementScreen(), // ✅ index 1 → Cards
    const ReportScreen(),         // index 2 → Report
    const ProfileScreen(),        // index 3 → Profile
    AddTransactionScreen(         // index 4 → hidden
      onBack: _goBackHome,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      body: _pages[_currentIndex],
bottomNavigationBar: BottomNavBar(
  currentIndex: _currentIndex <= 3 ? _currentIndex : -1,
  onTap: (index) => setState(() => _currentIndex = index),
  isDarkMode: isDarkMode,
),
    );
  }
}

class HomeContent extends StatefulWidget {
  final VoidCallback onAddTap;
  final VoidCallback onReportTap;
  final VoidCallback onCardsTap;
  final Future<void> Function() onCardManagementTap;

  const HomeContent({
    super.key,
    required this.onAddTap,
    required this.onReportTap,
    required this.onCardsTap,
    required this.onCardManagementTap,
  });

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

  Future<void> _handleCardManagement() async {
    await widget.onCardManagementTap();
    final newStatus = await SharedPrefService.getCardFrozenStatus();
    if (!mounted) return;
    setState(() => isCardFrozen = newStatus);

    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isCardFrozen ? 'Card frozen successfully' : 'Card unfrozen successfully',
        ),
        backgroundColor: isCardFrozen
            ? Colors.red
            : (isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary),
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
                    onManageTap: isCardFrozen ? _handleCardManagement : null,
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
                            onAddTap: widget.onAddTap,
                            onReportTap: widget.onReportTap,
                            onDetailsTap: () {},
                            onFreezeTap: _handleCardManagement,
                            onManageTap: _handleCardManagement,
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
// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadow_pay_app/l10n/app_localizations.dart';
import 'package:shadow_pay_app/theme/colors.dart';
import 'package:shadow_pay_app/providers/theme_provider.dart';
import 'package:shadow_pay_app/screens/CardManagement/CardManagementScreen.dart';
import 'package:shadow_pay_app/services/shared_pref_service.dart';
import 'package:shadow_pay_app/screens/home/home_widgets/welcome_header.dart';
import 'package:shadow_pay_app/screens/home/home_widgets/shield_status.dart';
import 'package:shadow_pay_app/screens/home/home_widgets/virtual_card.dart';
import 'package:shadow_pay_app/screens/home/home_widgets/quick_actions.dart';
import 'package:shadow_pay_app/screens/home/home_widgets/recent_activity.dart';

class HomeScreen extends StatelessWidget {
  final Function(int) onNavigate;

  const HomeScreen({
    super.key,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: HomeContent(
          onNavigate: onNavigate,
          isDarkMode: isDarkMode,
        ),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  final Function(int) onNavigate;
  final bool isDarkMode;

  const HomeContent({
    super.key,
    required this.onNavigate,
    required this.isDarkMode,
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

  void _handleFreeze() {
    // ⭐ تروح لـ CardManagementScreen (index 1)
    widget.onNavigate(1);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = widget.isDarkMode;

    return isLoading
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
                onManageTap: isCardFrozen ? _handleFreeze : null,
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
                        onAddTap: () => widget.onNavigate(4),     // AddTransactionScreen
                        onReportTap: () => widget.onNavigate(2),  // ReportScreen
                        onDetailsTap: () => widget.onNavigate(5), // CardDetailsScreen
                        onFreezeTap: _handleFreeze,               // CardManagementScreen
                        onManageTap: _handleFreeze,
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
          );
  }
}
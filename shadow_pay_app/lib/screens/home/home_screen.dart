import 'package:flutter/material.dart';
import 'package:shadow_pay_app/l10n/app_localizations.dart';
import 'package:shadow_pay_app/services/shared_pref_service.dart';
import 'widgets/welcome_header.dart';
import 'widgets/shield_status.dart';
import 'widgets/virtual_card.dart';
import 'widgets/quick_actions.dart';
import 'widgets/recent_activity.dart';
import 'widgets/bottom_nav_bar.dart';
import 'Screens/report_screen.dart';

// import 'screens/analytics_screen.dart';
// import 'screens/cards_screen.dart';
// import 'screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const HomeContent(), // Analytics placeholder
    const HomeContent(), // Cards placeholder
    const HomeContent(), // Profile placeholder
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
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
    final frozen = await SharedPrefService.isCardFrozen();
    setState(() {
      isCardFrozen = frozen;
      isLoading = false;
    });
  }

  Future<void> _freezeCard() async {
    await SharedPrefService.freezeCard();
    setState(() => isCardFrozen = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Card frozen successfully'), backgroundColor: Color(0xFFF44336)),
    );
  }

  void _goToCards() {
    // هنا لما يخلصوا صفحة Cards يغيروا الكود
    // Navigator.push(context, MaterialPageRoute(builder: (_) => const CardsScreen()));
  }

  void _goToReport() {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const ReportScreen()),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1F),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF00D8A2)))
            : Column(
                children: [
                  WelcomeHeader(
                    userName: userName,
                    isFrozen: isCardFrozen,
                    onManageTap: isCardFrozen ? _goToCards : null,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          const ShieldStatus(),
                          const SizedBox(height: 20),
                          VirtualCard(
                            cardNumber: cardNumber,
                            cardHolder: cardHolder,
                            expiry: cardExpiry,
                            balance: cardBalance,
                            isFrozen: isCardFrozen,
                          ),
                          const SizedBox(height: 24),
                          QuickActions(
                            onAddTap: () {}, // هيتعدل بعدين
                            onReportTap: _goToReport ,
                            onDetailsTap: () {},
                            onFreezeTap: _freezeCard,
                            onManageTap: _goToCards,
                            isCardFrozen: isCardFrozen,
                          ),
                          const SizedBox(height: 24),
                          const RecentActivity(),
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
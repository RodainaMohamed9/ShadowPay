import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shadow_pay_app/l10n/app_localizations.dart';
import 'package:shadow_pay_app/screens/Settings/Settings.dart';
import 'package:shadow_pay_app/theme/colors.dart';
import 'package:shadow_pay_app/providers/theme_provider.dart';
import 'package:shadow_pay_app/screens/AuthScreens/login/login_Screen.dart';
import 'package:shadow_pay_app/screens/home/home_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
  bool showLogoutDialog = false;
  late AnimationController _dialogController;

  @override
  void initState() {
    super.initState();
    _dialogController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _dialogController.dispose();
    super.dispose();
  }

  void _showLogoutDialog() {
    _dialogController.forward(from: 0.0);
    setState(() {
      showLogoutDialog = true;
    });
  }

  void _hideLogoutDialog() {
    _dialogController.reverse().then((_) {
      setState(() {
        showLogoutDialog = false;
      });
    });
  }

  void _copy(BuildContext context, String text, AppLocalizations loc) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(loc.copied_to_clipboard),
        backgroundColor: context.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDarkMode = context.isDarkMode;
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';
    final primaryColor = context.primaryColor;

    const String userName = "Ahmed Al-Sayed";
    const String userEmail = "ahmed@example.com";
    const String userPhone = "+966 50 123 4567";
    final String firstLetter = userName[0].toUpperCase();

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              (isDarkMode ? const Color(0xff1D293D) : Colors.grey.shade200).withOpacity(0.4),
            ),
            side: MaterialStateProperty.all(
              BorderSide(
                color: context.textSecondary.withOpacity(0.4),
                width: 1,
              ),
            ),
          ),
          iconSize: 25,
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
          },
          icon: Transform.scale(
            scaleX: isRTL ? -1 : 1,
            child: Icon(Icons.arrow_back, color: context.textSecondary),
          ),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        // ── Header Section ──────────────────────────────
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(24, 32, 24, 36),
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? const Color(0xFF0D1B2A)
                                : const Color(0xFFF0F4F8),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(36),
                              bottomRight: Radius.circular(36),
                            ),
                          ),
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  Container(
                                    width: 96,
                                    height: 96,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          primaryColor,
                                          primaryColor.withOpacity(0.6),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: primaryColor.withOpacity(0.35),
                                          blurRadius: 20,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        firstLetter,
                                        style: const TextStyle(
                                          fontSize: 42,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 26,
                                    height: 26,
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: context.backgroundColor,
                                        width: 2.5,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 13,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                userName,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: context.textPrimary,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 5),
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: primaryColor.withOpacity(0.25),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.workspace_premium_rounded,
                                        color: primaryColor, size: 14),
                                    const SizedBox(width: 5),
                                    Text(
                                      localizations.premium_member,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: primaryColor,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        // ── Stats Row ────────────────────────────────────
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            children: [
                              _StatCard(
                                label: "Transactions",
                                value: "128",
                                icon: Icons.receipt_long_outlined,
                                isDarkMode: isDarkMode,
                                primaryColor: primaryColor,
                              ),
                              const SizedBox(width: 12),
                              _StatCard(
                                label: "This Month",
                                value: "\$3.2k",
                                icon: Icons.trending_up_rounded,
                                isDarkMode: isDarkMode,
                                primaryColor: primaryColor,
                              ),
                              const SizedBox(width: 12),
                              _StatCard(
                                label: "Saved",
                                value: "\$840",
                                icon: Icons.savings_outlined,
                                isDarkMode: isDarkMode,
                                primaryColor: primaryColor,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        // ── Personal Info ────────────────────────────────
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                localizations.personal_info,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: context.textSecondary,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _InfoCard(
                                isDarkMode: isDarkMode,
                                children: [
                                  _InfoRow(
                                    icon: Icons.email_outlined,
                                    label: localizations.email,
                                    value: userEmail,
                                    primaryColor: primaryColor,
                                    isDarkMode: isDarkMode,
                                    onCopy: () => _copy(context, userEmail, localizations),
                                  ),
                                  _Divider(isDarkMode: isDarkMode),
                                  _InfoRow(
                                    icon: Icons.phone_outlined,
                                    label: localizations.phone,
                                    value: userPhone,
                                    primaryColor: primaryColor,
                                    isDarkMode: isDarkMode,
                                    onCopy: () => _copy(context, userPhone, localizations),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        // ── Actions ──────────────────────────────────────
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Settings & Privacy",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: context.textSecondary,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _InfoCard(
                                isDarkMode: isDarkMode,
                                children: [
                                  _ActionRow(
                                    icon: Icons.settings_outlined,
                                    label: localizations.settings,
                                    primaryColor: primaryColor,
                                    isDarkMode: isDarkMode,
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const SettingsPage(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        // ── Logout ───────────────────────────────────────
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: GestureDetector(
                            onTap: _showLogoutDialog,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.red.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.logout_rounded, color: Colors.red, size: 20),
                                  const SizedBox(width: 10),
                                  Text(
                                    localizations.logout,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Logout Dialog
          if (showLogoutDialog) _animatedLogoutDialog(localizations),
        ],
      ),
    );
  }

  Widget _animatedLogoutDialog(AppLocalizations loc) {
    return AnimatedBuilder(
      animation: _dialogController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _dialogController,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.7, end: 1.0).animate(
              CurvedAnimation(
                parent: _dialogController,
                curve: Curves.easeOutBack,
              ),
            ),
            child: _logoutDialog(loc),
          ),
        );
      },
    );
  }

  Widget _logoutDialog(AppLocalizations loc) {
    final isDarkMode = context.isDarkMode;
    
    return GestureDetector(
      onTap: _hideLogoutDialog,
      child: Container(
        color: Colors.black.withOpacity(0.7),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF0F1C2E) : Colors.white,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: context.primaryColor.withOpacity(0.25),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 25,
                  offset: const Offset(0, 15),
                ),
                BoxShadow(
                  color: context.primaryColor.withOpacity(0.05),
                  blurRadius: 20,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 500),
                  tween: Tween<double>(begin: 0.5, end: 1.0),
                  curve: Curves.easeOutBack,
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: context.primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.logout,
                          size: 44,
                          color: context.primaryColor.withOpacity(0.8),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  loc.logoutDialogTitle,
                  style: TextStyle(
                    color: context.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  loc.logout_confirmation,
                  style: TextStyle(color: context.textSecondary, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _hideLogoutDialog,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: (isDarkMode ? const Color(0xFF1E2A3D) : Colors.grey.shade200).withOpacity(0.25),
                              width: 0.5,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              loc.cancel,
                              style: TextStyle(color: context.textPrimary, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _hideLogoutDialog();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                            (route) => false,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [context.primaryColor, context.primaryColor.withOpacity(0.6)],
                            ),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: context.primaryColor.withOpacity(0.25),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              loc.confirm,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Stat Card ────────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isDarkMode;
  final Color primaryColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.isDarkMode,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF0D1B2A) : const Color(0xFFF0F4F8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: primaryColor, size: 18),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: context.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Info Card Container ───────────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  final bool isDarkMode;

  const _InfoCard({required this.children, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF0D1B2A) : const Color(0xFFF0F4F8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(children: children),
    );
  }
}

// ── Info Row ─────────────────────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color primaryColor;
  final bool isDarkMode;
  final VoidCallback onCopy;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.primaryColor,
    required this.isDarkMode,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: primaryColor, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: context.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: context.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onCopy,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.06)
                    : Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.copy_rounded, color: primaryColor, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Action Row ───────────────────────────────────────────────────────────────
class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color primaryColor;
  final bool isDarkMode;
  final VoidCallback onTap;

  const _ActionRow({
    required this.icon,
    required this.label,
    required this.primaryColor,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: primaryColor, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: context.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: context.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Divider ──────────────────────────────────────────────────────────────────
class _Divider extends StatelessWidget {
  final bool isDarkMode;
  const _Divider({required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: 68,
      endIndent: 16,
      color: isDarkMode
          ? Colors.white.withOpacity(0.06)
          : Colors.black.withOpacity(0.06),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadow_pay_app/l10n/app_localizations.dart';
import 'package:shadow_pay_app/providers/language_provider.dart'; // أضف المسار الصحيح لملف الـ Provider
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsPage>
    with TickerProviderStateMixin {
  // ================= COLORS =================
  static const Color bgDark = Color(0xFF070C16);
  static const Color bgDark2 = Color(0xFF0B1A2A);
  static const Color primary = Color(0xFF1E8F7A);
  static const Color cardBorderColor = Color(0xFF1E2A3D);
  static const Color textSecondary = Color(0xFF8A9BB5);
  
  // Light theme colors
  static const Color bgLight = Color(0xFFF5F5F5);
  static const Color bgLight2 = Color(0xFFFFFFFF);
  static const Color cardBorderColorLight = Color(0xFFE0E0E0);
  static const Color textSecondaryLight = Color(0xFF666666);
  static const Color textPrimaryLight = Color(0xFF1A1A1A);

  // ================= ANIMATION CONTROLLERS =================
  late AnimationController _mainController;
  late AnimationController _headerController;
  late AnimationController _cardController;
  late final List<AnimationController> _sectionControllers = [];
  late final List<AnimationController> _itemControllers = [];
  late final List<AnimationController> _pressControllers = [];
  late AnimationController _dialogController;
  late AnimationController _langDialogController;
  late AnimationController _themeDialogController;

  // ================= STATES =================
  bool push = true;
  bool email = false;
  bool sms = true;
  bool sound = true;
  bool vibration = true;
  bool biometric = true;
  bool twoFA = false;
  bool autoLock = true;
  bool hideBalance = false;
  bool showLogout = false;
  bool showDelete = false;
  bool showLangDialog = false;
  bool showThemeDialog = false;
  bool isDarkMode = true; // Current theme state

  @override
  void initState() {
    super.initState();
    
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
    
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    
    for (int i = 0; i < 4; i++) {
      _sectionControllers.add(
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 600),
        )..forward(),
      );
    }
    
    for (int i = 0; i < 20; i++) {
      _itemControllers.add(
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 500),
        )..forward(),
      );
    }
    
    for (int i = 0; i < 2; i++) {
      _pressControllers.add(
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 150),
        ),
      );
    }
    
    _dialogController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    
    _langDialogController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    
    _themeDialogController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _mainController.dispose();
    _headerController.dispose();
    _cardController.dispose();
    for (var c in _sectionControllers) { c.dispose(); }
    for (var c in _itemControllers) { c.dispose(); }
    for (var c in _pressControllers) { c.dispose(); }
    _dialogController.dispose();
    _langDialogController.dispose();
    _themeDialogController.dispose();
    super.dispose();
  }

  Animation<double> _fadeIn(AnimationController controller, {double delay = 0}) {
    return CurvedAnimation(
      parent: controller,
      curve: Interval(delay, 1, curve: Curves.easeOutCubic),
    );
  }

  Animation<Offset> _slideUp(AnimationController controller, {double delay = 0}) {
    return Tween(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(delay, 1, curve: Curves.easeOutQuart),
      ),
    );
  }

  Animation<double> _scaleIn(AnimationController controller, {double delay = 0}) {
    return Tween(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(delay, 1, curve: Curves.easeOutBack),
      ),
    );
  }

  Animation<double> _pressAnimation(AnimationController controller) {
    return Tween(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOutCubic,
      ),
    );
  }
 void _showDialog(bool delete) {
    _dialogController.forward(from: 0.0);
    setState(() {
      if (delete) {
        showDelete = true;
      } else {
        showLogout = true;
      }
    });
  }

  void _hideDialog() {
    _dialogController.reverse().then((_) {
      setState(() {
        showLogout = false;
        showDelete = false;
      });
    });
  }

  void _showLanguageDialog() {
    _langDialogController.forward(from: 0.0);
    setState(() {
      showLangDialog = true;
    });
  }

  void _hideLanguageDialog() {
    _langDialogController.reverse().then((_) {
      setState(() {
        showLangDialog = false;
      });
    });
  }

  void _showThemeDialog() {
    _themeDialogController.forward(from: 0.0);
    setState(() {
      showThemeDialog = true;
    });
  }

  void _hideThemeDialog() {
    _themeDialogController.reverse().then((_) {
      setState(() {
        showThemeDialog = false;
      });
    });
  }

  Future<void> _changeLanguage(String languageCode) async {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    await languageProvider.changeLanguage(languageCode);
    _hideLanguageDialog();
    
    // عرض رسالة تأكيد
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          languageCode == 'ar' 
              ? 'تم تغيير اللغة إلى العربية' 
              : 'Language changed to English',
        ),
        backgroundColor: primary,
        duration: const Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _changeTheme(bool isDark) {
    setState(() {
      isDarkMode = isDark;
    });
    _hideThemeDialog();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isDark ? 'تم التبديل إلى الوضع الداكن' : 'Switched to light mode'),
        backgroundColor: primary,
        duration: const Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Color getCurrentBgColor() {
    return isDarkMode ? bgDark : bgLight;
  }

  Color getCurrentCardBorderColor() {
    return isDarkMode ? cardBorderColor : cardBorderColorLight;
  }

  Color getCurrentTextSecondaryColor() {
    return isDarkMode ? textSecondary : textSecondaryLight;
  }

  String _getCurrentLanguageName() {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final currentLang = languageProvider.locale.languageCode;
    
    if (currentLang == 'ar') {
      return 'العربية';
    } else {
      return 'English';
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';
    
    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: getCurrentBgColor(),
        body: Stack(
          children: [
            AnimatedBuilder(
              animation: _mainController,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: isDarkMode
                          ? const [
                              Color(0xFF070C16),
                              Color(0xFF0B1A2A),
                              Color(0xFF070C16),
                            ]
                          : const [
                              Color(0xFFF5F5F5),
                              Color(0xFFFFFFFF),
                              Color(0xFFF5F5F5),
                            ],
                    ),
                  ),
                );
              },
            ),
            
            SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(20),
                physics: const BouncingScrollPhysics(),
                children: [
                  AnimatedBuilder(
                    animation: _headerController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeIn(_headerController),
                        child: SlideTransition(
                          position: _slideUp(_headerController),
                          child: _header(loc),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  AnimatedBuilder(
                    animation: _cardController,
                    builder: (context, child) {
                      return ScaleTransition(
                        scale: _scaleIn(_cardController),
                        child: FadeTransition(
                          opacity: _fadeIn(_cardController),
                          child: _appCard(loc),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  _buildAnimatedSection(
                    index: 0,
                    title: loc.notifications,
                    color: primary,
                    icon: Icons.notifications_active,
                    children: [
                      _toggle(
                        title: loc.pushNotifications,
                        desc: loc.pushNotificationsDesc,
                        icon: Icons.notifications,
                        value: push,
                        onChanged: (v) => setState(() => push = v),
                        index: 0,
                      ),
                      _toggle(
                        title: loc.emailNotifications,
                        desc: loc.emailNotificationsDesc,
                        icon: Icons.email,
                        value: email,
                        onChanged: (v) => setState(() => email = v),
                        index: 1,
                      ),
                      _toggle(
                        title: loc.sms,
                        desc: loc.smsDesc,
                        icon: Icons.sms,
                        value: sms,
                        onChanged: (v) => setState(() => sms = v),
                        index: 2,
                      ),
                      _toggle(
                        title: loc.sound,
                        desc: loc.soundDesc,
                        icon: Icons.volume_up,
                        value: sound,
                        onChanged: (v) => setState(() => sound = v),
                        index: 3,
                      ),
                      _toggle(
                        title: loc.vibration,
                        desc: loc.vibrationDesc,
                        icon: Icons.vibration,
                        value: vibration,
                        onChanged: (v) => setState(() => vibration = v),
                        index: 4,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  _buildAnimatedSection(
                    index: 1,
                    title: loc.securityPrivacy,
                    color: primary,
                    icon: Icons.security,
                    children: [
                      _toggle(
                        title: loc.biometric,
                        desc: loc.biometricDesc,
                        icon: Icons.fingerprint,
                        value: biometric,
                        onChanged: (v) => setState(() => biometric = v),
                        index: 5,
                      ),
                      _toggle(
                        title: loc.twoFA,
                        desc: loc.twoFADesc,
                        icon: Icons.shield,
                        value: twoFA,
                        onChanged: (v) => setState(() => twoFA = v),
                        index: 6,
                      ),
                      _toggle(
                        title: loc.autoLock,
                        desc: loc.autoLockDesc,
                        icon: Icons.lock,
                        value: autoLock,
                        onChanged: (v) => setState(() => autoLock = v),
                        index: 7,
                      ),
                      _toggle(
                        title: loc.hideBalance,
                        desc: loc.hideBalanceDesc,
                        icon: hideBalance ? Icons.visibility_off : Icons.visibility,
                        value: hideBalance,
                        onChanged: (v) => setState(() => hideBalance = v),
                        index: 8,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  _buildAnimatedSection(
                    index: 2,
                    title: loc.preferences,
                    color: primary,
                    icon: Icons.settings,
                    children: [
                      _button(
                        loc.language, 
                        _getCurrentLanguageName(),
                        Icons.language, 
                        index: 9, 
                        onTap: _showLanguageDialog
                      ),
                      _button(
                        loc.theme, 
                        isDarkMode ? loc.dark : loc.light, 
                        Icons.dark_mode, 
                        index: 10, 
                        onTap: _showThemeDialog
                      )
                    ],
                  ),

                  const SizedBox(height: 20),

                  _buildAnimatedSection(
                    index: 3,
                    title: loc.supportInfo,
                    color: primary,
                    icon: Icons.help_center,
                    children: [
                      _button(loc.about, null, Icons.info, index: 12, supportType: 'about'),
                      _button(loc.helpCenter, null, Icons.support_agent, index: 13, supportType: 'help'),
                      _button(loc.privacyPolicy, null, Icons.privacy_tip, index: 14, supportType: 'privacy'),
                      _button(loc.termsOfService, null, Icons.description, index: 15, supportType: 'terms'),
                    ],
                  ),

                  const SizedBox(height: 30),

                  _buildAnimatedButtonWithPress(
                    child: _dangerBtn(loc.logout, Icons.logout, () {
                      _showDialog(false);
                    }, pressController: _pressControllers[0]),
                    index: 16,
                  ),

                  const SizedBox(height: 12),

                  _buildAnimatedButtonWithPress(
                    child: _dangerBtn(loc.deleteAccount, Icons.delete, () {
                      _showDialog(true);
                    }, small: true, pressController: _pressControllers[1]),
                    index: 17,
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),

            if (showLogout || showDelete) _animatedDialog(loc),
            if (showLangDialog) _animatedLanguageDialog(loc),
            if (showThemeDialog) _animatedThemeDialog(loc),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedSection({
    required int index,
    required String title,
    required Color color,
    required IconData icon,
    required List<Widget> children,
  }) {
    return AnimatedBuilder(
      animation: _sectionControllers[index],
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeIn(_sectionControllers[index]),
          child: SlideTransition(
            position: _slideUp(_sectionControllers[index], delay: 0.1),
            child: _container(
              title: title,
              color: color,
              icon: icon,
              children: children,
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedButtonWithPress({
    required Widget child,
    required int index,
  }) {
    return AnimatedBuilder(
      animation: _itemControllers[index],
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeIn(_itemControllers[index], delay: 0.2),
          child: SlideTransition(
            position: _slideUp(_itemControllers[index], delay: 0.15),
            child: ScaleTransition(
              scale: _scaleIn(_itemControllers[index], delay: 0.1),
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }

  Widget _animatedDialog(AppLocalizations loc) {
    bool delete = showDelete;
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
            child: _dialog(delete, loc),
          ),
        );
      },
    );
  }

  Widget _animatedLanguageDialog(AppLocalizations loc) {
    return AnimatedBuilder(
      animation: _langDialogController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _langDialogController,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.7, end: 1.0).animate(
              CurvedAnimation(
                parent: _langDialogController,
                curve: Curves.easeOutBack,
              ),
            ),
            child: _languageDialog(loc),
          ),
        );
      },
    );
  }

  Widget _animatedThemeDialog(AppLocalizations loc) {
    return AnimatedBuilder(
      animation: _themeDialogController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _themeDialogController,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.7, end: 1.0).animate(
              CurvedAnimation(
                parent: _themeDialogController,
                curve: Curves.easeOutBack,
              ),
            ),
            child: _themeDialog(loc),
          ),
        );
      },
    );
  }

  Widget _container({
    required String title,
    required Color color,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF0F1C2E) : bgLight2,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: getCurrentCardBorderColor(),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.5 : 0.1),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: primary.withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color.withOpacity(0.8), size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : textPrimaryLight,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                const Spacer(),
                Container(
                  width: 3,
                  height: 20,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            color: color.withOpacity(0.1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _header(AppLocalizations loc) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 500),
      tween: Tween<double>(begin: 0.9, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Row(
            children: [
              GestureDetector(
                onTapUp: (_) => Navigator.pop(context),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: primary.withOpacity(0.25),
                      width: 1,
                    ),
                  ),
                  child: Icon(Icons.arrow_forward_ios, color: primary.withOpacity(0.8), size: 20),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.settingsTitle,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : textPrimaryLight,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    loc.settingsSubtitle,
                    style: TextStyle(color: getCurrentTextSecondaryColor(), fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _appCard(AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.all(1.2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          colors: [
            primary.withOpacity(0.25),
            Colors.transparent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? const [
                    Color(0xFF0F2F2F),
                    Color(0xFF0A2323),
                  ]
                : const [
                    Color(0xFFE8F5E9),
                    Color(0xFFC8E6C9),
                  ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDarkMode ? 0.45 : 0.1),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: primary.withOpacity(0.18),
              blurRadius: 20,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: primary.withOpacity(0.4),
                    blurRadius: 12,
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  'assets/icon/icon.png',
                  width: 54,
                  height: 54,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primary, primary.withOpacity(0.6)],
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(Icons.payment, color: Colors.white),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ShadowPay",
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : textPrimaryLight,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    loc.version,
                    style: TextStyle(
                      color: primary.withOpacity(0.9),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.verified,
                        size: 12,
                        color: primary.withOpacity(0.9),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        loc.securedByAI,
                        style: TextStyle(
                          color: primary.withOpacity(0.75),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    primary.withOpacity(0.25),
                    primary.withOpacity(0.1),
                  ],
                ),
                border: Border.all(
                  color: primary.withOpacity(0.4),
                ),
              ),
              child: Text(
                loc.verified,
                style: TextStyle(
                  color: primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggle({
    required String title,
    required String desc,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
    required int index,
  }) {
    return AnimatedBuilder(
      animation: _itemControllers[index],
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeIn(_itemControllers[index], delay: 0.3),
          child: SlideTransition(
            position: _slideUp(_itemControllers[index], delay: 0.2),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.02),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: getCurrentCardBorderColor().withOpacity(0.25),
                  width: 0.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: primary.withOpacity(0.8), size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : textPrimaryLight,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          desc,
                          style: TextStyle(
                            color: getCurrentTextSecondaryColor(),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _switch(value, onChanged),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _getSupportUrl(String type) {
    switch (type) {
      case 'about':
        return 'https://martinasameh1.github.io/settings/';
      case 'help':
        return 'https://martinasameh1.github.io/settings/help.html';
      case 'privacy':
        return 'https://martinasameh1.github.io/settings/privacy.html';
      case 'terms':
        return 'https://martinasameh1.github.io/settings/terms.html';
      default:
        return 'https://martinasameh1.github.io/settings/';
    }
  }

  Widget _button(String title, String? value, IconData icon, 
      {required int index, String supportType = '', VoidCallback? onTap}) {
    return AnimatedBuilder(
      animation: _itemControllers[index],
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeIn(_itemControllers[index], delay: 0.3),
          child: SlideTransition(
            position: _slideUp(_itemControllers[index], delay: 0.2),
            child: GestureDetector(
              onTap: onTap ?? () async {
                if (supportType.isNotEmpty) {
                  String url = _getSupportUrl(supportType);
                  final uri = Uri.parse(url);
                  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('فشل في فتح $title'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('جاري فتح $title...'),
                      backgroundColor: primary,
                      duration: const Duration(milliseconds: 800),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.02),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: getCurrentCardBorderColor().withOpacity(0.25),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: primary.withOpacity(0.8), size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : textPrimaryLight, 
                          fontSize: 14
                        ),
                      ),
                    ),
                    if (value != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          value,
                          style: TextStyle(color: primary.withOpacity(0.7), fontSize: 12),
                        ),
                      ),
                    const SizedBox(width: 8),
                    Icon(Icons.arrow_forward_ios, size: 14, color: getCurrentTextSecondaryColor()),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _dangerBtn(String title, IconData icon, VoidCallback onTap,
      {bool small = false, required AnimationController pressController}) {
    return GestureDetector(
      onTapDown: (_) => pressController.forward(),
      onTapUp: (_) => pressController.reverse(),
      onTapCancel: () => pressController.reverse(),
      onTap: onTap,
      child: ScaleTransition(
        scale: _pressAnimation(pressController),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: small ? 10 : 14,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: small
                  ? [Colors.red.shade600, Colors.red.shade800]
                  : [Colors.red.shade700, Colors.red.shade900],
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.35),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: small ? 16 : 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _languageDialog(AppLocalizations loc) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final currentLang = languageProvider.locale.languageCode;
    
    return GestureDetector(
      onTap: _hideLanguageDialog,
      child: Container(
        color: Colors.black.withOpacity(0.7),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF0F1C2E) : bgLight2,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: primary.withOpacity(0.25),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 25,
                  offset: const Offset(0, 15),
                ),
                BoxShadow(
                  color: primary.withOpacity(0.05),
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
                          color: primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.language,
                          size: 44,
                          color: primary.withOpacity(0.8),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  'اختر اللغة',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : textPrimaryLight,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _dialogOption(
                  title: 'العربية',
                  subtitle: 'Arabic',
                  icon: Icons.translate,
                  isSelected: currentLang == 'ar',
                  onTap: () => _changeLanguage('ar'),
                ),
                const SizedBox(height: 12),
                _dialogOption(
                  title: 'English',
                  subtitle: 'الإنجليزية',
                  icon: Icons.translate,
                  isSelected: currentLang == 'en',
                  onTap: () => _changeLanguage('en'),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _hideLanguageDialog,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: getCurrentCardBorderColor().withOpacity(0.25),
                        width: 0.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        loc.cancel,
                        style: TextStyle(color: isDarkMode ? Colors.white : textPrimaryLight, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _themeDialog(AppLocalizations loc) {
    return GestureDetector(
      onTap: _hideThemeDialog,
      child: Container(
        color: Colors.black.withOpacity(0.7),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF0F1C2E) : bgLight2,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: primary.withOpacity(0.25),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 25,
                  offset: const Offset(0, 15),
                ),
                BoxShadow(
                  color: primary.withOpacity(0.05),
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
                          color: primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.palette,
                          size: 44,
                          color: primary.withOpacity(0.8),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  'اختر الثيم',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : textPrimaryLight,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _dialogOption(
                  title: 'داكن',
                  subtitle: 'Dark Mode',
                  icon: Icons.dark_mode,
                  isSelected: isDarkMode == true,
                  onTap: () => _changeTheme(true),
                ),
                const SizedBox(height: 12),
                _dialogOption(
                  title: 'فاتح',
                  subtitle: 'Light Mode',
                  icon: Icons.light_mode,
                  isSelected: isDarkMode == false,
                  onTap: () => _changeTheme(false),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _hideThemeDialog,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: getCurrentCardBorderColor().withOpacity(0.25),
                        width: 0.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        loc.cancel,
                        style: TextStyle(color: isDarkMode ? Colors.white : textPrimaryLight, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dialogOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? primary.withOpacity(0.15) : Colors.white.withOpacity(0.02),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? primary : getCurrentCardBorderColor().withOpacity(0.25),
            width: isSelected ? 1.5 : 0.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: primary.withOpacity(0.8), size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : textPrimaryLight,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: getCurrentTextSecondaryColor(),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: primary, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _dialog(bool delete, AppLocalizations loc) {
    return GestureDetector(
      onTap: _hideDialog,
      child: Container(
        color: Colors.black.withOpacity(0.7),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF0F1C2E) : bgLight2,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: delete ? Colors.red.withOpacity(0.25) : primary.withOpacity(0.25),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 25,
                  offset: const Offset(0, 15),
                ),
                if (!delete)
                  BoxShadow(
                    color: primary.withOpacity(0.05),
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
                          color: delete ? Colors.red.withOpacity(0.1) : primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          delete ? Icons.delete_forever : Icons.logout,
                          size: 44,
                          color: delete ? Colors.red.shade300 : primary.withOpacity(0.8),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  delete ? loc.deleteDialogTitle : loc.logoutDialogTitle,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : textPrimaryLight,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  delete ? loc.deleteDialogMessage : loc.logoutDialogMessage,
                  style: TextStyle(color: getCurrentTextSecondaryColor(), fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _hideDialog,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: getCurrentCardBorderColor().withOpacity(0.25),
                              width: 0.5,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              loc.cancel,
                              style: TextStyle(color: isDarkMode ? Colors.white : textPrimaryLight, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: GestureDetector(
                        onTap: _hideDialog,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: delete
                                  ? [Colors.red.shade700, Colors.red.shade900]
                                  : [primary, primary.withOpacity(0.6)],
                            ),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: delete
                                ? []
                                : [
                                    BoxShadow(
                                      color: primary.withOpacity(0.25),
                                      blurRadius: 8,
                                    ),
                                  ],
                          ),
                          child: Center(
                            child: Text(
                              delete ? loc.delete : loc.confirm,
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

  Widget _switch(bool value, Function(bool) onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
        width: 48,
        height: 26,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: value ? primary : const Color(0xFF2A354A),
          borderRadius: BorderRadius.circular(20),
          boxShadow: value
              ? [
                  BoxShadow(
                    color: primary.withOpacity(0.35),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ]
              : [],
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
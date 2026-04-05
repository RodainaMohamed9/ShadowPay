import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shadow_pay_app/l10n/app_localizations.dart';
import 'package:shadow_pay_app/screens/Settings/Settings.dart';
import 'package:shadow_pay_app/theme/colors.dart';
import 'package:shadow_pay_app/providers/theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';
    final isDarkMode = context.isDarkMode;

    final String userName = "Ahmed Al-Sayed";
    final String userEmail = "ahmed@example.com";
    final String userPhone = "+966 50 123 4567";
    final String firstLetter =
        userName.isNotEmpty ? userName[0].toUpperCase() : "A";

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Transform.scale(
            scaleX: isRTL ? -1 : 1,
            child: Icon(Icons.arrow_back, color: context.textPrimary),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: null,
        centerTitle: true,
        iconTheme: IconThemeData(color: context.textPrimary),
      ),
      body: Column(
        children: [
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Profile Avatar with verification badge
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [context.primaryColor, context.secondaryColor],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: context.primaryColor.withOpacity(0.3),
                                blurRadius: 25,
                                spreadRadius: 5,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 65,
                            backgroundColor: Colors.transparent,
                            child: Text(
                              firstLetter,
                              style: const TextStyle(
                                fontSize: 55,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        // Verified Badge
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: context.primaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: context.backgroundColor,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Name
                    Text(
                      userName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: context.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Membership
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: context.primaryColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: context.primaryColor.withOpacity(0.3),
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        localizations.premium_member,
                        style: TextStyle(
                          fontSize: 13,
                          color: context.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),

                    // Personal Info Card
                    Container(
                      decoration: BoxDecoration(
                        color: context.surfaceColor,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isDarkMode ? const Color(0xFF1F2A44) : Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          // Header
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDarkMode ? const Color(0xFF1F2A44) : Colors.grey.shade200,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: context.primaryColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.person_outline,
                                    color: context.primaryColor,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  localizations.personal_info,
                                  style: TextStyle(
                                    color: context.textPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Content
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                _CopyableInfoTile(
                                  icon: Icons.email_outlined,
                                  label: localizations.email,
                                  value: userEmail,
                                  isRTL: isRTL,
                                  onCopy: () {
                                    _copyToClipboard(
                                        context, userEmail, localizations);
                                  },
                                ),
                                Divider(
                                  color: isDarkMode ? const Color(0xFF1F2A44) : Colors.grey.shade300,
                                  height: 20,
                                ),
                                _CopyableInfoTile(
                                  icon: Icons.phone_outlined,
                                  label: localizations.phone,
                                  value: userPhone,
                                  isRTL: isRTL,
                                  onCopy: () {
                                    _copyToClipboard(
                                        context, userPhone, localizations);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Buttons
          Container(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            decoration: BoxDecoration(
              color: context.backgroundColor,
              border: Border(
                top: BorderSide(
                  color: isDarkMode ? const Color(0xFF1F2A44) : Colors.grey.shade300,
                  width: 0.5,
                ),
              ),
            ),
            child: Column(
              children: [
                // Settings Button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode ? const Color(0xFF1F2A44) : Colors.grey.shade200,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  },
                  icon: Icon(Icons.settings, color: context.primaryColor, size: 20),
                  label: Text(
                    localizations.settings,
                    style: TextStyle(
                      color: context.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Logout Button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.errorColor.withOpacity(0.1),
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    side: BorderSide(color: context.errorColor, width: 1),
                  ),
                  onPressed: () {
                    _showLogoutDialog(context, localizations);
                  },
                  icon: const Icon(Icons.logout, color: Colors.red, size: 20),
                  label: Text(
                    localizations.logout,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(
      BuildContext context, String text, AppLocalizations localizations) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          localizations.copied_to_clipboard,
          style: const TextStyle(fontSize: 14),
        ),
        backgroundColor: context.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AppLocalizations localizations) {
    final isDarkMode = context.isDarkMode;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.surfaceColor,
        title: Text(
          localizations.logout,
          style: TextStyle(color: context.textPrimary, fontSize: 20),
        ),
        content: Text(
          localizations.logout_confirmation,
          style: TextStyle(color: context.textSecondary, fontSize: 14),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              localizations.cancel,
              style: TextStyle(color: context.textSecondary, fontSize: 14),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: context.errorColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            child: Text(
              localizations.logout,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable widget with press effect
class _CopyableInfoTile extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isRTL;
  final VoidCallback onCopy;

  const _CopyableInfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.isRTL,
    required this.onCopy,
  });

  @override
  State<_CopyableInfoTile> createState() => _CopyableInfoTileState();
}

class _CopyableInfoTileState extends State<_CopyableInfoTile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.isDarkMode;
    
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF1F2A44) : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(widget.icon, color: context.primaryColor, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: widget.isRTL
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  color: context.textSecondary,
                  fontSize: 12,
                ),
                textAlign: widget.isRTL ? TextAlign.right : TextAlign.left,
              ),
              const SizedBox(height: 4),
              Text(
                widget.value,
                style: TextStyle(
                  color: context.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                textDirection: TextDirection.ltr,
                textAlign: widget.isRTL ? TextAlign.right : TextAlign.left,
              ),
            ],
          ),
        ),
        // Copy button with press effect
        GestureDetector(
          onTapDown: (_) {
            setState(() {
              _isPressed = true;
            });
          },
          onTapUp: (_) {
            setState(() {
              _isPressed = false;
            });
            widget.onCopy();
          },
          onTapCancel: () {
            setState(() {
              _isPressed = false;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            transform: Matrix4.identity()..scale(_isPressed ? 0.85 : 1.0),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _isPressed
                    ? context.primaryColor.withOpacity(0.3)
                    : (isDarkMode ? const Color(0xFF1F2A44) : Colors.grey.shade200),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.copy,
                color: _isPressed ? Colors.white : context.primaryColor,
                size: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
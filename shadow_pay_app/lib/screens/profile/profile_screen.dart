import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shadow_pay_app/l10n/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';

    final String userName = "Ahmed Al-Sayed";
    final String userEmail = "ahmed@example.com";
    final String userPhone = "+966 50 123 4567";
    final String firstLetter = userName.isNotEmpty ? userName[0].toUpperCase() : "A";

    return Scaffold(
      backgroundColor: const Color(0xFF0D111F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D111F),
        elevation: 0,
        leading: IconButton(
          icon: Transform.scale(
            scaleX: isRTL ? -1 : 1,
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: null,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // المحتوى القابل للتمرير
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
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00D8A2), Color(0xFF00B8A2)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00D8A2).withOpacity(0.3),
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
                            color: const Color(0xFF00D8A2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF0D111F),
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
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Membership
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00D8A2).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: const Color(0xFF00D8A2).withOpacity(0.3),
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        localizations.premium_member,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF00D8A2),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),

                    // Personal Info Card
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF141A2B),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xFF1F2A44),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          // Header
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1F2A44),
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
                                    color: const Color(0xFF00D8A2).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.person_outline,
                                    color: Color(0xFF00D8A2),
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  localizations.personal_info,
                                  style: const TextStyle(
                                    color: Colors.white,
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
                                    _copyToClipboard(context, userEmail, localizations);
                                  },
                                ),
                                const Divider(
                                  color: Color(0xFF1F2A44),
                                  height: 20,
                                ),
                                _CopyableInfoTile(
                                  icon: Icons.phone_outlined,
                                  label: localizations.phone,
                                  value: userPhone,
                                  isRTL: isRTL,
                                  onCopy: () {
                                    _copyToClipboard(context, userPhone, localizations);
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

          // الأزرار في الأسفل
          Container(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            decoration: BoxDecoration(
              color: const Color(0xFF0D111F),
              border: Border(
                top: BorderSide(
                  color: const Color(0xFF1F2A44),
                  width: 0.5,
                ),
              ),
            ),
            child: Column(
              children: [
                // Settings Button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1F2A44),
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () {
                    // go to settings
                  },
                  icon: const Icon(Icons.settings, color: Color(0xFF00D8A2), size: 20),
                  label: Text(
                    localizations.settings,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Logout Button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(0.1),
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    side: const BorderSide(color: Colors.red, width: 1),
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

  void _copyToClipboard(BuildContext context, String text, AppLocalizations localizations) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          localizations.copied_to_clipboard,
          style: const TextStyle(fontSize: 14),
        ),
        backgroundColor: const Color(0xFF00D8A2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AppLocalizations localizations) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF141A2B),
        title: Text(
          localizations.logout,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        content: Text(
          localizations.logout_confirmation,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
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
              style: const TextStyle(color: Colors.white54, fontSize: 14),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
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

// Widget قابل لإعادة الاستخدام مع تأثير عند الضغط
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
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1F2A44),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(widget.icon, color: const Color(0xFF00D8A2), size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: widget.isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              // الـ label يتجه حسب اللغة
              Text(
                widget.label,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
                textAlign: widget.isRTL ? TextAlign.right : TextAlign.left,
              ),
              const SizedBox(height: 4),
              // القيمة تبقى LTR عشان الأرقام والإيميل
              Text(
                widget.value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                textDirection: TextDirection.ltr,
                textAlign: widget.isRTL ? TextAlign.right : TextAlign.left,
              ),
            ],
          ),
        ),
        // أيقونة النسخ مع تأثير عند الضغط
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
            transform: Matrix4.identity()
              ..scale(_isPressed ? 0.85 : 1.0),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _isPressed 
                    ? const Color(0xFF00D8A2).withOpacity(0.3)
                    : const Color(0xFF1F2A44),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.copy,
                color: _isPressed ? Colors.white : const Color(0xFF00D8A2),
                size: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
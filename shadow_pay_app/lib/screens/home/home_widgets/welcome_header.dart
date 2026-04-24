import 'package:flutter/material.dart';
import 'package:shadow_pay_app/l10n/app_localizations.dart';
import 'package:shadow_pay_app/theme/colors.dart';

class WelcomeHeader extends StatelessWidget {
  final String userName;
  final VoidCallback? onManageTap;
  final bool isFrozen;
  final bool isDarkMode;

  const WelcomeHeader({
    super.key,
    required this.userName,
    this.onManageTap,
    this.isFrozen = false,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final firstName = userName.split(' ')[0];

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.welcomeBack,
                style: TextStyle(
                  color: isDarkMode ? Colors.white54 : Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                firstName,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (isFrozen && onManageTap != null)
            GestureDetector(
              onTap: onManageTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.red.withOpacity(0.5), width: 1),
                ),
                child: Text(
                  'Manage',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
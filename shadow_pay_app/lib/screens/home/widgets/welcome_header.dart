import 'package:flutter/material.dart';
import 'package:shadow_pay_app/l10n/app_localizations.dart';

class WelcomeHeader extends StatelessWidget {
  final String userName;
  final VoidCallback? onManageTap;
  final bool isFrozen;

  const WelcomeHeader({
    super.key,
    required this.userName,
    this.onManageTap,
    this.isFrozen = false,
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
              Text(loc.welcomeBack, style: const TextStyle(color: Colors.white54, fontSize: 12)),
              const SizedBox(height: 2),
              Text(firstName, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
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
                child: const Text('Manage', style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }
}
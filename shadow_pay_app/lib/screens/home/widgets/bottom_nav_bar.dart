import 'package:flutter/material.dart';
import 'package:shadow_pay_app/l10n/app_localizations.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    
    final List<Map<String, dynamic>> navItems = [
      {'icon': Icons.home_outlined, 'label': loc.home},
      {'icon': Icons.bar_chart_outlined, 'label': loc.analytics},
      {'icon': Icons.credit_card_outlined, 'label': loc.cards},
      {'icon': Icons.person_outline, 'label': loc.profile},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0F1F),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.05),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(navItems.length, (index) {
          final isSelected = currentIndex == index;
          return GestureDetector(
            onTap: () => onTap(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  navItems[index]['icon'],
                  color: isSelected
                      ? const Color(0xFF00D8A2)
                      : Colors.white.withOpacity(0.4),
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  navItems[index]['label'],
                  style: TextStyle(
                    color: isSelected
                        ? const Color(0xFF00D8A2)
                        : Colors.white.withOpacity(0.4),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:shadow_pay_app/l10n/app_localizations.dart';
import 'package:shadow_pay_app/theme/colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isDarkMode;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    
    final List<Map<String, dynamic>> navItems = [
      {'icon': Icons.home_outlined, 'activeIcon': Icons.home, 'label': loc.home},
      {'icon': Icons.credit_card_outlined, 'activeIcon': Icons.credit_card, 'label': loc.cards},
      {'icon': Icons.report_outlined, 'activeIcon': Icons.report, 'label': loc.report},
      {'icon': Icons.person_outline, 'activeIcon': Icons.person, 'label': loc.profile},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF0A0F1F) : Colors.white,
        border: Border(
          top: BorderSide(
            color: (isDarkMode ? Colors.white : Colors.black).withOpacity(0.05),
            width: 1,
          ),
        ),
        boxShadow: [
          if (!isDarkMode)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(navItems.length, (index) {
final isSelected = currentIndex >= 0 && currentIndex == index;
          final color = isSelected
              ? (isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary)
              : (isDarkMode ? Colors.white.withOpacity(0.4) : Colors.grey.withOpacity(0.6));
          
          return GestureDetector(
            onTap: () => onTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.1))
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isSelected ? navItems[index]['activeIcon'] : navItems[index]['icon'],
                    color: color,
                    size: isSelected ? 26 : 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    navItems[index]['label'],
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
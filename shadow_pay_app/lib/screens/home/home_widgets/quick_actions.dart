import 'package:flutter/material.dart';
import 'package:shadow_pay_app/l10n/app_localizations.dart';
import 'package:shadow_pay_app/theme/colors.dart';

class QuickActions extends StatelessWidget {
  final VoidCallback onAddTap;
  final VoidCallback onReportTap;
  final VoidCallback onDetailsTap;
  final VoidCallback onFreezeTap;
  final VoidCallback onManageTap;
  final bool isCardFrozen;
  final bool isDarkMode;

  const QuickActions({
    super.key,
    required this.onAddTap,
    required this.onReportTap,
    required this.onDetailsTap,
    required this.onFreezeTap,
    required this.onManageTap,
    this.isCardFrozen = false,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.quickActions,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildAction(
              icon: Icons.add_circle_outline,
              label: loc.add,
              color: isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary,
              onTap: onAddTap,
            ),
            _buildAction(
              icon: Icons.flag_outlined,
              label: loc.report,
              color: const Color(0xFF9C27B0),
              onTap: onReportTap,
            ),
            _buildAction(
              icon: Icons.info_outline,
              label: loc.details,
              color: const Color(0xFFFF9800),
              onTap: onDetailsTap,
            ),
            _buildFreezeAction(loc),
          ],
        ),
      ],
    );
  }

  Widget _buildFreezeAction(AppLocalizations loc) {
    final isFrozen = isCardFrozen;
    final label = isFrozen ? loc.frozen : loc.freeze;
    final onTap = isFrozen ? onManageTap : onFreezeTap;
    final iconColor = isFrozen ? Colors.red : const Color(0xFFF44336);
    final bgColor = isFrozen ? Colors.red.withOpacity(0.2) : const Color(0xFFF44336).withOpacity(0.1);
    final borderColor = isFrozen ? Colors.red.withOpacity(0.5) : const Color(0xFFF44336).withOpacity(0.3);
    final textColor = isFrozen ? Colors.red : (isDarkMode ? Colors.white70 : Colors.grey[700]);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: borderColor,
                width: 1,
              ),
            ),
            child: Icon(
              Icons.ac_unit,
              color: iconColor,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isFrozen ? Colors.red.withOpacity(0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isFrozen ? Colors.red : textColor,
                fontSize: 12,
                fontWeight: isFrozen ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.grey[700],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
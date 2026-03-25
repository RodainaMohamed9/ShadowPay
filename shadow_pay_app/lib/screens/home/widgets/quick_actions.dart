import 'package:flutter/material.dart';
import 'package:shadow_pay_app/l10n/app_localizations.dart';

class QuickActions extends StatelessWidget {
  final VoidCallback onAddTap;
  final VoidCallback onReportTap;
  final VoidCallback onDetailsTap;
  final VoidCallback onFreezeTap;
  final VoidCallback onManageTap;
  final bool isCardFrozen;

  const QuickActions({
    super.key,
    required this.onAddTap,
    required this.onReportTap,
    required this.onDetailsTap,
    required this.onFreezeTap,
    required this.onManageTap,
    this.isCardFrozen = false,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(loc.quickActions, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildAction(icon: Icons.add_circle_outline, label: loc.add, color: 0xFF00D8A2, onTap: onAddTap),
            _buildAction(icon: Icons.flag_outlined, label: loc.report, color: 0xFF9C27B0, onTap: onReportTap),
            _buildAction(icon: Icons.info_outline, label: loc.details, color: 0xFFFF9800, onTap: onDetailsTap),
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

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFF44336).withOpacity(0.1),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFFF44336).withOpacity(0.3), width: 1),
            ),
            child: const Icon(Icons.ac_unit, color: Color(0xFFF44336), size: 28),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isFrozen ? Colors.red.withOpacity(0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isFrozen ? Colors.red : Colors.white.withOpacity(0.8),
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
    required int color,
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
              color: Color(color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Color(color).withOpacity(0.3), width: 1),
            ),
            child: Icon(icon, color: Color(color), size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
          ),
        ],
      ),
    );
  }
}
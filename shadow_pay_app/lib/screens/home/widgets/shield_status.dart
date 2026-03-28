import 'package:flutter/material.dart';
import 'package:shadow_pay_app/l10n/app_localizations.dart';

class ShieldStatus extends StatefulWidget {
  const ShieldStatus({super.key});

  @override
  State<ShieldStatus> createState() => _ShieldStatusState();
}

class _ShieldStatusState extends State<ShieldStatus>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF00D8A2).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // ✅ أيقونة Shield أكبر (size 36)
          RotationTransition(
            turns: _rotationAnimation,
            child: const Icon(
              Icons.shield_outlined,
              color: Color(0xFF00D8A2),
              size: 36,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      loc.aiWatchdogActive,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      loc.system,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  loc.liveProtection,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}
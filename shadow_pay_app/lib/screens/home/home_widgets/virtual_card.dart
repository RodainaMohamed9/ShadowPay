import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:shadow_pay_app/l10n/app_localizations.dart';
import 'package:shadow_pay_app/theme/colors.dart';

class VirtualCard extends StatefulWidget {
  final String cardNumber;
  final String cardHolder;
  final String expiry;
  final double balance;
  final bool isFrozen;
  final bool isDarkMode;

  const VirtualCard({
    super.key,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiry,
    required this.balance,
    this.isFrozen = false,
    required this.isDarkMode,
  });

  @override
  State<VirtualCard> createState() => _VirtualCardState();
}

class _VirtualCardState extends State<VirtualCard> {
  bool _showBalance = false;

  String _formatCardNumber(String number) {
    if (number.isEmpty) return '•••• •••• •••• 4829';
    final last4 = number.length >= 4 ? number.substring(number.length - 4) : number;
    return '•••• •••• •••• $last4';
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final primaryColor = widget.isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary;

    // ✅ ألوان الكارد - Burgundy للفريز
    final List<Color> cardGradient = widget.isFrozen
        ? [const Color(0xFF800020), const Color(0xFF4A0020)] // 🟤 Burgundy (أحمر غامق)
        : (widget.isDarkMode
            ? [const Color(0xFF1A1F2E), const Color(0xFF2A2F3E)]
            : [const Color(0xFFE0E0E0), const Color(0xFFF5F5F5)]);

    return Container(
      width: double.infinity,
      height: 210,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: cardGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (widget.isFrozen ? const Color(0xFF800020) : primaryColor).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (widget.isFrozen ? const Color(0xFF800020) : primaryColor).withOpacity(0.15),
                ),
              ),
            ),
            Positioned(
              bottom: -40,
              left: -40,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (widget.isFrozen ? const Color(0xFF800020) : primaryColor).withOpacity(0.1),
                ),
              ),
            ),

            // Egyptian pattern
            if (!widget.isFrozen) ...[
              Positioned(
                top: 0,
                right: 0,
                child: CustomPaint(
                  size: const Size(120, 120),
                  painter: _EgyptianPattern(
                    color: primaryColor.withOpacity(0.15),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: CustomPaint(
                  size: const Size(100, 100),
                  painter: _EgyptianPattern(
                    color: primaryColor.withOpacity(0.1),
                  ),
                ),
              ),
              // Landscape icon زي الـ register
              Positioned(
                top: 15,
                right: 20,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: primaryColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.landscape,
                    color: primaryColor.withOpacity(0.4),
                    size: 24,
                  ),
                ),
              ),
            ],

            // Card Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Balance row في الأعلى
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (!widget.isFrozen)
                        GestureDetector(
                          onTap: () => setState(() => _showBalance = !_showBalance),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                loc.balance,
                                style: TextStyle(
                                  color: widget.isDarkMode ? Colors.white54 : Colors.grey[600],
                                  fontSize: 10,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Text(
                                    _showBalance
                                        ? '\$${widget.balance.toStringAsFixed(2)}'
                                        : '••••••',
                                    style: TextStyle(
                                      color: widget.isDarkMode ? Colors.white : Colors.black87,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(
                                    _showBalance ? Icons.visibility_off : Icons.visibility,
                                    color: widget.isDarkMode ? Colors.white54 : Colors.grey[600],
                                    size: 16,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      if (widget.isFrozen) const Spacer(),
                    ],
                  ),

                  const Spacer(),

                  // Card Number
                  Text(
                    _formatCardNumber(widget.cardNumber),
                    style: TextStyle(
                      color: widget.isDarkMode ? Colors.white : Colors.black87,
                      fontSize: 18,
                      letterSpacing: 2.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Bottom row - holder, expiry, VISA
                  Row(
                    children: [

                      // Card holder & expiry
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.cardHolder.isEmpty ? 'CARD HOLDER' : widget.cardHolder.toUpperCase(),
                              style: TextStyle(
                                color: widget.isDarkMode ? Colors.white : Colors.black87,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.expiry.isEmpty ? '09/29' : widget.expiry,
                              style: TextStyle(
                                color: widget.isDarkMode ? Colors.white54 : Colors.grey[600],
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // VISA / FROZEN
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            widget.isFrozen ? 'FROZEN' : 'VISA',
                            style: TextStyle(
                              color: widget.isFrozen
                                  ? const Color(0xFFFF6B6B)
                                  : primaryColor.withOpacity(0.8),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                          if (!widget.isFrozen)
                            Container(
                              width: 28,
                              height: 18,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Colors.amber.withOpacity(0.6),
                                  Colors.orange.withOpacity(0.4),
                                ]),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// نفس الـ Egyptian Pattern
class _EgyptianPattern extends CustomPainter {
  final Color color;
  _EgyptianPattern({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;

    final path = Path();
    for (int i = 0; i < 3; i++) {
      final startX = size.width * (0.2 + i * 0.3);
      final startY = size.height * 0.8;
      path.moveTo(startX, startY);
      path.lineTo(startX + 12, startY - 20);
      path.lineTo(startX - 12, startY - 20);
      path.close();
    }
    canvas.drawPath(path, paint);

    for (int i = 0; i < 3; i++) {
      final linePaint = Paint()..color = color..strokeWidth = 1..style = PaintingStyle.stroke;
      canvas.drawLine(
        Offset(size.width * 0.15, size.height * (0.4 + i * 0.15)),
        Offset(size.width * 0.85, size.height * (0.4 + i * 0.15)),
        linePaint,
      );
    }

    for (int i = 0; i < 5; i++) {
      canvas.drawCircle(
        Offset(size.width * (0.15 + i * 0.175), size.height * 0.6),
        2.5,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
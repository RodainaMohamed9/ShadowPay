import 'package:flutter/material.dart';
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
    if (number.isEmpty) return '••••  ••••  ••••  4829';
    if (number.length < 16) return '••••  ••••  ••••  ${number.substring(number.length - 4)}';
    return '••••  ••••  ••••  ${number.substring(number.length - 4)}';
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final primaryColor = widget.isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: widget.isFrozen
            ? const LinearGradient(colors: [Color(0xFF4A2A2A), Color(0xFF2A1A1A)])
            : (widget.isDarkMode
                ? const LinearGradient(colors: [Color(0xFF1A2A3A), Color(0xFF0F172A)])
                : const LinearGradient(colors: [Color(0xFFE0E0E0), Color(0xFFF5F5F5)])),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: widget.isFrozen 
              ? Colors.red.withOpacity(0.5) 
              : primaryColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.isFrozen 
                ? Colors.red.withOpacity(0.2) 
                : primaryColor.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (!widget.isFrozen)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Balance', 
                      style: TextStyle(
                        color: widget.isDarkMode ? Colors.white54 : Colors.grey[600], 
                        fontSize: 10
                      ),
                    ),
                    const SizedBox(height: 2),
                    GestureDetector(
                      onTap: () => setState(() => _showBalance = !_showBalance),
                      child: Row(
                        children: [
                          Text(
                            _showBalance ? '\$${widget.balance.toStringAsFixed(2)}' : '••••••',
                            style: TextStyle(
                              color: widget.isDarkMode ? Colors.white : Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
                    ),
                  ],
                ),
              if (widget.isFrozen) const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.isFrozen 
                      ? Colors.red.withOpacity(0.2) 
                      : primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  widget.isFrozen ? 'FROZEN' : 'VISA',
                  style: TextStyle(
                    color: widget.isFrozen ? Colors.red : primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              _formatCardNumber(widget.cardNumber),
              style: TextStyle(
                color: widget.isDarkMode ? Colors.white : Colors.black87,
                fontSize: 18,
                letterSpacing: 2,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.cardHolder,
                    style: TextStyle(
                      color: widget.isDarkMode ? Colors.white54 : Colors.grey[600],
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.cardHolder.isEmpty ? 'CARD HOLDER' : widget.cardHolder.toUpperCase(),
                    style: TextStyle(
                      color: widget.isDarkMode ? Colors.white : Colors.black87,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    loc.expiry,
                    style: TextStyle(
                      color: widget.isDarkMode ? Colors.white54 : Colors.grey[600],
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.expiry.isEmpty ? '09/29' : widget.expiry,
                    style: TextStyle(
                      color: widget.isDarkMode ? Colors.white : Colors.black87,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
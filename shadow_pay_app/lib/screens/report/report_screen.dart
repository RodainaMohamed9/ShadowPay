import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadow_pay_app/l10n/app_localizations.dart';
import 'package:shadow_pay_app/theme/colors.dart';
import 'package:shadow_pay_app/providers/theme_provider.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  int? _selectedReasonIndex;
  final TextEditingController _otherController = TextEditingController();
  bool _isSubmitting = false;

  final List<Map<String, dynamic>> _reasons = [
    {'icon': Icons.shopping_bag_outlined, 'titleKey': 'suspiciousTransaction', 'subtitleKey': 'suspiciousTransactionDesc'},
    {'icon': Icons.credit_card_off_outlined, 'titleKey': 'cardLostStolen', 'subtitleKey': 'cardLostStolenDesc'},
    {'icon': Icons.security_outlined, 'titleKey': 'unauthorizedCharge', 'subtitleKey': 'unauthorizedChargeDesc'},
    {'icon': Icons.help_outline, 'titleKey': 'other', 'subtitleKey': 'otherDesc'},
  ];

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    final loc = AppLocalizations.of(context)!;

    if (_selectedReasonIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.selectReason), backgroundColor: Colors.orange),
      );
      return;
    }

    if (_selectedReasonIndex == 3 && _otherController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.describeIssue), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.reportSubmitted), 
          backgroundColor: context.primaryColor,
        ),
      );
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDarkMode = context.isDarkMode;

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        title: Text(loc.report, style: TextStyle(color: context.textPrimary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.whatWouldYouLikeToReport, 
              style: TextStyle(
                color: context.textPrimary, 
                fontSize: 18, 
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: ListView.separated(
                itemCount: _reasons.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final reason = _reasons[index];
                  final isSelected = _selectedReasonIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedReasonIndex = index;
                        if (index != 3) _otherController.clear();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? context.primaryColor.withOpacity(0.1) 
                            : context.surfaceColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected 
                              ? context.primaryColor 
                              : context.textSecondary.withOpacity(0.1),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: context.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              reason['icon'], 
                              color: isSelected ? context.primaryColor : context.textSecondary, 
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getTitle(reason['titleKey'], loc), 
                                  style: TextStyle(
                                    color: isSelected ? context.primaryColor : context.textPrimary, 
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _getSubtitle(reason['subtitleKey'], loc), 
                                  style: TextStyle(
                                    color: context.textSecondary, 
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected) 
                            Icon(Icons.check_circle, color: context.primaryColor, size: 20),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            if (_selectedReasonIndex == 3) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _otherController,
                maxLines: 3,
                style: TextStyle(color: context.textPrimary),
                decoration: InputDecoration(
                  hintText: loc.describeIssueHint,
                  hintStyle: TextStyle(color: context.hintColor),
                  filled: true,
                  fillColor: context.progressBgColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), 
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), 
                    borderSide: BorderSide(color: context.primaryColor),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20, 
                        height: 20, 
                        child: CircularProgressIndicator(
                          color: Colors.white, 
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        loc.submitReport, 
                        style: const TextStyle(
                          fontSize: 16, 
                          fontWeight: FontWeight.bold, 
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String _getTitle(String key, AppLocalizations loc) {
    switch (key) {
      case 'suspiciousTransaction': return loc.suspiciousTransaction;
      case 'cardLostStolen': return loc.cardLostStolen;
      case 'unauthorizedCharge': return loc.unauthorizedCharge;
      case 'other': return loc.other;
      default: return '';
    }
  }

  String _getSubtitle(String key, AppLocalizations loc) {
    switch (key) {
      case 'suspiciousTransactionDesc': return loc.suspiciousTransactionDesc;
      case 'cardLostStolenDesc': return loc.cardLostStolenDesc;
      case 'unauthorizedChargeDesc': return loc.unauthorizedChargeDesc;
      case 'otherDesc': return loc.otherDesc;
      default: return '';
    }
  }
}
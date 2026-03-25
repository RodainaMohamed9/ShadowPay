import 'package:flutter/material.dart';
import 'package:shadow_pay_app/l10n/app_localizations.dart';

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
    {
      'icon': Icons.shopping_bag_outlined,
      'titleKey': 'suspiciousTransaction',
      'subtitleKey': 'suspiciousTransactionDesc',
    },
    {
      'icon': Icons.credit_card_off_outlined,
      'titleKey': 'cardLostStolen',
      'subtitleKey': 'cardLostStolenDesc',
    },
    {
      'icon': Icons.security_outlined,
      'titleKey': 'unauthorizedCharge',
      'subtitleKey': 'unauthorizedChargeDesc',
    },
    {
      'icon': Icons.help_outline,
      'titleKey': 'other',
      'subtitleKey': 'otherDesc',
    },
  ];

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (_selectedReasonIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.selectReason),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // لو اختار Other والمربع فاضي
    if (_selectedReasonIndex == 3 && _otherController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.describeIssue),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // محاكاة إرسال البلاغ
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => _isSubmitting = false);

      // رسالة نجاح
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.reportSubmitted),
          backgroundColor: const Color(0xFF00D8A2),
        ),
      );

      // الرجوع للـ Home بعد ثانية
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1F),
      appBar: AppBar(
        title: Text(loc.report),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // ✅ أسباب الإبلاغ
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
                        // لو مش Other، نمسح النص
                        if (index != 3) {
                          _otherController.clear();
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF00D8A2).withOpacity(0.1)
                            : const Color(0xFF1A1F2E),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF00D8A2)
                              : Colors.white.withOpacity(0.1),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFF00D8A2).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              reason['icon'],
                              color: isSelected
                                  ? const Color(0xFF00D8A2)
                                  : Colors.white70,
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
                                    color: isSelected
                                        ? const Color(0xFF00D8A2)
                                        : Colors.white,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _getSubtitle(reason['subtitleKey'], loc),
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle,
                              color: Color(0xFF00D8A2),
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // ✅ حقل إضافي لـ Other
            if (_selectedReasonIndex == 3) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _otherController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: loc.describeIssueHint,
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF1F2A44),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF00D8A2)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // ✅ زر Submit
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00D8A2),
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
      case 'suspiciousTransaction':
        return loc.suspiciousTransaction;
      case 'cardLostStolen':
        return loc.cardLostStolen;
      case 'unauthorizedCharge':
        return loc.unauthorizedCharge;
      case 'other':
        return loc.other;
      default:
        return '';
    }
  }

  String _getSubtitle(String key, AppLocalizations loc) {
    switch (key) {
      case 'suspiciousTransactionDesc':
        return loc.suspiciousTransactionDesc;
      case 'cardLostStolenDesc':
        return loc.cardLostStolenDesc;
      case 'unauthorizedChargeDesc':
        return loc.unauthorizedChargeDesc;
      case 'otherDesc':
        return loc.otherDesc;
      default:
        return '';
    }
  }
}
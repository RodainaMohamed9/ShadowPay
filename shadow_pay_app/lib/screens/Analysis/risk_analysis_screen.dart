import 'package:flutter/material.dart';
import 'package:shadow_pay_app/theme/colors.dart';
import 'package:shadow_pay_app/l10n/app_localizations.dart';

class RiskAnalysisScreen extends StatelessWidget {
  final VoidCallback? onBack;
  final double amount;
  final int hour;
  final String category;
  final int zipCode;
  final double riskScore;
  final String riskLevel;
  final bool isFraud;
  final String detectionMode;

  const RiskAnalysisScreen({
    super.key,
    this.onBack,
    this.amount = 0.0,
    this.hour = 0,
    this.category = "grocery_pos",
    this.zipCode = 0,
    this.riskScore = 0.0,
    this.riskLevel = "Low Risk",
    this.isFraud = false,
    this.detectionMode = "General",
  });

  Color _getRiskColor(BuildContext context) {
    if (riskScore > 70) return AppColors.error;
    if (riskScore > 30) return AppColors.warning;
    return AppColors.success;
  }

  void _navigateToHome(BuildContext context) {
    if (onBack != null) {
      onBack!();
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final primaryColor = isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary;
    final backgroundColor = isDarkMode ? AppColors.darkBackground : AppColors.lightBackground;
    final surfaceColor = isDarkMode ? AppColors.darkSurface : AppColors.lightSurface;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final textSecondaryColor = isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final riskColor = _getRiskColor(context);

    String translatedRiskLevel = riskLevel;
    if (riskLevel == "High Risk") {
      translatedRiskLevel = localizations.high_risk;
    } else if (riskLevel == "Medium Risk") {
      translatedRiskLevel = localizations.medium_risk;
    } else if (riskLevel == "Low Risk") {
      translatedRiskLevel = localizations.low_risk;
    }

    String fraudStatus = isFraud ? localizations.fraudulent : localizations.safe;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              (isDarkMode ? const Color(0xff1D293D) : Colors.grey.shade200).withOpacity(0.4),
            ),
            side: MaterialStateProperty.all(
              BorderSide(color: textSecondaryColor.withOpacity(0.5), width: 1),
            ),
          ),
          iconSize: 25,
          onPressed: () => _navigateToHome(context),
          icon: Transform.scale(
            scaleX: isRTL ? -1 : 1,
            child: Icon(Icons.arrow_back, color: textSecondaryColor),
          ),
        ),
        title: Text(
          localizations.risk_analysis_title,
          style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // ① Risk Score Circle
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: surfaceColor.withOpacity(0.85),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: riskColor.withOpacity(0.3), width: 1.5),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 25, spreadRadius: 5, offset: const Offset(0, 10)),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: 160,
                    height: 160,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 160,
                          height: 160,
                          child: CircularProgressIndicator(
                            value: riskScore / 100,
                            strokeWidth: 12,
                            backgroundColor: isDarkMode ? AppColors.darkProgressBg : AppColors.lightProgressBg,
                            valueColor: AlwaysStoppedAnimation<Color>(riskColor),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${riskScore.toStringAsFixed(1)}%",
                              style: TextStyle(color: textColor, fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              translatedRiskLevel,
                              style: TextStyle(color: riskColor, fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: riskColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: riskColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isFraud ? Icons.warning_amber_rounded : Icons.check_circle_outline,
                          color: riskColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          fraudStatus,
                          style: TextStyle(color: riskColor, fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ② Transaction Details
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: surfaceColor.withOpacity(0.85),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: primaryColor.withOpacity(0.2), width: 1.5),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, spreadRadius: 3, offset: const Offset(0, 8)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.receipt_long, color: primaryColor, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        localizations.transaction_details,
                        style: TextStyle(color: textSecondaryColor, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _detailRow(localizations.amount_label, "\$${amount.toStringAsFixed(2)}", textColor, textSecondaryColor),
                  _divider(isDarkMode),
                  _detailRow(localizations.hour_label, "${hour.toString().padLeft(2, '0')}:00", textColor, textSecondaryColor),
                  _divider(isDarkMode),
                  _detailRow(localizations.category_label, category.replaceAll('_', ' '), textColor, textSecondaryColor),
                  _divider(isDarkMode),
                  _detailRow(localizations.zip_code_label, zipCode.toString(), textColor, textSecondaryColor),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ③ Detection Mode
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: surfaceColor.withOpacity(0.85),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: primaryColor.withOpacity(0.2), width: 1.5),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, spreadRadius: 3, offset: const Offset(0, 8)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.analytics, color: primaryColor, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        localizations.detection_mode_label,
                        style: TextStyle(color: textSecondaryColor, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                detectionMode,
                                style: TextStyle(color: textColor, fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                localizations.detection_mode_description,
                                style: TextStyle(color: textSecondaryColor, fontSize: 12),
                                textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Back to Home Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 8,
                  shadowColor: primaryColor.withOpacity(0.5),
                ),
                onPressed: () => _navigateToHome(context),
                icon: const Icon(Icons.home_outlined, color: Colors.white),
                label: Text(
                  localizations.back_to_home,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value, Color textColor, Color textSecondaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: textSecondaryColor, fontSize: 14)),
          Text(value, style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _divider(bool isDarkMode) {
    return Divider(
      color: isDarkMode ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.06),
      height: 1,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shadow_pay_app/database/models/transaction_model.dart';
import 'package:shadow_pay_app/logic/transaction/cubit/transaction_cubit.dart';
import 'package:shadow_pay_app/logic/transaction/cubit/transaction_state.dart';
import 'package:shadow_pay_app/theme/colors.dart';
import 'package:shadow_pay_app/l10n/app_localizations.dart';

class AnalyticsScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const AnalyticsScreen({
    super.key,
    this.onBack,
  });

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {

  Color _getRiskColor(double averageRiskScore) {
    if (averageRiskScore > 70) return AppColors.error;
    if (averageRiskScore > 30) return AppColors.warning;
    return AppColors.success;
  }

bool _initialized = false;

@override
void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
        _initialized = true;
        context.read<TransactionCubit>().getTransactions();
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
          onPressed: () {
            if (widget.onBack != null) {
              widget.onBack!();
            } else {
              Navigator.pop(context);
            }
          },
          icon: Transform.scale(
            scaleX: isRTL ? -1 : 1,
            child: Icon(Icons.arrow_back, color: textSecondaryColor),
          ),
        ),
        title: Text(
          localizations.analytics_title,
          style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<TransactionCubit, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoadingState) {
            return Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          } else if (state is TransactionFailureState) {
            return Center(
              child: Text(state.errorMessage, style: TextStyle(color: textColor)),
            );
          } else if (state is TransactionSuccessState) {
            final transactions = state.transactions;
            final int totalTransactions = transactions.length;

            int safeTransactions = 0;
            int warnings = 0;
            int potentialFraud = 0;
            double totalAmount = 0.0;
            double totalRiskScore = 0.0;

            // خريطة لتجميع متوسط الخطر لكل ساعة لعمل الرسم البياني الخطي
            Map<double, List<double>> hourlyScores = {};

            for (var t in transactions) {
              totalAmount += t.amount;
              totalRiskScore += t.riskScore;

              if (t.riskLevel == "Low Risk") {
                safeTransactions++;
              } else if (t.riskLevel == "Medium Risk") {
                warnings++;
              } else if (t.riskLevel == "High Risk") {
                potentialFraud++;
              }

              // تجميع بيانات الرسم البياني
              double hour = t.transactionHour.toDouble();
              hourlyScores.putIfAbsent(hour, () => []).add(t.riskScore * 100);
            }

            double averageRiskScore = totalTransactions > 0
                ? (totalRiskScore / totalTransactions) * 100
                : 0.0;
            
            final riskColor = _getRiskColor(averageRiskScore);

            Map<String, double> categoryDistribution = {
              'safe': safeTransactions.toDouble(),
              'warning': warnings.toDouble(),
              'fraud': potentialFraud.toDouble(),
            };

            // حساب النقاط للرسم البياني الخطي
            List<FlSpot> riskTrendSpots = [];
            if (hourlyScores.isNotEmpty) {
              var sortedHours = hourlyScores.keys.toList()..sort();
              for (var hour in sortedHours) {
                var scores = hourlyScores[hour]!;
                double avg = scores.reduce((a, b) => a + b) / scores.length;
                riskTrendSpots.add(FlSpot(hour, avg));
              }
            } else {
              riskTrendSpots = const [FlSpot(0, 0)];
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          title: localizations.safe_transactions,
                          value: safeTransactions.toString(),
                          icon: Icons.shield_outlined,
                          color: const Color(0xFF4CAF50),
                          textColor: textColor,
                          textSecondaryColor: textSecondaryColor,
                          surfaceColor: surfaceColor,
                          isDarkMode: isDarkMode,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          title: localizations.total_transactions,
                          value: totalTransactions.toString(),
                          icon: Icons.attach_money,
                          color: const Color(0xFF2196F3),
                          textColor: textColor,
                          textSecondaryColor: textSecondaryColor,
                          surfaceColor: surfaceColor,
                          isDarkMode: isDarkMode,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          title: localizations.potential_fraud,
                          value: potentialFraud.toString(),
                          icon: Icons.warning_amber_rounded,
                          color: const Color(0xFFF44336),
                          textColor: textColor,
                          textSecondaryColor: textSecondaryColor,
                          surfaceColor: surfaceColor,
                          isDarkMode: isDarkMode,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          title: localizations.warnings_label,
                          value: warnings.toString(),
                          icon: Icons.notifications_active_outlined,
                          color: const Color(0xFFFF9800),
                          textColor: textColor,
                          textSecondaryColor: textSecondaryColor,
                          surfaceColor: surfaceColor,
                          isDarkMode: isDarkMode,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Average Risk Card
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
                              localizations.average_risk_title,
                              style: TextStyle(color: textSecondaryColor, fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${averageRiskScore.toStringAsFixed(1)}%",
                                    style: TextStyle(
                                      color: riskColor,
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: LinearProgressIndicator(
                                      minHeight: 8,
                                      value: totalTransactions > 0 ? averageRiskScore / 100 : 0.0,
                                      backgroundColor: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1),
                                      valueColor: AlwaysStoppedAnimation<Color>(riskColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  localizations.average_risk,
                                  style: TextStyle(color: textSecondaryColor, fontSize: 14),
                                ),
                                Text(
                                  localizations.risk_level,
                                  style: TextStyle(color: textSecondaryColor, fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Total Amount Card
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
                            Icon(Icons.account_balance_wallet, color: primaryColor, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              localizations.total_amount_label,
                              style: TextStyle(color: textSecondaryColor, fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "\$${totalAmount.toStringAsFixed(2)}",
                          style: TextStyle(
                            color: textColor,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Pie Chart Card
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
                            Icon(Icons.pie_chart_outline, color: primaryColor, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              localizations.transaction_distribution,
                              style: TextStyle(color: textSecondaryColor, fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 220,
                          child: PieChart(
                            PieChartData(
                              centerSpaceRadius: 60,
                              sectionsSpace: 4,
                              sections: [
                                PieChartSectionData(
                                  value: categoryDistribution['safe'] ?? 0,
                                  color: AppColors.success,
                                  radius: 50,
                                  showTitle: false,
                                ),
                                PieChartSectionData(
                                  value: categoryDistribution['warning'] ?? 0,
                                  color: AppColors.warning,
                                  radius: 50,
                                  showTitle: false,
                                ),
                                PieChartSectionData(
                                  value: categoryDistribution['fraud'] ?? 0,
                                  color: AppColors.error,
                                  radius: 50,
                                  showTitle: false,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 16,
                          runSpacing: 8,
                          alignment: isRTL ? WrapAlignment.end : WrapAlignment.start,
                          children: [
                            _buildLegendItem(AppColors.error, "${localizations.fraudulent} (${categoryDistribution['fraud']?.toInt() ?? 0})", textSecondaryColor),
                            _buildLegendItem(AppColors.warning, "${localizations.warnings_label} (${categoryDistribution['warning']?.toInt() ?? 0})", textSecondaryColor),
                            _buildLegendItem(AppColors.success, "${localizations.safe} (${categoryDistribution['safe']?.toInt() ?? 0})", textSecondaryColor),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Line Chart Card
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
                            Icon(Icons.trending_up, color: primaryColor, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              localizations.risk_trend,
                              style: TextStyle(color: textSecondaryColor, fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 250,
                          child: LineChart(
                            LineChartData(
                              gridData: const FlGridData(show: false),
                              borderData: FlBorderData(
                                show: true,
                                border: Border.all(
                                  color: textSecondaryColor.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 30,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        value.toInt().toString(),
                                        style: TextStyle(color: textSecondaryColor, fontSize: 10),
                                      );
                                    },
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 25,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        value.toInt().toString(),
                                        style: TextStyle(color: textSecondaryColor, fontSize: 10),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              lineBarsData: [
                                LineChartBarData(
                                  isCurved: true,
                                  color: riskColor,
                                  barWidth: 3,
                                  dotData: const FlDotData(show: true),
                                  spots: riskTrendSpots,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Color textColor,
    required Color textSecondaryColor,
    required Color surfaceColor,
    required bool isDarkMode,
  }) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(isDarkMode ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: color,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: textSecondaryColor, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(color: textColor, fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text, Color textSecondaryColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(color: textSecondaryColor, fontSize: 13),
        ),
      ],
    );
  }
}
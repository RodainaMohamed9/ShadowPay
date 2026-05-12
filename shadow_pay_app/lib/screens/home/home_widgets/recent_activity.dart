import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadow_pay_app/database/models/transaction_model.dart';
import 'package:shadow_pay_app/l10n/app_localizations.dart';
import 'package:shadow_pay_app/logic/transaction/cubit/transaction_cubit.dart';
import 'package:shadow_pay_app/logic/transaction/cubit/transaction_state.dart';
import 'package:shadow_pay_app/theme/colors.dart';
import 'package:shadow_pay_app/screens/TransactionScreens/transaction_list.dart';
import 'package:shadow_pay_app/core/enums/category.dart'; 

class RecentActivity extends StatefulWidget {
  final bool isDarkMode;

  const RecentActivity({
    super.key,
    required this.isDarkMode,
  });

  @override
  State<RecentActivity> createState() => _RecentActivityState();
}

class _RecentActivityState extends State<RecentActivity> {
  
  @override
  void initState() {
    super.initState();
    context.read<TransactionCubit>().getTransactions();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final primaryColor = widget.isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              loc.recentActivity,
              style: TextStyle(
                color: widget.isDarkMode ? Colors.white : Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TransactionList(),
                  ),
                );
              },
              child: Text(
                loc.viewAll,
                style: TextStyle(
                  color: primaryColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        BlocBuilder<TransactionCubit, TransactionState>(
          builder: (context, state) {
            if (state is TransactionLoadingState) {
              return Center(child: CircularProgressIndicator(color: primaryColor));
            } else if (state is TransactionFailureState) {
              return Center(child: Text(state.errorMessage, style: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black87)));
            } else if (state is TransactionSuccessState) {
              
              final recentTransactions = state.transactions.reversed.take(3).toList();

              if (recentTransactions.isEmpty) {
                return Center(
                  child: Text(
                    loc.noTransactionsYet,
                    style: TextStyle(color: widget.isDarkMode ? Colors.white54 : Colors.grey[600]),
                  ),
                );
              }

              return Column(
                children: recentTransactions
                    .map((transaction) => _buildActivityItem(transaction, loc))
                    .toList(),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildActivityItem(TransactionModel transaction, AppLocalizations loc) {
    final riskEnum = RiskLevel.fromString(transaction.riskLevel);
    final statusColor = riskEnum.color;
    final statusText = _getStatusTranslation(riskEnum, loc);

    final categoryIcon = transaction.merchantCategory.icon;
    final categoryName = transaction.merchantCategory.displayName(loc);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.isDarkMode ? const Color(0xFF1A1F2E) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (widget.isDarkMode ? Colors.white : Colors.black).withOpacity(0.05),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              categoryIcon,
              color: statusColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  categoryName,
                  style: TextStyle(
                    color: widget.isDarkMode ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Hour: ${transaction.transactionHour}:00",
                  style: TextStyle(
                    color: widget.isDarkMode ? Colors.white54 : Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "\$${transaction.amount.toStringAsFixed(2)}",
                style: TextStyle(
                  color: widget.isDarkMode ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getStatusTranslation(RiskLevel riskEnum, AppLocalizations loc) {
    switch (riskEnum) {
      case RiskLevel.lowRisk:
        return loc.safe;
      case RiskLevel.mediumRisk:
        return loc.warning;
      case RiskLevel.highRisk:
        return loc.fraud;
      default:
        return loc.unknown;
    }
  }
}
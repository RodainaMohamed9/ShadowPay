import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shadow_pay_app/core/enums/category.dart';
import 'package:shadow_pay_app/database/models/transaction_model.dart';
import 'package:shadow_pay_app/l10n/app_localizations.dart';
import 'package:shadow_pay_app/logic/transaction/cubit/transaction_cubit.dart';
import 'package:shadow_pay_app/logic/transaction/cubit/transaction_state.dart';
import 'package:shadow_pay_app/theme/colors.dart';
import 'package:shadow_pay_app/providers/theme_provider.dart';
import 'package:shadow_pay_app/screens/TransactionScreens/add_transaction_screen.dart';
import 'package:shadow_pay_app/screens/main_screen.dart';
import 'package:shadow_pay_app/screens/Analysis/risk_analysis_screen.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({super.key});

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  @override
  void initState() {
    super.initState();
    context.read<TransactionCubit>().getTransactions();
  }

  String _searchQuery = '';
  String _selectedFilter = 'All';

  Future<void> _openAddTransaction(
      BuildContext context, Color primaryColor) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTransactionScreen(
          onAnalyze: (transactionData) async {
            await context.read<TransactionCubit>().addTransaction(
                  amount: transactionData['amount'],
                  transactionHour: transactionData['hour'],
                  category: idToCategory(transactionData['category']),
                  zipCode: transactionData['zipCode'],
                );

            final state = context.read<TransactionCubit>().state;
            if (state is TransactionAddedSuccessState && context.mounted) {
              final t = state.transaction;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => RiskAnalysisScreen(
                    amount: t.amount,
                    hour: t.transactionHour,
                    category: categoryToId(t.merchantCategory),
                    zipCode: t.zipCode,
                    riskScore: t.riskScore,
                    riskLevel: t.riskLevel,
                    isFraud: t.isFraud,
                    detectionMode: "General",
                    onBack: () {
                      context.read<TransactionCubit>().getTransactions();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainScreen()),
                        (route) => false,
                      );
                    },
                  ),
                ),
              );
            } else if (context.mounted) {
              context.read<TransactionCubit>().getTransactions();
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    // FIX 3: Detect RTL for alignment fixes
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';

    final backgroundColor =
        isDarkMode ? const Color(0xFF0a1729) : const Color(0xFFF5F7FA);
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final textSecondaryColor = isDarkMode ? Colors.grey : Colors.grey[700];
    final primaryColor =
        isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary;

    return Directionality(
      // FIX 3: Wrap with Directionality so everything flips correctly in Arabic
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor,
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: BlocBuilder<TransactionCubit, TransactionState>(
                  builder: (context, state) {
                    if (state is TransactionLoadingState) {
                      return Center(
                        child: CircularProgressIndicator(color: primaryColor),
                      );
                    } else if (state is TransactionFailureState) {
                      return Center(
                        child: Text(state.errorMessage,
                            style: TextStyle(color: textColor)),
                      );
                    } else if (state is TransactionSuccessState) {
                      final allTransactions =
                          state.transactions.reversed.toList();

                      final filteredTransactions = allTransactions.where((t) {
                        if (_selectedFilter != 'All' &&
                            t.riskLevel != _selectedFilter) {
                          return false;
                        }
                        if (_searchQuery.isNotEmpty) {
                          final categoryName =
                              t.merchantCategory.name.toLowerCase();
                          if (!categoryName
                              .contains(_searchQuery.toLowerCase())) {
                            return false;
                          }
                        }
                        return true;
                      }).toList();

                      int safeCount = allTransactions
                          .where((t) => t.riskLevel == "Low Risk")
                          .length;
                      int warningCount = allTransactions
                          .where((t) => t.riskLevel == "Medium Risk")
                          .length;
                      int fraudCount = allTransactions
                          .where((t) => t.riskLevel == "High Risk")
                          .length;
                      double totalAmount =
                          allTransactions.fold(0.0, (sum, t) => sum + t.amount);

                      return Column(
                        // FIX 3: crossAxisAlignment يتغير حسب الاتجاه
                        crossAxisAlignment: isRTL
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              IconButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                    (isDarkMode
                                            ? const Color(0xff1D293D)
                                            : Colors.grey.shade200)
                                        .withOpacity(0.4),
                                  ),
                                  side: WidgetStateProperty.all(
                                    BorderSide(
                                      color:
                                          textSecondaryColor!.withOpacity(0.4),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                iconSize: 25,
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MainScreen()),
                                    (route) => false,
                                  );
                                },
                                // FIX 3: أيقونة السهم تتغير حسب الاتجاه
                                icon: Icon(
                                  isRTL
                                      ? Icons.arrow_forward
                                      : Icons.arrow_back,
                                  color: textSecondaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Padding(
                            padding: EdgeInsets.only(
                              left: isRTL ? 0 : 8,
                              right: isRTL ? 8 : 0,
                            ),
                            child: Align(
                              alignment: isRTL
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: isRTL
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    loc.allTransactions,
                                    style: TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${allTransactions.length} ${loc.numTransactions}",
                                    style: TextStyle(
                                        color: textSecondaryColor,
                                        fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(25),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                width: 2,
                                color: primaryColor.withOpacity(0.1),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.1),
                                  spreadRadius: 5,
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(loc.totalAmount,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(color: primaryColor)),
                                    Text(loc.transactions,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(color: primaryColor)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        "\$${totalAmount.toStringAsFixed(2)}",
                                        style: TextStyle(
                                            color: textColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25)),
                                    Text("${allTransactions.length}",
                                        style: TextStyle(
                                            color: textColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 4,
                                  children: [
                                    Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                              width: 10,
                                              height: 10,
                                              decoration: const BoxDecoration(
                                                  color: Color(0xff00BC7D),
                                                  shape: BoxShape.circle)),
                                          const SizedBox(width: 3),
                                          // FIX 1: "safe" label only, no count here redundant text
                                          Text("$safeCount ${loc.safe}",
                                              style: TextStyle(
                                                  color: textSecondaryColor)),
                                        ]),
                                    Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                              width: 10,
                                              height: 10,
                                              decoration: const BoxDecoration(
                                                  color: Color(0xffFE9A00),
                                                  shape: BoxShape.circle)),
                                          const SizedBox(width: 3),
                                          Text("$warningCount ${loc.warning}",
                                              style: TextStyle(
                                                  color: textSecondaryColor)),
                                        ]),
                                    Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                              width: 10,
                                              height: 10,
                                              decoration: const BoxDecoration(
                                                  color: Color(0xffFB2C36),
                                                  shape: BoxShape.circle)),
                                          const SizedBox(width: 3),
                                          Text("$fraudCount ${loc.fraud}",
                                              style: TextStyle(
                                                  color: textSecondaryColor)),
                                        ]),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                            textAlign: isRTL ? TextAlign.right : TextAlign.left,
                            keyboardType: TextInputType.text,
                            cursorColor: textSecondaryColor,
                            decoration: InputDecoration(
                              hintText: loc.searchHint,
                              hintStyle: TextStyle(
                                  color: textSecondaryColor.withOpacity(0.3)),
                              fillColor: (isDarkMode
                                      ? const Color(0xff1D293D)
                                      : Colors.grey.shade200)
                                  .withOpacity(0.3),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: textSecondaryColor.withOpacity(0.1),
                                    width: 1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: primaryColor.withOpacity(0.3),
                                    width: 1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _filterButton(
                                  label:
                                      "${loc.all} (${allTransactions.length})",
                                  filterKey: "All",
                                  primaryColor: primaryColor,
                                  isDarkMode: isDarkMode,
                                ),
                                const SizedBox(width: 15),
                                _filterButton(
                                  // FIX 1: safe filter button يعرض loc.safe بس
                                  label: "${loc.safe} ($safeCount)",
                                  filterKey: "Low Risk",
                                  primaryColor: primaryColor,
                                  isDarkMode: isDarkMode,
                                ),
                                const SizedBox(width: 15),
                                _filterButton(
                                  // FIX 2: warning بيجي من loc عشان يتترجم صح
                                  label: "${loc.warning} ($warningCount)",
                                  filterKey: "Medium Risk",
                                  primaryColor: primaryColor,
                                  isDarkMode: isDarkMode,
                                ),
                                const SizedBox(width: 15),
                                _filterButton(
                                  label: "${loc.fraud} ($fraudCount)",
                                  filterKey: "High Risk",
                                  primaryColor: primaryColor,
                                  isDarkMode: isDarkMode,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          Expanded(
                            child: filteredTransactions.isEmpty
                                ? _buildEmptyState(
                                    loc, primaryColor, isDarkMode, context)
                                : ListView.builder(
                                    itemCount: filteredTransactions.length,
                                    itemBuilder: (context, index) {
                                      return _buildTransactionDetails(
                                        filteredTransactions[index],
                                        loc,
                                        primaryColor,
                                        isDarkMode,
                                        isRTL,
                                      );
                                    },
                                  ),
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // FIX: extracted filter button widget to avoid repetition
  Widget _filterButton({
    required String label,
    required String filterKey,
    required Color primaryColor,
    required bool isDarkMode,
  }) {
    final isSelected = _selectedFilter == filterKey;
    return ElevatedButton(
      onPressed: () => setState(() => _selectedFilter = filterKey),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) => isSelected
              ? primaryColor.withOpacity(0.1)
              : (isDarkMode
                  ? const Color(0xff1D293D).withOpacity(0.3)
                  : Colors.grey.shade200),
        ),
        side: WidgetStateProperty.resolveWith<BorderSide>(
          (states) => BorderSide(
            color: isSelected
                ? primaryColor
                : (isDarkMode
                    ? const Color(0xff1D293D).withOpacity(0.7)
                    : Colors.grey.shade400),
            width: 2,
          ),
        ),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20))),
        minimumSize: WidgetStateProperty.all(const Size(80, 40)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected
              ? primaryColor
              : (isDarkMode ? Colors.grey.withOpacity(0.7) : Colors.grey[700]),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations loc, Color primaryColor,
      bool isDarkMode, BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_outlined,
                size: 80, color: Colors.grey.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              loc.noTransactionsYet,
              style: TextStyle(
                  color: Colors.grey.withOpacity(0.7),
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              loc.startAddingTransactions,
              style:
                  TextStyle(color: Colors.grey.withOpacity(0.5), fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _openAddTransaction(context, primaryColor),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add, size: 20),
                  const SizedBox(width: 8),
                  Text(loc.addTransaction,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionDetails(
    TransactionModel transaction,
    AppLocalizations loc,
    Color primaryColor,
    bool isDarkMode,
    bool isRTL, // FIX 3: pass isRTL
  ) {
    final riskEnum = RiskLevel.fromString(transaction.riskLevel);
    final statusColor = riskEnum.color;
    final categoryIcon = transaction.merchantCategory.icon;
    final categoryName = transaction.merchantCategory.displayName(loc);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDarkMode
            ? const Color(0xff1D293D).withOpacity(0.3)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          // FIX 3: reverse row in RTL so icon appears on the correct side
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(categoryIcon, color: statusColor),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: isRTL
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Row(
                    textDirection:
                        isRTL ? TextDirection.rtl : TextDirection.ltr,
                    children: [
                      Text("\$${transaction.amount.toStringAsFixed(2)}",
                          style: TextStyle(
                              color:
                                  isDarkMode ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Text("${transaction.riskScore.toStringAsFixed(1)}%",
                          style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                    ],
                  ),
                  Row(
                    textDirection:
                        isRTL ? TextDirection.rtl : TextDirection.ltr,
                    children: [
                      Text(categoryName,
                          style: TextStyle(
                              color: isDarkMode
                                  ? Colors.grey.withOpacity(0.7)
                                  : Colors.grey[600])),
                      const Spacer(),
                      // FIX 2: _getStatusTranslation بيستخدم loc فعلاً، بس التأكد إن loc.warning موجود في arb
                      Text(_getStatusTranslation(riskEnum, loc),
                          style: TextStyle(
                              color: isDarkMode
                                  ? Colors.grey.withOpacity(0.6)
                                  : Colors.grey[500],
                              fontSize: 12)),
                    ],
                  ),
                  Text("Hour: ${transaction.transactionHour}:00",
                      style: TextStyle(
                          color: isDarkMode
                              ? Colors.grey.withOpacity(0.6)
                              : Colors.grey[500],
                          fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // FIX 1: lowRisk returns loc.safe only (no "Low Risk" text)
  // FIX 2: mediumRisk returns loc.warning (translated from arb file)
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
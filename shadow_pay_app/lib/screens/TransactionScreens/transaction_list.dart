import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadow_pay_app/l10n/app_localizations.dart';
import 'package:shadow_pay_app/theme/colors.dart';
import 'package:shadow_pay_app/providers/theme_provider.dart';
import 'package:shadow_pay_app/screens/TransactionScreens/add_transaction_screen.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({super.key});

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  final List<Map<String, String>> transactions = [
    {"category": "food_dining", "status": "Safe"},
    {"category": "travel", "status": "Warning"},
    {"category": "health_fitness", "status": "Fraud"},
  ];

  final Map<String, IconData> categoryIcons = {
    "entertainment": Icons.movie,
    "food_dining": Icons.restaurant,
    "gas_transport": Icons.local_gas_station,
    "grocery_net": Icons.shopping_cart,
    "grocery_pos": Icons.shopping_cart,
    "health_fitness": Icons.fitness_center,
    "home": Icons.home,
    "kids_pets": Icons.pets,
    "misc_net": Icons.category,
    "misc_pos": Icons.category,
    "personal_care": Icons.spa,
    "shopping_net": Icons.shopping_bag,
    "shopping_pos": Icons.shopping_bag,
    "travel": Icons.flight,
  };

  final Map<String, int> statusColors = {
    "Safe": 0xFF00D8A2,
    "Warning": 0xFFFF9800,
    "Fraud": 0xFFF44336,
  };

  List<Map<String, String>> displayedTransactions = [];
  String selectedFilter = "All";

  @override
  void initState() {
    super.initState();
    displayedTransactions = List.from(transactions);
  }

  void filterSelection(String filter) {
    setState(() {
      selectedFilter = filter;
      if (filter == "All") {
        displayedTransactions = List.from(transactions);
      } else {
        displayedTransactions = transactions.where((t) => t['status'] == filter).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    
    final backgroundColor = isDarkMode ? const Color(0xFF0a1729) : const Color(0xFFF5F7FA);
    final surfaceColor = isDarkMode ? const Color(0xff1D293D).withOpacity(0.3) : Colors.grey.shade100;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final textSecondaryColor = isDarkMode ? Colors.grey : Colors.grey[700];
    final primaryColor = isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary;

    int safeCount = transactions.where((t) => t['status'] == "Safe").length;
    int warningCount = transactions.where((t) => t['status'] == "Warning").length;
    int fraudCount = transactions.where((t) => t['status'] == "Fraud").length;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                IconButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      (isDarkMode ? const Color(0xff1D293D) : Colors.grey.shade200).withOpacity(0.4),
                    ),
                    side: MaterialStateProperty.all(
                      BorderSide(
                        color: textSecondaryColor!.withOpacity(0.4),
                        width: 1,
                      ),
                    ),
                  ),
                  iconSize: 25,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back, color: textSecondaryColor),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      loc.allTransactions,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    Text(
                      "${transactions.length} ${loc.numTransactions}",
                      style: TextStyle(color: textSecondaryColor, fontSize: 15),
                    ),
                  ],
                ),
              ],
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(loc.totalAmount, textAlign: TextAlign.right, style: TextStyle(color: primaryColor)),
                      Text(loc.transactions, textAlign: TextAlign.right, style: TextStyle(color: primaryColor)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("\$3895.12", style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 25)),
                      Text("${transactions.length}", style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 25)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xff00BC7D), shape: BoxShape.circle)),
                      const SizedBox(width: 3),
                      Text("$safeCount ${loc.safe}", style: TextStyle(color: textSecondaryColor)),
                      const SizedBox(width: 10),
                      Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xffFE9A00), shape: BoxShape.circle)),
                      const SizedBox(width: 3),
                      Text("$warningCount ${loc.warning}", style: TextStyle(color: textSecondaryColor)),
                      const SizedBox(width: 10),
                      Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xffFB2C36), shape: BoxShape.circle)),
                      const SizedBox(width: 3),
                      Text("$fraudCount ${loc.fraud}", style: TextStyle(color: textSecondaryColor)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.text,
              cursorColor: textSecondaryColor,
              decoration: InputDecoration(
                hintText: loc.searchHint,
                hintStyle: TextStyle(color: textSecondaryColor.withOpacity(0.3)),
                fillColor: (isDarkMode ? const Color(0xff1D293D) : Colors.grey.shade200).withOpacity(0.3),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: textSecondaryColor.withOpacity(0.1), width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor.withOpacity(0.3), width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterButton(loc.all, "All", safeCount + warningCount + fraudCount, selectedFilter == "All", primaryColor, isDarkMode),
                  const SizedBox(width: 15),
                  _buildFilterButton(loc.safe, "Safe", safeCount, selectedFilter == "Safe", primaryColor, isDarkMode),
                  const SizedBox(width: 15),
                  _buildFilterButton(loc.warning, "Warning", warningCount, selectedFilter == "Warning", primaryColor, isDarkMode),
                  const SizedBox(width: 15),
                  _buildFilterButton(loc.fraud, "Fraud", fraudCount, selectedFilter == "Fraud", primaryColor, isDarkMode),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: displayedTransactions.isEmpty
                  ? _buildEmptyState(loc, primaryColor, isDarkMode)
                  : ListView.builder(
                      itemCount: displayedTransactions.length,
                      itemBuilder: (context, index) {
                        return _buildTransactionDetails(
                          displayedTransactions[index],
                          loc,
                          primaryColor,
                          isDarkMode,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String label, String filter, int count, bool isSelected, Color primaryColor, bool isDarkMode) {
    return ElevatedButton(
      onPressed: () => filterSelection(filter),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (states) => isSelected
              ? primaryColor.withOpacity(0.1)
              : (isDarkMode ? const Color(0xff1D293D).withOpacity(0.3) : Colors.grey.shade200),
        ),
        side: MaterialStateProperty.resolveWith<BorderSide>(
          (states) => BorderSide(
            color: isSelected ? primaryColor : (isDarkMode ? const Color(0xff1D293D).withOpacity(0.7) : Colors.grey.shade400),
            width: 2,
          ),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
      child: Text(
        "$label ($count)",
        style: TextStyle(
          color: isSelected ? primaryColor : (isDarkMode ? Colors.grey.withOpacity(0.7) : Colors.grey[700]),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations loc, Color primaryColor, bool isDarkMode) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_outlined, size: 80, color: Colors.grey.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              loc.noTransactionsYet,
              style: TextStyle(color: Colors.grey.withOpacity(0.7), fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              loc.startAddingTransactions,
              style: TextStyle(color: Colors.grey.withOpacity(0.5), fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddTransactionScreen()),
                );
                setState(() {});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add, size: 20),
                  const SizedBox(width: 8),
                  Text(loc.addTransaction, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionDetails(Map<String, dynamic> transaction, AppLocalizations loc, Color primaryColor, bool isDarkMode) {
    final statusColor = Color(statusColors[transaction['status']] ?? 0xFFAAAAAA);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xff1D293D).withOpacity(0.3) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                categoryIcons[transaction['category']] ?? Icons.help_outline,
                color: statusColor,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("\$125.50", style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Text("15${loc.percentage}", style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 15)),
                    ],
                  ),
                  Row(
                    children: [
                      Text(_getCategoryDisplayName(transaction['category'] ?? '', loc), style: TextStyle(color: isDarkMode ? Colors.grey.withOpacity(0.7) : Colors.grey[600])),
                      const Spacer(),
                      Text(_getStatusTranslation(transaction['status'] ?? '', loc), style: TextStyle(color: isDarkMode ? Colors.grey.withOpacity(0.6) : Colors.grey[500], fontSize: 12)),
                    ],
                  ),
                  Text(loc.dateTime, style: TextStyle(color: isDarkMode ? Colors.grey.withOpacity(0.6) : Colors.grey[500], fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryDisplayName(String key, AppLocalizations loc) {
    switch (key) {
      case "food_dining": return loc.restaurant;
      case "travel": return loc.flightTicket;
      case "health_fitness": return loc.gym;
      default: return key;
    }
  }

  String _getStatusTranslation(String status, AppLocalizations loc) {
    switch (status) {
      case "Safe": return loc.safe;
      case "Warning": return loc.warning;
      case "Fraud": return loc.fraud;
      default: return status;
    }
  }
}
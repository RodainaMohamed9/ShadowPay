import 'package:flutter/material.dart';
import 'package:shadow_pay_app/l10n/app_localizations.dart';
import 'package:shadow_pay_app/screens/TransactionScreens/add_transaction_screen.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({super.key});

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  final List<Map<String, String>> transactions = [
    // {
    //   "category": "food_dining",
    //   "status": "Safe",
    // },
    // {
    //   "category": "travel",
    //   "status": "Warning",
    // },
    // {
    //   "category": "health_fitness",
    //   "status": "Fraud",
    // },
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
        displayedTransactions =
            transactions.where((t) => t['status'] == filter).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    int safeCount = transactions.where((t) => t['status'] == "Safe").length;
    int warningCount =
        transactions.where((t) => t['status'] == "Warning").length;
    int fraudCount = transactions.where((t) => t['status'] == "Fraud").length;

    return Scaffold(
      backgroundColor: const Color(0xFF0a1729),
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
                      const Color(0xff1D293D).withOpacity(0.4),
                    ),
                    side: MaterialStateProperty.all(
                      BorderSide(
                        color: const Color(0xFF636262).withOpacity(0.4),
                        width: 1,
                      ),
                    ),
                  ),
                  iconSize: 25,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      loc.allTransactions,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    Text(
                      "${transactions.length} ${loc.numTransactions}",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
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
                  color: const Color(0xFF00D5BE).withOpacity(0.1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00D5BE).withOpacity(0.1),
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
                      Text(
                        loc.totalAmount,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: Color(0xFF00D5BE),
                        ),
                      ),
                      Text(
                        loc.transactions,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: Color(0xFF00D5BE),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "\$3895.12",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      Text(
                        "${transactions.length}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Color(0xff00BC7D),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        "$safeCount ${loc.safe}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Color(0xffFE9A00),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        "$warningCount ${loc.warning}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Color(0xffFB2C36),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        "$fraudCount ${loc.fraud}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.text,
              cursorColor: Colors.grey,
              decoration: InputDecoration(
                hintText: loc.searchHint,
                hintStyle: TextStyle(color: Colors.grey.withOpacity(0.3)),
                fillColor: const Color(0xff1D293D).withOpacity(0.3),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.withOpacity(0.1),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: const Color(0xFF00D5BE).withOpacity(0.3),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // All
                  ElevatedButton(
                    onPressed: () => filterSelection("All"),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (states) => selectedFilter == "All"
                            ? const Color(0xFF00D5BE).withOpacity(0.1)
                            : const Color(0xff1D293D).withOpacity(0.3),
                      ),
                      side: MaterialStateProperty.resolveWith<BorderSide>(
                        (states) => BorderSide(
                          color: selectedFilter == "All"
                              ? const Color(0xFF00D5BE)
                              : const Color(0xff1D293D).withOpacity(0.7),
                          width: 2,
                        ),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    child: Text(
                      "${loc.all} (${transactions.length})",
                      style: TextStyle(
                        color: selectedFilter == "All"
                            ? const Color(0xFF00D5BE)
                            : Colors.grey.withOpacity(0.7),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Safe
                  ElevatedButton(
                    onPressed: () => filterSelection("Safe"),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (states) => selectedFilter == "Safe"
                            ? const Color(0xFF00D5BE).withOpacity(0.1)
                            : const Color(0xff1D293D).withOpacity(0.3),
                      ),
                      side: MaterialStateProperty.resolveWith<BorderSide>(
                        (states) => BorderSide(
                          color: selectedFilter == "Safe"
                              ? const Color(0xFF00D5BE)
                              : const Color(0xff1D293D).withOpacity(0.7),
                          width: 2,
                        ),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    child: Text(
                      "${loc.safe} ($safeCount)",
                      style: TextStyle(
                        color: selectedFilter == "Safe"
                            ? const Color(0xFF00D5BE)
                            : Colors.grey.withOpacity(0.7),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Warning
                  ElevatedButton(
                    onPressed: () => filterSelection("Warning"),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (states) => selectedFilter == "Warning"
                            ? const Color(0xFF00D5BE).withOpacity(0.1)
                            : const Color(0xff1D293D).withOpacity(0.3),
                      ),
                      side: MaterialStateProperty.resolveWith<BorderSide>(
                        (states) => BorderSide(
                          color: selectedFilter == "Warning"
                              ? const Color(0xFF00D5BE)
                              : const Color(0xff1D293D).withOpacity(0.7),
                          width: 2,
                        ),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    child: Text(
                      "${loc.warning} ($warningCount)",
                      style: TextStyle(
                        color: selectedFilter == "Warning"
                            ? const Color(0xFF00D5BE)
                            : Colors.grey.withOpacity(0.7),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Fraud
                  ElevatedButton(
                    onPressed: () => filterSelection("Fraud"),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (states) => selectedFilter == "Fraud"
                            ? const Color(0xFF00D5BE).withOpacity(0.1)
                            : const Color(0xff1D293D).withOpacity(0.3),
                      ),
                      side: MaterialStateProperty.resolveWith<BorderSide>(
                        (states) => BorderSide(
                          color: selectedFilter == "Fraud"
                              ? const Color(0xFF00D5BE)
                              : const Color(0xff1D293D).withOpacity(0.7),
                          width: 2,
                        ),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    child: Text(
                      "${loc.fraud} ($fraudCount)",
                      style: TextStyle(
                        color: selectedFilter == "Fraud"
                            ? const Color(0xFF00D5BE)
                            : Colors.grey.withOpacity(0.7),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: displayedTransactions.isEmpty
              ? _buildEmptyState(loc)  
                : ListView.builder(
                itemCount: displayedTransactions.length,
                itemBuilder: (context, index) {
                  return _buildTransactionDetails(
                    displayedTransactions[index],
                    loc,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildEmptyState(AppLocalizations loc) {
  return Center(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_outlined,
            size: 80,
            color: Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          
          Text(
            loc.noTransactionsYet, 
            style: TextStyle(
              color: Colors.grey.withOpacity(0.7),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            loc.startAddingTransactions, 
            style: TextStyle(
              color: Colors.grey.withOpacity(0.5),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 24),
          
          ElevatedButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddTransactionScreen(),
                ),
              );
              
              if (result == true) {
                setState(() {
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff1D293D),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add, size: 20),
                const SizedBox(width: 8),
                Text(
                  loc.addTransaction,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildTransactionDetails(
    Map<String, dynamic> transaction,
    AppLocalizations loc,
  ) {
      return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xff1D293D).withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(
            statusColors[transaction['status']] ?? 0xFFAAAAAA,
          ).withOpacity(0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Color(
                  statusColors[transaction['status']] ?? 0xFFAAAAAA,
                ).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                categoryIcons[transaction['category']] ?? Icons.help_outline,
                color: Color(
                  statusColors[transaction['status']] ?? 0xFFAAAAAA,
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "\$125.50",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "15${loc.percentage}",
                        style: TextStyle(
                          color: Color(
                            statusColors[transaction['status']] ?? 0xFFAAAAAA,
                          ),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        _getCategoryDisplayName(
                          transaction['category'] ?? '',
                          loc,
                        ),
                        style: TextStyle(
                          color: Colors.grey.withOpacity(0.7),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _getStatusTranslation(
                          transaction['status'] ?? '',
                          loc,
                        ),
                        style: TextStyle(
                          color: Colors.grey.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    loc.dateTime,
                    style: TextStyle(
                      color: Colors.grey.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
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
      case "food_dining":
        return loc.restaurant;
      case "travel":
        return loc.flightTicket;
      case "health_fitness":
        return loc.gym;
      default:
        return key;
    }
  }

  String _getStatusTranslation(String status, AppLocalizations loc) {
    switch (status) {
      case "Safe":
        return loc.safe;
      case "Warning":
        return loc.warning;
      case "Fraud":
        return loc.fraud;
      default:
        return status;
    }
  }
}

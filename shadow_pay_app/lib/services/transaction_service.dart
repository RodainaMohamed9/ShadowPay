import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import 'package:http/http.dart' as http;
import 'package:shadow_pay_app/core/enums/category.dart' as my_enum;
import 'package:shadow_pay_app/services/auth_service.dart';

class TransactionService {
  static const String baseUrl =
      'https://jackeline-cibarious-supergallantly.ngrok-free.dev';

  //=========== Add Transaction =============
  static Future<bool> sendTransaction({
    required BuildContext context,
    required Decimal amount,
    required int transactionHour,
    required my_enum.Category category,
    required int zipCode,
  }) async {
    final url = Uri.parse("$baseUrl/api/Transaction/add-transaction");

    try {
      final token = await ApiService.getToken();
      if (token == null) {
        _showErrorDialog(context, ["User not logged in"]);
        return false;
      }

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "amount": amount.toString(),
          "transactionHour": transactionHour,
          "merchantCategory": my_enum.categoryToId(category),
          "zipCode": zipCode
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      dynamic data;
      try {
        data = jsonDecode(response.body);
      } catch (e) {
        print('Failed to parse JSON: $e');
        if (context.mounted) {
          _showErrorDialog(context, ["Server error. Please try again."]);
        }
        return false;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      List<String> errors = [];
      if (data != null) {
        if (data['errors'] != null) {
          errors = List<String>.from(data['errors'] ?? []);
        } else if (data['message'] != null) {
          errors.add(data['message']);
        }
      }

      if (errors.isEmpty) errors.add("Transaction failed. Please try again.");
      if (context.mounted) _showErrorDialog(context, errors);

      return false;
    } catch (e) {
      print("Network error: $e");
      if (context.mounted) {
        _showErrorDialog(context, ["Network error. Please check your connection."]);
      }
      return false;
    }
  }

  static void _showErrorDialog(BuildContext context, List<String> errors) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Error", style: TextStyle(color: Colors.red)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: errors.map((error) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text("• $error"),
          )).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK", style: TextStyle(color: Colors.teal)),
          ),
        ],
      ),
    );
  }

  //============ Transaction List ==========
  static Future<List<Map<String, dynamic>>> getTransactions() async {
  final url = Uri.parse("$baseUrl/api/Transaction/transaction-list"); 
  try {
    final token = await ApiService.getToken();
    if (token == null) return [];

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['transactions'] ?? data);
    } else {
      print('Failed to fetch transactions: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print("Error fetching transactions: $e");
    return [];
  }
}
}
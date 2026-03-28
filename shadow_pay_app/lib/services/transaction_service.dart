import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import 'package:http/http.dart' as http;

class TransactionService {
    static const String baseUrl = 'https://jackeline-cibarious-supergallantly.ngrok-free.dev';

    static Future<bool> AddTransaction({
      required BuildContext context,
      required Decimal amount,
      required int transactionHour,
      
    });


}
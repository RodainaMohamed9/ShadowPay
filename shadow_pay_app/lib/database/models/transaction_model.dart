import 'package:shadow_pay_app/core/enums/category.dart';

class TransactionModel {
  int id;
  double amount;
  Category merchantCategory;
  int zipCode;
  int transactionHour;
  double riskScore;
  bool isFraud;
  String riskLevel;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.merchantCategory,
    required this.zipCode,
    required this.transactionHour,
    required this.riskScore,
    required this.isFraud,
    required this.riskLevel,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? 0,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0, 
      
      merchantCategory: idToCategory(json['merchantCategory'] ?? 0),
      
      zipCode: json['zipCode'] ?? 0,
      transactionHour: json['transactionHour'] ?? 0,
      riskScore: (json['riskScore'] as num?)?.toDouble() ?? 0.0,
      isFraud: json['isFraud'] ?? false,
      riskLevel: json['riskLevel'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        
        "merchantCategory": categoryToId(merchantCategory),
        
        "zipCode": zipCode,
        "transactionHour": transactionHour,
        "riskScore": riskScore,
        "isFraud": isFraud,
        "riskLevel": riskLevel,
      };
}
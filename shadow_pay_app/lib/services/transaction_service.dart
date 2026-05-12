import 'package:shadow_pay_app/core/enums/category.dart';
import 'package:shadow_pay_app/database/models/transaction_model.dart';
import 'package:shadow_pay_app/services/tokens/api_service.dart';

class TransactionService {
  static Future<List<TransactionModel>?> getTransactionList() async{
    try{
      final dioClient = DioClient();
      final response = await dioClient.dio.get('/Transaction/transaction-list');

      if(response.statusCode == 200){
        List<dynamic> data = response.data;
        return data.map((json) => TransactionModel.fromJson(json)).toList();
      }
      else{
        return null;
      }
    }
    catch(e){
        print("Error fetching profile: $e");
        return null;
      }
  }

  static Future<TransactionModel?> addTransaction({
    required double amount,
    required int transactionHour,
    required Category category,
    required int zipCode,
  }) async{
    try{
      final dioClient = DioClient();
      final response = await dioClient.dio.post('/Transaction/add-transaction',
        data: {
          "amount": amount.toString(),
          "transactionHour": transactionHour,
          "merchantCategory": categoryToId(category), 
          "zipCode": zipCode
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TransactionModel.fromJson(response.data);      
        }
      else{
        return null;
      }
    }
    catch(e){
        print("Error adding transaction: $e");
        return null;
      }
  }
}
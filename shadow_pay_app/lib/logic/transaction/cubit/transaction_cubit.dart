import 'package:bloc/bloc.dart';
import 'package:shadow_pay_app/core/enums/category.dart';
import 'package:shadow_pay_app/database/models/transaction_model.dart';
import 'package:shadow_pay_app/logic/transaction/cubit/transaction_state.dart';
import 'package:shadow_pay_app/services/transaction_service.dart';


class TransactionCubit extends Cubit<TransactionState> {
  TransactionCubit() : super(TransactionInitial());

  Future<void> getTransactions() async{
    emit(TransactionLoadingState());
    try{
      final List<TransactionModel>? transactions = await TransactionService.getTransactionList();
      if(transactions != null){
        emit(TransactionSuccessState(transactions: transactions));
      }
      else{
        emit(TransactionFailureState(errorMessage: "Failed to fetch transactions"));
      }

    }catch(e){
      emit(TransactionFailureState(errorMessage: e.toString()));
    }
  }

  Future<void> addTransaction({
    required double amount,
    required int transactionHour,
    required Category category,
    required int zipCode,
  }) async {
    emit(TransactionLoadingState()); 
    try {
      final result = await TransactionService.addTransaction(
        amount: amount,
        transactionHour: transactionHour,
        category: category,
        zipCode: zipCode,
      );
      
      if (result != null) {
        emit(TransactionAddedSuccessState(transaction: result));
        
      } else {
        emit(TransactionFailureState(errorMessage: "Failed to add transaction"));
      }
    } catch (e) {
      emit(TransactionFailureState(errorMessage: e.toString()));
    }
  }
}

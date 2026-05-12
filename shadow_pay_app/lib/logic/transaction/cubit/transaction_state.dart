import 'package:shadow_pay_app/database/models/transaction_model.dart';

abstract class TransactionState {}

final class TransactionInitial extends TransactionState {}

final class TransactionLoadingState extends TransactionState {}
final class TransactionSuccessState extends TransactionState {
  final List<TransactionModel> transactions;
  TransactionSuccessState({required this.transactions});
}
final class TransactionFailureState extends TransactionState {
  final String errorMessage;
  TransactionFailureState({required this.errorMessage});
}
final class TransactionAddedSuccessState extends TransactionState {
  final TransactionModel transaction;
  TransactionAddedSuccessState({required this.transaction});
}
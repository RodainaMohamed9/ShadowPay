import 'package:shadow_pay_app/database/models/profile_model.dart';

abstract class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoadingState extends ProfileState {}

final class ProfileSuccessState extends ProfileState {
  final ProfileModel? profile;

  ProfileSuccessState({required this.profile});
}

final class ProfileFailureState extends ProfileState {
  final String errorMessage;

  ProfileFailureState({required this.errorMessage});
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadow_pay_app/logic/profile/cubit/profile_state.dart';
import 'package:shadow_pay_app/services/profile_service.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  Future<void> getProfile() async {
    emit(ProfileLoadingState());
    try {
      final profile = await ProfileService.getUserProfile();
      if (profile != null) {
      emit(ProfileSuccessState(profile: profile));
    } 
    else {
      emit(ProfileFailureState(errorMessage:"User profile data not found"));
    }
    } catch (e) {
      emit(ProfileFailureState(errorMessage: e.toString()));
    }
  }

  Future<bool> toggleFreezeStatus() async {
    try {
      final success = await ProfileService.toggleCardFreezeStatus();
      if (success) {
        await getProfile();
      }
      return success;
    } catch (e) {
      return false;
    }
  }
}

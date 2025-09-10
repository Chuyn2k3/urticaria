import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:urticaria/utils/shared_preferences_manager.dart';

import '../../core/global_error_handle/global_error_handle.dart';
import '../../core/repositories/user_repository.dart';
import '../../di/locator.dart';
import '../../feature/profile/model/user_info_model.dart';

part 'profile_state.dart';

var userId = 1;

class ProfileUserCubit extends Cubit<ProfileUserState> {
  ProfileUserCubit() : super(ProfileUserInitialState());
  final UserRepository _userRepository = serviceLocator();

  Future<void> getProfile() async {
    try {
      emit(ProfileUserLoadingState());
      final result = await _userRepository.getProfile();
      final data = result.data;
      userId = data?.id ?? 1;
      if (data != null) {
        final sfm = await GetIt.instance<SharedPreferencesManager>();
        print(data.id);
        sfm.putInt("user_id", data.id);
        emit(ProfileUserLoadedState(user: data));
      } else {
        emit(ProfileUserErrorState(error: "Không lấy được dữ liệu cá nhân"));
      }
    } catch (e) {
      final message = GlobalErrorHandle(e).errorMessage();
      emit(ProfileUserErrorState(error: message));
    }
  }

  Future<void> refreshProfile() async {
    try {
      emit(ProfileUserInitialState());
      final result = await _userRepository.getProfile();
      final data = result.data;
      if (data != null) {
        emit(ProfileUserLoadedState(user: data));
      } else {
        emit(ProfileUserErrorState(error: "Không lấy được dữ liệu cá nhân"));
      }
    } catch (e) {
      final message = GlobalErrorHandle(e).errorMessage();
      emit(ProfileUserErrorState(error: message));
    }
  }

  UserInfoModel? inforUser() {
    if (state is ProfileUserLoadedState) {
      return (state as ProfileUserLoadedState).user;
    }
    return null;
  }
}

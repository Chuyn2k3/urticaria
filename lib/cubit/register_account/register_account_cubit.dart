import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:urticaria/core/global_error_handle/global_error_handle.dart';
import 'package:urticaria/core/repositories/user_repository.dart';
import 'package:urticaria/models/register_request.dart';

part 'register_account_state.dart';

GetIt _sl = GetIt.instance;

class RegisterAccountCubit extends Cubit<RegisterAccountState> {
  RegisterAccountCubit() : super(RegisterAccountInitialState());
  final UserRepository _userRepository = _sl();

  void registerAccount(RegisterRequest registerRequest) async {
    try {
      emit(RegisterAccountLoadingState());
      final result = await _userRepository.registerAccount(registerRequest);

      emit(RegisterAccountSuccessState(phone: registerRequest.phone));
    } catch (e) {
      final errorKey = GlobalErrorHandle(e).errorKey;
      emit(RegisterAccountErrorState(error: errorKey));
    }
  }
}

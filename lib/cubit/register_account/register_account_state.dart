part of 'register_account_cubit.dart';

abstract class RegisterAccountState extends Equatable {
  const RegisterAccountState();
}

class RegisterAccountInitialState extends RegisterAccountState {
  @override
  List<Object> get props => [];
}

class RegisterAccountLoadingState extends RegisterAccountState {
  @override
  List<Object> get props => [];
}

class RegisterAccountSuccessState extends RegisterAccountState {
  final String phone;
  const RegisterAccountSuccessState({required this.phone});
  @override
  List<Object> get props => [phone];
}

class RegisterAccountErrorState extends RegisterAccountState {
  final String error;
  const RegisterAccountErrorState({required this.error});

  @override
  List<Object> get props => [error];
}

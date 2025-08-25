part of 'internet_cubit.dart';

abstract class InternetState extends Equatable {
  const InternetState();
}

class InternetInitialState extends InternetState {
  @override
  List<Object> get props => [];
}

class ConnectedState extends InternetState {
  @override
  List<Object> get props => [];
}

class NotConnectedState extends InternetState {
  @override
  List<Object> get props => [];
}

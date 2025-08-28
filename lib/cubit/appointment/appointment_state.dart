part of 'appointment_cubit.dart';

abstract class AppointmentState {}

class AppointmentInitial extends AppointmentState {}

class AppointmentLoading extends AppointmentState {}

class AppointmentSuccess extends AppointmentState {
  final AppointmentResponse appointment;
  AppointmentSuccess(this.appointment);
}

class AppointmentFailure extends AppointmentState {
  final String error;
  AppointmentFailure(this.error);
}

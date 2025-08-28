import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urticaria/core/repositories/appointment_repository.dart';
import 'package:urticaria/models/appointment/appointment_request.dart';
import 'package:urticaria/models/appointment/appointment_response.dart';

part 'appointment_state.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  final AppointmentRepository repository;

  AppointmentCubit(this.repository) : super(AppointmentInitial());

  Future<void> createAppointment(AppointmentRequest request) async {
    try {
      emit(AppointmentLoading());
      final result = await repository.createAppointment(request);
      emit(AppointmentSuccess(result.data!));
    } catch (e) {
      emit(AppointmentFailure(e.toString()));
    }
  }
}

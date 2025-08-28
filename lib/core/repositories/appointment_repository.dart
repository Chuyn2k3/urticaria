import 'package:urticaria/core/base/base_response.dart';
import 'package:urticaria/models/appointment/appointment_request.dart';
import 'package:urticaria/models/appointment/appointment_response.dart';

import '../services/appointment_service.dart';

abstract class AppointmentRepository {
  Future<BaseResponse<AppointmentResponse>> createAppointment(
      AppointmentRequest request);
}

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentService service;

  const AppointmentRepositoryImpl({required this.service});

  @override
  Future<BaseResponse<AppointmentResponse>> createAppointment(
      AppointmentRequest request) async {
    try {
      final result = await service.createAppointment(request);
      return result;
    } catch (e) {
      rethrow;
    }
  }
}

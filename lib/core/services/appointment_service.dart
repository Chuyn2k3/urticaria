import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:urticaria/core/base/base_response.dart';
import 'package:urticaria/models/appointment/appointment_request.dart';
import 'package:urticaria/models/appointment/appointment_response.dart';

part 'appointment_service.g.dart';

@RestApi()
abstract class AppointmentService {
  factory AppointmentService(Dio dio, {String baseUrl}) = _AppointmentService;

  @POST("/api/v1/patient/appointments")
  Future<BaseResponse<AppointmentResponse>> createAppointment(
    @Body() AppointmentRequest request,
  );
}

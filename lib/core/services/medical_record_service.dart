import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:urticaria/core/base/base_response.dart';
import 'package:urticaria/models/medical_record_template/medical_record_request.dart';

import 'package:urticaria/models/medical_record_template/medical_record_template_model.dart';
import 'package:urticaria/models/vital_group/vital_group.dart';
import 'package:urticaria/models/vital_indicator/vital_indicator_model.dart';

part 'medical_record_service.g.dart';

@RestApi()
abstract class MedicalRecordService {
  factory MedicalRecordService(Dio dio, {String baseUrl}) =
      _MedicalRecordService;

  @GET("/api/v1/patient/medical-record-templates/{id}")
  Future<BaseResponse<MedicalRecordTemplate>> getTemplate(@Path("id") int id);

  @GET("/api/v1/vitals/groups/{id}")
  Future<BaseResponse<VitalGroup>> getVitalGroup(@Path("id") int id);
  @POST("/api/v1/patient/medical-records")
  Future<BaseResponse<dynamic>> createMedicalRecord(
    @Body() MedicalRecordRequest request,
  );
}

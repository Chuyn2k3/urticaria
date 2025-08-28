import 'package:urticaria/core/base/base_response.dart';
import 'package:urticaria/core/services/medical_record_service.dart';
import 'package:urticaria/models/medical_record_template/medical_record_request.dart';
import 'package:urticaria/models/medical_record_template/medical_record_template_model.dart';
import 'package:urticaria/models/vital_group/vital_group.dart';
import 'package:urticaria/models/vital_indicator/vital_indicator_model.dart';

abstract class MedicalRecordRepository {
  Future<BaseResponse<MedicalRecordTemplate>> getTemplate(int id);
  Future<BaseResponse<VitalGroup>> getVitalGroup(int id);
  Future<BaseResponse<dynamic>> createMedicalRecord(
      MedicalRecordRequest request);
}

class MedicalRecordRepositoryImpl implements MedicalRecordRepository {
  final MedicalRecordService service;
  const MedicalRecordRepositoryImpl({required this.service});

  @override
  Future<BaseResponse<MedicalRecordTemplate>> getTemplate(int id) async {
    return await service.getTemplate(id);
  }

  @override
  Future<BaseResponse<VitalGroup>> getVitalGroup(int id) async {
    return await service.getVitalGroup(id);
  }

  @override
  Future<BaseResponse<dynamic>> createMedicalRecord(
      MedicalRecordRequest request) {
    return service.createMedicalRecord(request);
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_record_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicalRecordRequest _$MedicalRecordRequestFromJson(
        Map<String, dynamic> json) =>
    MedicalRecordRequest(
      templateId: (json['templateId'] as num).toInt(),
      appointmentId: (json['appointmentId'] as num).toInt(),
      vitalValues: (json['vitalValues'] as List<dynamic>)
          .map((e) => VitalValueRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MedicalRecordRequestToJson(
        MedicalRecordRequest instance) =>
    <String, dynamic>{
      'templateId': instance.templateId,
      'appointmentId': instance.appointmentId,
      'vitalValues': instance.vitalValues.map((e) => e.toJson()).toList(),
    };

VitalValueRequest _$VitalValueRequestFromJson(Map<String, dynamic> json) =>
    VitalValueRequest(
      vitalIndicatorId: (json['vitalIndicatorId'] as num).toInt(),
      groupId: (json['groupId'] as num).toInt(),
      value: json['value'],
      note: json['note'] as String?,
    );

Map<String, dynamic> _$VitalValueRequestToJson(VitalValueRequest instance) =>
    <String, dynamic>{
      'vitalIndicatorId': instance.vitalIndicatorId,
      'groupId': instance.groupId,
      'value': instance.value,
      'note': instance.note,
    };

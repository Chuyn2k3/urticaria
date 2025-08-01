// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HealthRecord _$HealthRecordFromJson(Map<String, dynamic> json) => HealthRecord(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      recordType: json['recordType'] as String,
      createdDate: DateTime.parse(json['createdDate'] as String),
      updatedDate: json['updatedDate'] == null
          ? null
          : DateTime.parse(json['updatedDate'] as String),
      status: json['status'] as String,
      symptoms: json['symptoms'] as String,
      diagnosis: json['diagnosis'] as String,
      treatment: json['treatment'] as String,
      doctorName: json['doctorName'] as String,
      doctorId: json['doctorId'] as String,
      notes: json['notes'] as String,
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      additionalData: json['additionalData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$HealthRecordToJson(HealthRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'patientId': instance.patientId,
      'recordType': instance.recordType,
      'createdDate': instance.createdDate.toIso8601String(),
      'updatedDate': instance.updatedDate?.toIso8601String(),
      'status': instance.status,
      'symptoms': instance.symptoms,
      'diagnosis': instance.diagnosis,
      'treatment': instance.treatment,
      'doctorName': instance.doctorName,
      'doctorId': instance.doctorId,
      'notes': instance.notes,
      'imageUrls': instance.imageUrls,
      'additionalData': instance.additionalData,
    };

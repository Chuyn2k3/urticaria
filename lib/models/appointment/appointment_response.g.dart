// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentResponse _$AppointmentResponseFromJson(Map<String, dynamic> json) =>
    AppointmentResponse(
      id: (json['id'] as num).toInt(),
      reason: json['reason'] as String,
      appointmentDate: json['appointmentDate'] as String,
      status: json['status'] as String,
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      patient: json['patient'],
      doctor: json['doctor'],
    );

Map<String, dynamic> _$AppointmentResponseToJson(
        AppointmentResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reason': instance.reason,
      'appointmentDate': instance.appointmentDate,
      'status': instance.status,
      'notes': instance.notes,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'patient': instance.patient,
      'doctor': instance.doctor,
    };

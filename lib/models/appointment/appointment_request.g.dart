// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentRequest _$AppointmentRequestFromJson(Map<String, dynamic> json) =>
    AppointmentRequest(
      reason: json['reason'] as String,
      appointmentDate: json['appointmentDate'] as String,
      status: json['status'] as String,
      notes: json['notes'] as String?,
      fullName: json['fullName'] as String,
      phone: json['phone'] as String,
      customInfo: json['customInfo'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$AppointmentRequestToJson(AppointmentRequest instance) =>
    <String, dynamic>{
      'reason': instance.reason,
      'appointmentDate': instance.appointmentDate,
      'status': instance.status,
      'notes': instance.notes,
      'fullName': instance.fullName,
      'phone': instance.phone,
      'customInfo': instance.customInfo,
    };

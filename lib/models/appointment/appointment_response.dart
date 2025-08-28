import 'package:json_annotation/json_annotation.dart';

part 'appointment_response.g.dart';

@JsonSerializable()
class AppointmentResponse {
  final int id;
  final String reason;
  final String appointmentDate;
  final String status;
  final String? notes;
  final String createdAt;
  final String updatedAt;
  final dynamic patient;
  final dynamic doctor;

  AppointmentResponse({
    required this.id,
    required this.reason,
    required this.appointmentDate,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.patient,
    this.doctor,
  });

  factory AppointmentResponse.fromJson(Map<String, dynamic> json) =>
      _$AppointmentResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AppointmentResponseToJson(this);
}

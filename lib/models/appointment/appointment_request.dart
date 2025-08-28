import 'package:json_annotation/json_annotation.dart';

part 'appointment_request.g.dart';

@JsonSerializable()
class AppointmentRequest {
  final String reason;
  final String appointmentDate;
  final String status;
  final String? notes;
  final String fullName;
  final String phone;
  final Map<String, dynamic>? customInfo;

  AppointmentRequest({
    required this.reason,
    required this.appointmentDate,
    required this.status,
    this.notes,
    required this.fullName,
    required this.phone,
    this.customInfo,
  });

  factory AppointmentRequest.fromJson(Map<String, dynamic> json) =>
      _$AppointmentRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AppointmentRequestToJson(this);
}

class EmergencyContact {
  final String id;
  final String name;
  final String phone;
  final String type;
  final bool isActive;

  EmergencyContact({
    required this.id,
    required this.name,
    required this.phone,
    required this.type,
    this.isActive = true,
  });
}

class EmergencyReport {
  final String id;
  final String patientId;
  final String description;
  final String severity;
  final List<String> symptoms;
  final String? imageUrl;
  final DateTime timestamp;
  final String status;
  final String? responseMessage;

  EmergencyReport({
    required this.id,
    required this.patientId,
    required this.description,
    required this.severity,
    required this.symptoms,
    this.imageUrl,
    required this.timestamp,
    required this.status,
    this.responseMessage,
  });
}

enum EmergencySeverity {
  low,
  medium,
  high,
  critical,
}

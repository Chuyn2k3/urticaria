class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String avatar;
  final double rating;
  final int experience;
  final List<String> availableDays;
  final List<TimeSlot> timeSlots;
  final bool isAvailable;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.avatar,
    required this.rating,
    required this.experience,
    required this.availableDays,
    required this.timeSlots,
    this.isAvailable = true,
  });
}

class TimeSlot {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final bool isBooked;
  final String? patientId;

  TimeSlot({
    required this.id,
    required this.startTime,
    required this.endTime,
    this.isBooked = false,
    this.patientId,
  });
}

class Appointment {
  final String id;
  final String doctorId;
  final String patientId;
  final DateTime appointmentTime;
  final String type;
  final String status;
  final String? notes;
  final DateTime createdAt;

  Appointment({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.appointmentTime,
    required this.type,
    required this.status,
    this.notes,
    required this.createdAt,
  });
}

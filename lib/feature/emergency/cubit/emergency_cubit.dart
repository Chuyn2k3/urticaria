import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urticaria/feature/emergency/models/emergency_model.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyCubit extends Cubit<EmergencyState> {
  EmergencyCubit() : super(EmergencyInitial());

  final List<EmergencyContact> _emergencyContacts = [
    EmergencyContact(
      id: '1',
      name: 'Cấp cứu 115',
      phone: '115',
      type: 'emergency',
    ),
    EmergencyContact(
      id: '2',
      name: 'Hotline Bệnh viện',
      phone: '1900-xxxx',
      type: 'hospital',
    ),
    EmergencyContact(
      id: '3',
      name: 'Bác sĩ trực',
      phone: '0901-xxx-xxx',
      type: 'doctor',
    ),
  ];

  void loadEmergencyContacts() {
    emit(EmergencyContactsLoaded(_emergencyContacts));
  }

//   Future<void> makeEmergencyCall(  {
//   emit(EmergencyContactsLoaded(_emergencyContacts));
// }

  Future<void> makeEmergencyCall(String phoneNumber) async {
    try {
      final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
        emit(EmergencyCallMade(phoneNumber));
      } else {
        emit(EmergencyError('Không thể thực hiện cuộc gọi'));
      }
    } catch (e) {
      emit(EmergencyError('Lỗi khi gọi điện: ${e.toString()}'));
    }
  }

  void reportEmergency(
      String description, List<String> symptoms, String severity) {
    emit(EmergencyLoading());

    try {
      final report = EmergencyReport(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        patientId: 'current_user_id',
        description: description,
        severity: severity,
        symptoms: symptoms,
        timestamp: DateTime.now(),
        status: 'pending',
      );

      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        emit(EmergencyReported(report));
      });
    } catch (e) {
      emit(EmergencyError('Không thể gửi báo cáo khẩn cấp'));
    }
  }

  void checkSymptomSeverity(List<String> symptoms) {
    final criticalSymptoms = [
      'khó thở',
      'sưng cổ họng',
      'choáng váng',
      'ngất xỉu',
      'nôn mửa liên tục',
      'sưng mặt nghiêm trọng'
    ];

    final hasCriticalSymptoms = symptoms.any((symptom) => criticalSymptoms
        .any((critical) => symptom.toLowerCase().contains(critical)));

    if (hasCriticalSymptoms) {
      emit(CriticalSymptomsDetected(symptoms));
    } else {
      emit(SymptomsAssessed('normal'));
    }
  }
}

abstract class EmergencyState {}

class EmergencyInitial extends EmergencyState {}

class EmergencyLoading extends EmergencyState {}

class EmergencyContactsLoaded extends EmergencyState {
  final List<EmergencyContact> contacts;
  EmergencyContactsLoaded(this.contacts);
}

class EmergencyCallMade extends EmergencyState {
  final String phoneNumber;
  EmergencyCallMade(this.phoneNumber);
}

class EmergencyReported extends EmergencyState {
  final EmergencyReport report;
  EmergencyReported(this.report);
}

class CriticalSymptomsDetected extends EmergencyState {
  final List<String> symptoms;
  CriticalSymptomsDetected(this.symptoms);
}

class SymptomsAssessed extends EmergencyState {
  final String severity;
  SymptomsAssessed(this.severity);
}

class EmergencyError extends EmergencyState {
  final String message;
  EmergencyError(this.message);
}

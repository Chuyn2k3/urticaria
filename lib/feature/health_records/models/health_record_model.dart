import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'health_record_model.g.dart';

@JsonSerializable()
class HealthRecord {
  final String id;
  final String patientId;
  final String recordType;
  final DateTime createdDate;
  final DateTime? updatedDate;
  final String status;
  final String symptoms;
  final String diagnosis;
  final String treatment;
  final String doctorName;
  final String doctorId;
  final String notes;
  final List<String> imageUrls;
  final Map<String, dynamic>? additionalData;

  HealthRecord({
    required this.id,
    required this.patientId,
    required this.recordType,
    required this.createdDate,
    this.updatedDate,
    required this.status,
    required this.symptoms,
    required this.diagnosis,
    required this.treatment,
    required this.doctorName,
    required this.doctorId,
    required this.notes,
    this.imageUrls = const [],
    this.additionalData,
  });

  factory HealthRecord.fromJson(Map<String, dynamic> json) =>
      _$HealthRecordFromJson(json);

  Map<String, dynamic> toJson() => _$HealthRecordToJson(this);

  HealthRecord copyWith({
    String? id,
    String? patientId,
    String? recordType,
    DateTime? createdDate,
    DateTime? updatedDate,
    String? status,
    String? symptoms,
    String? diagnosis,
    String? treatment,
    String? doctorName,
    String? doctorId,
    String? notes,
    List<String>? imageUrls,
    Map<String, dynamic>? additionalData,
  }) {
    return HealthRecord(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      recordType: recordType ?? this.recordType,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
      status: status ?? this.status,
      symptoms: symptoms ?? this.symptoms,
      diagnosis: diagnosis ?? this.diagnosis,
      treatment: treatment ?? this.treatment,
      doctorName: doctorName ?? this.doctorName,
      doctorId: doctorId ?? this.doctorId,
      notes: notes ?? this.notes,
      imageUrls: imageUrls ?? this.imageUrls,
      additionalData: additionalData ?? this.additionalData,
    );
  }

  static List<HealthRecord> getMockData() {
    return [
      HealthRecord(
        id: 'HR001',
        patientId: 'P001',
        recordType: 'Cấp tính',
        createdDate: DateTime.now().subtract(const Duration(days: 2)),
        updatedDate: DateTime.now().subtract(const Duration(days: 1)),
        status: 'completed',
        symptoms: 'Ngứa, phát ban đỏ ở cánh tay và chân, sưng phù nhẹ',
        diagnosis: 'Viêm da cơ địa cấp tính',
        treatment: 'Thuốc bôi Corticosteroid, thuốc kháng histamine',
        doctorName: 'BS. Nguyễn Văn Minh',
        doctorId: 'D001',
        notes: 'Tái khám sau 1 tuần, tránh tiếp xúc với chất gây dị ứng',
        imageUrls: [
          'https://example.com/image1.jpg',
          'https://example.com/image2.jpg',
        ],
        additionalData: {
          'severity': 'medium',
          'allergen': 'unknown',
        },
      ),
      HealthRecord(
        id: 'HR002',
        patientId: 'P001',
        recordType: 'Mãn tính lần 1',
        createdDate: DateTime.now().subtract(const Duration(days: 7)),
        updatedDate: DateTime.now().subtract(const Duration(hours: 6)),
        status: 'inProgress',
        symptoms: 'Mề đay mãn tính, ngứa ban đêm, mất ngủ',
        diagnosis: 'Đang chờ kết quả xét nghiệm máu và test dị ứng',
        treatment: 'Thuốc kháng histamine thế hệ 2',
        doctorName: 'BS. Trần Thị Lan',
        doctorId: 'D002',
        notes: 'Cần xét nghiệm máu, test dị ứng. Hẹn tái khám sau 3 ngày',
        imageUrls: [
          'https://example.com/image3.jpg',
        ],
        additionalData: {
          'severity': 'high',
          'duration': '2 months',
        },
      ),
      HealthRecord(
        id: 'HR003',
        patientId: 'P001',
        recordType: 'Cấp tính',
        createdDate: DateTime.now().subtract(const Duration(days: 14)),
        status: 'pending',
        symptoms: 'Sưng phù quanh mắt, đau rát, khó thở nhẹ',
        diagnosis: '',
        treatment: '',
        doctorName: '',
        doctorId: '',
        notes: '',
        imageUrls: [
          'https://example.com/image4.jpg',
          'https://example.com/image5.jpg',
          'https://example.com/image6.jpg',
        ],
        additionalData: {
          'severity': 'high',
          'emergency': true,
        },
      ),
      HealthRecord(
        id: 'HR004',
        patientId: 'P001',
        recordType: 'Mãn tính tái khám',
        createdDate: DateTime.now().subtract(const Duration(days: 30)),
        updatedDate: DateTime.now().subtract(const Duration(days: 28)),
        status: 'completed',
        symptoms: 'Cải thiện 80%, còn ngứa nhẹ vào buổi tối',
        diagnosis: 'Viêm da cơ địa mãn tính - đáp ứng tốt với điều trị',
        treatment: 'Giảm liều thuốc, duy trì kem dưỡng ẩm',
        doctorName: 'BS. Lê Văn Hùng',
        doctorId: 'D003',
        notes: 'Tiếp tục theo dõi, tái khám sau 1 tháng',
        imageUrls: [
          'https://example.com/image7.jpg',
        ],
        additionalData: {
          'severity': 'low',
          'improvement': '80%',
        },
      ),
    ];
  }
}

enum RecordStatus {
  pending('pending', 'Chờ khám', Colors.orange),
  inProgress('inProgress', 'Đang khám', Colors.blue),
  completed('completed', 'Hoàn thành', Colors.green),
  cancelled('cancelled', 'Đã hủy', Colors.red);

  const RecordStatus(this.value, this.displayName, this.color);

  final String value;
  final String displayName;
  final MaterialColor color; // <-- sửa chỗ này

  static RecordStatus fromString(String value) {
    return RecordStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => RecordStatus.pending,
    );
  }
}

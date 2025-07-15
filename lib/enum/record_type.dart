// File: models/record_type.dart
enum RecordType {
  cap,
  manTinhLan1,
  manTinhTaiKham,
}

extension RecordTypeExtension on RecordType {
  String get displayName {
    switch (this) {
      case RecordType.cap:
        return 'Bệnh án cấp';
      case RecordType.manTinhLan1:
        return 'Bệnh án mạn tính lần 1';
      case RecordType.manTinhTaiKham:
        return 'Bệnh án mạn tính tái khám';
    }
  }

  static RecordType fromString(String type) {
    switch (type) {
      case 'man_tinh_lan1':
        return RecordType.manTinhLan1;
      case 'man_tinh_taikham':
        return RecordType.manTinhTaiKham;
      case 'cap':
      default:
        return RecordType.cap;
    }
  }
}

import 'package:json_annotation/json_annotation.dart';

part 'chronic_urticaria_followup_record.g.dart';

@JsonSerializable()
class ChronicUrticariaFollowupRecord {
  // Thông tin cơ bản của bệnh nhân
  String? fullName; // Họ và tên của bệnh nhân
  String? nationalId; // Số căn cước công dân của bệnh nhân
  String? age; // Tuổi của bệnh nhân; nếu dưới 6 tuổi thì ghi theo tháng
  String? gender; // Giới tính của bệnh nhân (0: Nam, 1: Nữ)
  String? phoneNumber; // Số điện thoại của bệnh nhân (bắt buộc)
  String?
      addressArea; // Khu vực sinh sống: Thành thị, Nông thôn, Miền biển, Vùng núi
  String?
      occupation; // Nghề nghiệp: Công nhân, Nông dân, HS-SV, Cán bộ công chức, Khác
  String?
      exposureHistory; // Tiền sử tiếp xúc: Hóa chất, Ánh sáng, Bụi, Khác, Không
  String? recordOpenDate; // Ngày mở hồ sơ bệnh án
  String? examinationDate; // Ngày khám bệnh

  // Theo dõi hoạt động bệnh & kiểm soát bệnh
  String? uas7OnTreatmentISS7; // Điểm ISS7 khi dùng thuốc
  String? uas7OnTreatmentHSS7; // Điểm HSS7 khi dùng thuốc
  String? uas7OffTreatmentISS7; // Điểm ISS7 khi ngừng thuốc
  String? uas7OffTreatmentHSS7; // Điểm HSS7 khi ngừng thuốc
  String? uctScore; // Mức độ kiểm soát bệnh (UCT)
  String?
      treatmentResponse; // Mức độ đáp ứng điều trị: kiểm soát hoàn toàn, tốt, kém (nhẹ/trung bình/cao)

  // Tác dụng không mong muốn (side effects)
  String? sideEffectFatigue; // Tác dụng phụ – Toàn trạng: Mệt mỏi
  String? sideEffectHeadache; // Tác dụng phụ – Thần kinh: Đau đầu
  String? sideEffectDizziness; // Tác dụng phụ – Thần kinh: Chóng mặt
  String? sideEffectSleepy; // Tác dụng phụ – Thần kinh: Buồn ngủ
  String? sideEffectDrowsiness; // Tác dụng phụ – Thần kinh: Ngủ gà
  String? sideEffectLossOfAppetite; // Tác dụng phụ – Tiêu hóa: Chán ăn
  String? sideEffectIndigestion; // Tác dụng phụ – Tiêu hóa: Khó tiêu
  String? sideEffectAbdominalPain; // Tác dụng phụ – Tiêu hóa: Đau bụng
  String? sideEffectChestPain; // Tác dụng phụ – Tim mạch: Đau ngực
  String?
      sideEffectPalpitations; // Tác dụng phụ – Tim mạch: Hồi hộp, trống ngực
  String? sideEffectOther; // Tác dụng phụ khác (ghi rõ)

  // Triệu chứng hiện tại
  String? rashPresent; // Có sẩn phù hay không
  String? angioedemaPresent; // Có phù mạch hay không
  List<String>? angioedemaLocation; // Vị trí phù mạch (multiple choice)
  String? aas7Score; // Điểm AAS7
  String? anaphylaxisSymptoms; // Triệu chứng phản vệ
  String? newMedicalHistory; // Tiểu sử bệnh án khác mới phát hiện

  // Kết quả test
  String? dermatographismTest; // Kết quả da vẽ nổi: Dương tính hoặc Âm tính
  String? fricScore; // Điểm Fric
  String? itchScoreNRS; // Điểm ngứa NRS
  String? painScoreNRS; // Điểm đau NRS
  String? burningScoreNRS; // Điểm bỏng rát NRS
  String?
      coldUrticariaTemptest; // Mày đay do lạnh (Temptest): Dương tính hoặc Âm tính
  String? coldPositiveTemperature; // Vùng nhiệt độ dương tính (°C)
  String? itchScoreNRSCold; // Điểm ngứa NRS khi Temptest
  String? painScoreNRSCold; // Điểm đau NRS khi Temptest
  String? burningScoreNRSCold; // Điểm bỏng rát NRS khi Temptest
  String?
      coldUrticariaIceTest; // Mày đay do lạnh – Test cục đá: Dương tính hoặc Âm tính
  String? coldIceTimeThreshold; // Ngưỡng thời gian (phút) khi Test cục đá
  String? itchScoreNRSIce; // Điểm ngứa NRS khi Test cục đá
  String? painScoreNRSIce; // Điểm đau NRS khi Test cục đá
  String? burningScoreNRSIce; // Điểm bỏng rát NRS khi Test cục đá
  String?
      cholinergicUrticariaTest; // Mày đay do choline: Dương tính hoặc Âm tính
  String?
      cholinergicAppearanceTime; // Thời gian xuất hiện tổn thương (phút) khi test choline
  String? itchScoreNRSCholine; // Điểm ngứa NRS khi test choline
  String? painScoreNRSCholine; // Điểm đau NRS khi test choline
  String? burningScoreNRSCholine; // Điểm bỏng rát NRS khi test choline
  String? cusiScore; // Mức độ hoạt động bệnh CUSI
  String? otherCause; // Căn nguyên khác
  String? actScore; // Mức độ kiểm soát bệnh ACT

  ChronicUrticariaFollowupRecord();

  factory ChronicUrticariaFollowupRecord.fromJson(Map<String, dynamic> json) =>
      _$ChronicUrticariaFollowupRecordFromJson(json);

  Map<String, dynamic> toJson() => _$ChronicUrticariaFollowupRecordToJson(this);
}

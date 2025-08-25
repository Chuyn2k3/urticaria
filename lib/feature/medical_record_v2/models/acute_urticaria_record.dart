import 'package:json_annotation/json_annotation.dart';

part 'acute_urticaria_record.g.dart';

@JsonSerializable()
class AcuteUrticariaRecord {
  // Thông tin cơ bản
  String? fullName;
  String? nationalId;
  String? age;
  String? gender;
  String? phoneNumber;
  String? addressArea;
  String? occupation;
  String? exposureHistory;
  String? recordOpenDate;
  String? examinationDate;

  // Bệnh án cấp tính - phần chung
  String? continuousOutbreak6Weeks; // Đợt bệnh ≥ 6 tuần
  String? rashOrAngioedema; // Loại tổn thương: Sẩn phù, Phù mạch,...
  String? firstOutbreakSinceWeeks; // Lần đầu tổn thương từ bao nhiêu tuần
  String? outbreakCount; // Số đợt bị mày đay (≥ 2 lần/tuần)

  // Đợt 1
  String? outbreak1StartMonth;
  String? outbreak1StartYear;
  String? outbreak1EndMonth;
  String? outbreak1EndYear;
  String? outbreak1TreatmentReceived;
  String? outbreak1DrugResponse;
  String? outbreak1DrugResponseSymptom;

  // Đợt 2
  String? outbreak2StartMonth;
  String? outbreak2StartYear;
  String? outbreak2EndMonth;
  String? outbreak2EndYear;
  String? outbreak2TreatmentReceived;
  String? outbreak2DrugResponse;
  String? outbreak2DrugResponseSymptom;

  // Đợt 3
  String? outbreak3StartMonth;
  String? outbreak3StartYear;
  String? outbreak3EndMonth;
  String? outbreak3EndYear;
  String? outbreak3TreatmentReceived;
  String? outbreak3DrugResponse;
  String? outbreak3DrugResponseSymptom;

  // Đợt hiện tại
  String? currentOutbreakStartMonth;
  String? currentOutbreakStartYear;
  String? currentOutbreakEndMonth;
  String? currentOutbreakEndYear;
  String? currentOutbreakWeeks; // Tự động tính
  String? currentTreatmentReceived;
  String? currentDrugResponse;
  String? currentDrugResponseSymptom;

  String? drugName; // Tên thuốc đã dùng
  String? drugDuration; // Thời gian dùng thuốc
  String? drugDosage; // Liều dùng thuốc

  // Sẩn phù
  String? rashAppearanceTime; // Thời điểm nốt đỏ xuất hiện
  List<String>?
      rashTriggerFactors; // Yếu tố kích thích nốt đỏ (multiple choice)
  List<String>? rashWorseningFactors; // Yếu tố làm nặng bệnh (multiple choice)
  String? rashFoodTriggerDetail; // Chi tiết thức ăn gây nặng
  String? rashDrugTriggerDetail; // Chi tiết thuốc gây nặng
  List<String>? rashLocation; // Vị trí nốt đỏ (multiple choice)
  Map<String, List<String>>? rashLocationImages; // Ảnh theo từng vị trí
  String? rashSizeOnTreatment; // Kích thước nốt đỏ khi dùng thuốc
  String? rashSizeNoTreatment; // Kích thước nốt đỏ khi không dùng thuốc
  String? rashBorder; // Ranh giới nốt đỏ
  String? rashShape; // Hình dạng nốt đỏ
  String? rashColor; // Màu sắc nốt đỏ
  String? rashDurationOnTreatment; // Thời gian tồn tại nốt đỏ khi dùng thuốc
  String? rashDurationNoTreatment; // Thời gian tồn tại khi không dùng thuốc
  List<String>? rashSurface; // Đặc điểm bề mặt (multiple choice)
  String? rashTimeOfDay; // Thời gian trong ngày nốt đỏ xuất hiện
  String? rashCountPerDay; // Số lượng nốt đỏ trung bình/ngày
  String? rashSensation; // Cảm giác tại vị trí nốt đỏ

  // Phù mạch
  String? angioedemaCount; // Số lần sưng phù
  List<String>? angioedemaLocation; // Vị trí sưng phù (multiple choice)
  Map<String, List<String>>? angioedemaLocationImages; // Ảnh theo từng vị trí
  List<String>? angioedemaSurface; // Đặc điểm bề mặt phù mạch (multiple choice)
  String? angioedemaDurationOnTreatment; // Thời gian tồn tại khi dùng thuốc
  String?
      angioedemaDurationNoTreatment; // Thời gian tồn tại khi không dùng thuốc
  String? angioedemaTimeOfDay; // Thời gian xuất hiện phù mạch trong ngày
  String? angioedemaSensation; // Cảm giác tại vị trí phù mạch

  // Yếu tố khởi phát & Tiền sử
  String? triggerInfection;
  String? triggerFood;
  String? triggerDrug;
  String? triggerInsectBite;
  String? triggerOther;
  String? personalAllergyHistory;
  String? personalDrugHistory;
  String? personalUrticariaHistory;
  String? personalOtherHistory;

  // Khám thực thể
  String? fever;
  String? feverTemperature;
  String? pulseRate;
  String? bloodPressure;

  // Chẩn đoán & Xét nghiệm
  String? preliminaryDiagnosis;
  String? wbc;
  String? neu;
  String? crp;
  String? totalIgE;
  String? otherLabTests;
  String? finalDiagnosis;

  // Điều trị & Hẹn tái khám
  String? antihistamineH1;
  String? corticosteroidSystemic;
  String? hospitalization;
  String? followUpDate;

  AcuteUrticariaRecord();

  factory AcuteUrticariaRecord.fromJson(Map<String, dynamic> json) =>
      _$AcuteUrticariaRecordFromJson(json);

  Map<String, dynamic> toJson() => _$AcuteUrticariaRecordToJson(this);
}

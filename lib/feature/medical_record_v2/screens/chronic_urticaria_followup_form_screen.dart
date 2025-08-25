import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urticaria/feature/bottom_nav/bottom_nav_page.dart';
import 'package:urticaria/feature/medical_record_v2/cubits/chronic_followup/chronic_followup_cubit.dart';
import 'package:urticaria/feature/medical_record_v2/cubits/chronic_followup/chronic_followup_state.dart';
import 'package:urticaria/utils/snack_bar.dart';
import '../models/chronic_urticaria_followup_record.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_radio_group.dart';
import '../widgets/custom_checkbox_group.dart';
import '../widgets/image_upload_widget.dart';
import '../widgets/section_header.dart';

class ChronicUrticariaFollowupFormScreen extends StatefulWidget {
  const ChronicUrticariaFollowupFormScreen({Key? key}) : super(key: key);

  @override
  State<ChronicUrticariaFollowupFormScreen> createState() =>
      _ChronicUrticariaFollowupFormScreenState();
}

class _ChronicUrticariaFollowupFormScreenState
    extends State<ChronicUrticariaFollowupFormScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 6;

  final ChronicUrticariaFollowupRecord _record =
      ChronicUrticariaFollowupRecord();
  List<String> _rashImages = [];
  List<String> _angioedemaImages = [];

  final List<String> _stepTitles = [
    'Thông tin cơ bản',
    'Hoạt động bệnh & Điều trị',
    'Tác dụng phụ',
    'Triệu chứng hiện tại',
    'Kết quả test',
    'Hoàn thành',
  ];

  // Helper function to calculate weeks between dates
  int _calculateWeeks(DateTime start, DateTime? end) {
    final endDate = end ?? DateTime.now();
    final difference = endDate.difference(start).inDays;
    return (difference / 7).round();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _submitForm() {
    context.read<ChronicFollowupCubit>().submitForm(_record);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Bệnh án tái khám - ${_stepTitles[_currentStep]}',
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocListener<ChronicFollowupCubit, ChronicFollowupState>(
        listener: (context, state) async {
          if (state is ChronicFollowupSubmitted) {
            context.showSnackBarSuccess(
                text: "Tạo yêu cầu thành công", positionTop: true);
            await Future.delayed(const Duration(seconds: 2));
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const BottomNavPage(),
                ));
          } else if (state is ChronicFollowupError) {
            context.showSnackBarFail(text: state.message, positionTop: true);
          }
        },
        child: Column(
          children: [
            // Progress indicator
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Bước ${_currentStep + 1}/$_totalSteps',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.orange,
                        ),
                      ),
                      Text(
                        '${((_currentStep + 1) / _totalSteps * 100).round()}%',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (_currentStep + 1) / _totalSteps,
                    backgroundColor: Colors.grey[300],
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.orange),
                  ),
                ],
              ),
            ),
            // Form content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildBasicInfoStep(),
                  _buildDiseaseActivityStep(),
                  _buildSideEffectsStep(),
                  _buildCurrentSymptomsStep(),
                  _buildTestResultsStep(),
                  _buildCompletionStep(),
                ],
              ),
            ),
            // Navigation buttons
            BlocBuilder<ChronicFollowupCubit, ChronicFollowupState>(
              builder: (context, state) {
                final isSubmitting = state is ChronicFollowupSubmitting;

                return Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Row(
                    children: [
                      if (_currentStep > 0)
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isSubmitting ? null : _previousStep,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              foregroundColor: Colors.black87,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('Quay lại'),
                          ),
                        ),
                      if (_currentStep > 0) const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isSubmitting
                              ? null
                              : (_currentStep == _totalSteps - 1
                                  ? _submitForm
                                  : _nextStep),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: isSubmitting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Text(_currentStep == _totalSteps - 1
                                  ? 'Hoàn thành'
                                  : 'Tiếp theo'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SectionHeader(
            title: 'Thông tin cơ bản',
            icon: Icons.person,
          ),
          CustomTextField(
            label: 'Họ và tên *',
            value: _record.fullName,
            onChanged: (value) => _record.fullName = value,
            isRequired: true,
          ),
          CustomTextField(
            label: 'Số căn cước công dân *',
            value: _record.nationalId,
            onChanged: (value) => _record.nationalId = value,
            isRequired: true,
          ),
          CustomTextField(
            label: 'Tuổi',
            value: _record.age,
            onChanged: (value) => _record.age = value,
            hint: 'Nếu dưới 6 tuổi thì ghi theo tháng',
            keyboardType: TextInputType.number,
          ),
          CustomRadioGroup(
            label: 'Giới tính *',
            value: _record.gender,
            options: const ['Nam', 'Nữ'],
            onChanged: (value) => setState(() => _record.gender = value),
            isRequired: true,
          ),
          CustomTextField(
            label: 'Số điện thoại *',
            value: _record.phoneNumber,
            onChanged: (value) => _record.phoneNumber = value,
            keyboardType: TextInputType.phone,
            isRequired: true,
          ),
          CustomRadioGroup(
            label: 'Khu vực sinh sống',
            value: _record.addressArea,
            options: const ['Thành thị', 'Nông thôn', 'Miền biển', 'Vùng núi'],
            onChanged: (value) => setState(() => _record.addressArea = value),
          ),
          CustomRadioGroup(
            label: 'Nghề nghiệp',
            value: _record.occupation,
            options: const [
              'Công nhân',
              'Nông dân',
              'HS-SV',
              'Cán bộ công chức',
              'Khác'
            ],
            onChanged: (value) => setState(() => _record.occupation = value),
          ),
          CustomRadioGroup(
            label: 'Tiền sử tiếp xúc',
            value: _record.exposureHistory,
            options: const ['Hóa chất', 'Ánh sáng', 'Bụi', 'Khác', 'Không'],
            onChanged: (value) =>
                setState(() => _record.exposureHistory = value),
          ),
          CustomTextField(
            label: 'Ngày mở hồ sơ bệnh án',
            value: _record.recordOpenDate,
            onChanged: (value) => _record.recordOpenDate = value,
            hint: 'dd/mm/yyyy',
            keyboardType: TextInputType.datetime,
          ),
          CustomTextField(
            label: 'Ngày khám bệnh',
            value: _record.examinationDate,
            onChanged: (value) => _record.examinationDate = value,
            hint: 'dd/mm/yyyy',
            keyboardType: TextInputType.datetime,
          ),
        ],
      ),
    );
  }

  Widget _buildDiseaseActivityStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SectionHeader(
            title: 'Theo dõi hoạt động bệnh & kiểm soát bệnh',
            icon: Icons.monitor_heart,
          ),
          // UAS7 khi dùng thuốc
          const Text(
            'UAS7 khi dùng thuốc',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          CustomTextField(
            label: 'Điểm ISS7 (khi dùng thuốc)',
            value: _record.uas7OnTreatmentISS7,
            keyboardType: TextInputType.number,
            onChanged: (val) => _record.uas7OnTreatmentISS7 = val,
            hint: '0-21',
          ),
          CustomTextField(
            label: 'Điểm HSS7 (khi dùng thuốc)',
            value: _record.uas7OnTreatmentHSS7,
            keyboardType: TextInputType.number,
            onChanged: (val) => _record.uas7OnTreatmentHSS7 = val,
            hint: '0-21',
          ),
          const SizedBox(height: 16),
          // UAS7 khi ngừng thuốc
          const Text(
            'UAS7 khi ngừng thuốc',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          CustomTextField(
            label: 'Điểm ISS7 (khi ngừng thuốc)',
            value: _record.uas7OffTreatmentISS7,
            keyboardType: TextInputType.number,
            onChanged: (val) => _record.uas7OffTreatmentISS7 = val,
            hint: '0-21',
          ),
          CustomTextField(
            label: 'Điểm HSS7 (khi ngừng thuốc)',
            value: _record.uas7OffTreatmentHSS7,
            keyboardType: TextInputType.number,
            onChanged: (val) => _record.uas7OffTreatmentHSS7 = val,
            hint: '0-21',
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Mức độ kiểm soát bệnh (UCT điểm)',
            value: _record.uctScore,
            keyboardType: TextInputType.number,
            onChanged: (val) => _record.uctScore = val,
            hint: '0-16',
          ),
          CustomRadioGroup(
            label: 'Mức độ đáp ứng điều trị',
            value: _record.treatmentResponse,
            options: const [
              'Kiểm soát hoàn toàn (UCT: 16, UAS7: 0)',
              'Kiểm soát tốt, bệnh rất nhẹ (UCT: 12-15, UAS7: 1-6)',
              'Kiểm soát kém, bệnh nhẹ (UCT: <12, UAS7: 7-15)',
              'Kiểm soát kém, bệnh trung bình (UCT: <12, UAS7: 16-27)',
              'Kiểm soát kém, bệnh cao (UCT: <12, UAS7: 28-42)',
            ],
            onChanged: (val) => setState(() => _record.treatmentResponse = val),
          ),
        ],
      ),
    );
  }

  Widget _buildSideEffectsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Tác dụng không mong muốn',
            icon: Icons.report_problem,
          ),
          const Text('Toàn trạng'),
          const SizedBox(height: 8),
          CustomRadioGroup(
            label: 'Mệt mỏi',
            value: _record.sideEffectFatigue,
            options: const ['Có', 'Không'],
            onChanged: (val) => setState(() => _record.sideEffectFatigue = val),
          ),
          const SizedBox(height: 16),
          const Text('Thần kinh'),
          const SizedBox(height: 8),
          CustomRadioGroup(
            label: 'Đau đầu',
            value: _record.sideEffectHeadache,
            options: const ['Có', 'Không'],
            onChanged: (val) =>
                setState(() => _record.sideEffectHeadache = val),
          ),
          CustomRadioGroup(
            label: 'Chóng mặt',
            value: _record.sideEffectDizziness,
            options: const ['Có', 'Không'],
            onChanged: (val) =>
                setState(() => _record.sideEffectDizziness = val),
          ),
          CustomRadioGroup(
            label: 'Buồn ngủ',
            value: _record.sideEffectSleepy,
            options: const ['Có', 'Không'],
            onChanged: (val) => setState(() => _record.sideEffectSleepy = val),
          ),
          CustomRadioGroup(
            label: 'Ngủ gà',
            value: _record.sideEffectDrowsiness,
            options: const ['Có', 'Không'],
            onChanged: (val) =>
                setState(() => _record.sideEffectDrowsiness = val),
          ),
          const SizedBox(height: 16),
          const Text('Tiêu hóa'),
          const SizedBox(height: 8),
          CustomRadioGroup(
            label: 'Chán ăn',
            value: _record.sideEffectLossOfAppetite,
            options: const ['Có', 'Không'],
            onChanged: (val) =>
                setState(() => _record.sideEffectLossOfAppetite = val),
          ),
          CustomRadioGroup(
            label: 'Khó tiêu',
            value: _record.sideEffectIndigestion,
            options: const ['Có', 'Không'],
            onChanged: (val) =>
                setState(() => _record.sideEffectIndigestion = val),
          ),
          CustomRadioGroup(
            label: 'Đau bụng',
            value: _record.sideEffectAbdominalPain,
            options: const ['Có', 'Không'],
            onChanged: (val) =>
                setState(() => _record.sideEffectAbdominalPain = val),
          ),
          const SizedBox(height: 16),
          const Text('Tim mạch'),
          const SizedBox(height: 8),
          CustomRadioGroup(
            label: 'Đau ngực',
            value: _record.sideEffectChestPain,
            options: const ['Có', 'Không'],
            onChanged: (val) =>
                setState(() => _record.sideEffectChestPain = val),
          ),
          CustomRadioGroup(
            label: 'Hồi hộp, trống ngực',
            value: _record.sideEffectPalpitations,
            options: const ['Có', 'Không'],
            onChanged: (val) =>
                setState(() => _record.sideEffectPalpitations = val),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Tác dụng phụ khác (ghi rõ)',
            value: _record.sideEffectOther,
            onChanged: (val) => setState(() => _record.sideEffectOther = val),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentSymptomsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Triệu chứng hiện tại',
            icon: Icons.healing,
          ),
          CustomRadioGroup(
            label: 'Có sẩn phù hay không',
            value: _record.rashPresent,
            options: const ['Có', 'Không'],
            onChanged: (val) => setState(() => _record.rashPresent = val),
          ),
          CustomRadioGroup(
            label: 'Có phù mạch hay không',
            value: _record.angioedemaPresent,
            options: const ['Có', 'Không'],
            onChanged: (val) => setState(() => _record.angioedemaPresent = val),
          ),
          if (_record.angioedemaPresent == 'Có') ...[
            const SizedBox(height: 16),
            const Text('Vị trí phù mạch'),
            CustomCheckboxGroup(
              label: 'Chọn vị trí phù mạch',
              selectedValues: _record.angioedemaLocation ?? [],
              options: const [
                'Mắt',
                'Môi',
                'Lưỡi',
                'Thanh quản',
                'Sinh dục',
                'Bàn tay',
                'Bàn chân',
                'Khác',
              ],
              onChanged: (selected) {
                setState(() {
                  _record.angioedemaLocation = selected;
                });
              },
            ),
          ],
          CustomTextField(
            label: 'Điểm AAS7',
            value: _record.aas7Score,
            keyboardType: TextInputType.number,
            onChanged: (val) => _record.aas7Score = val,
            hint: '0-21',
          ),
          CustomTextField(
            label: 'Triệu chứng phản vệ',
            value: _record.anaphylaxisSymptoms,
            onChanged: (val) => _record.anaphylaxisSymptoms = val,
            maxLines: 2,
            hint: 'Mô tả các triệu chứng phản vệ nếu có',
          ),
          CustomTextField(
            label: 'Tiểu sử bệnh án khác mới phát hiện',
            value: _record.newMedicalHistory,
            onChanged: (val) => _record.newMedicalHistory = val,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildTestResultsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SectionHeader(
            title: 'Kết quả test',
            icon: Icons.science,
          ),
          // Test da vẽ nổi
          CustomRadioGroup(
            label: 'Kết quả da vẽ nổi (Dermatographism)',
            value: _record.dermatographismTest,
            options: const ['Dương tính', 'Âm tính'],
            onChanged: (val) =>
                setState(() => _record.dermatographismTest = val),
          ),
          if (_record.dermatographismTest == 'Dương tính') ...[
            CustomTextField(
              label: 'Điểm Fric',
              value: _record.fricScore,
              keyboardType: TextInputType.number,
              onChanged: (val) => _record.fricScore = val,
            ),
            CustomTextField(
              label: 'Điểm ngứa NRS',
              value: _record.itchScoreNRS,
              keyboardType: TextInputType.number,
              onChanged: (val) => _record.itchScoreNRS = val,
              hint: '0-10',
            ),
            CustomTextField(
              label: 'Điểm đau NRS',
              value: _record.painScoreNRS,
              keyboardType: TextInputType.number,
              onChanged: (val) => _record.painScoreNRS = val,
              hint: '0-10',
            ),
            CustomTextField(
              label: 'Điểm bỏng rát NRS',
              value: _record.burningScoreNRS,
              keyboardType: TextInputType.number,
              onChanged: (val) => _record.burningScoreNRS = val,
              hint: '0-10',
            ),
          ],
          const SizedBox(height: 16),
          // Test mày đay do lạnh - Temptest
          CustomRadioGroup(
            label: 'Mày đay do lạnh (Temptest)',
            value: _record.coldUrticariaTemptest,
            options: const ['Dương tính', 'Âm tính'],
            onChanged: (val) =>
                setState(() => _record.coldUrticariaTemptest = val),
          ),
          if (_record.coldUrticariaTemptest == 'Dương tính') ...[
            CustomTextField(
              label: 'Vùng nhiệt độ dương tính (°C)',
              value: _record.coldPositiveTemperature,
              keyboardType: TextInputType.number,
              onChanged: (val) => _record.coldPositiveTemperature = val,
            ),
            CustomTextField(
              label: 'Điểm ngứa NRS (khi Temptest)',
              value: _record.itchScoreNRSCold,
              keyboardType: TextInputType.number,
              onChanged: (val) => _record.itchScoreNRSCold = val,
              hint: '0-10',
            ),
            CustomTextField(
              label: 'Điểm đau NRS (khi Temptest)',
              value: _record.painScoreNRSCold,
              keyboardType: TextInputType.number,
              onChanged: (val) => _record.painScoreNRSCold = val,
              hint: '0-10',
            ),
            CustomTextField(
              label: 'Điểm bỏng rát NRS (khi Temptest)',
              value: _record.burningScoreNRSCold,
              keyboardType: TextInputType.number,
              onChanged: (val) => _record.burningScoreNRSCold = val,
              hint: '0-10',
            ),
          ],
          const SizedBox(height: 16),
          // Test mày đay do lạnh - Test cục đá
          CustomRadioGroup(
            label: 'Mày đay do lạnh - Test cục đá',
            value: _record.coldUrticariaIceTest,
            options: const ['Dương tính', 'Âm tính'],
            onChanged: (val) =>
                setState(() => _record.coldUrticariaIceTest = val),
          ),
          if (_record.coldUrticariaIceTest == 'Dương tính') ...[
            CustomTextField(
              label: 'Ngưỡng thời gian (phút)',
              value: _record.coldIceTimeThreshold,
              keyboardType: TextInputType.number,
              onChanged: (val) => _record.coldIceTimeThreshold = val,
            ),
            CustomTextField(
              label: 'Điểm ngứa NRS (khi Test cục đá)',
              value: _record.itchScoreNRSIce,
              keyboardType: TextInputType.number,
              onChanged: (val) => _record.itchScoreNRSIce = val,
              hint: '0-10',
            ),
            CustomTextField(
              label: 'Điểm đau NRS (khi Test cục đá)',
              value: _record.painScoreNRSIce,
              keyboardType: TextInputType.number,
              onChanged: (val) => _record.painScoreNRSIce = val,
              hint: '0-10',
            ),
            CustomTextField(
              label: 'Điểm bỏng rát NRS (khi Test cục đá)',
              value: _record.burningScoreNRSIce,
              keyboardType: TextInputType.number,
              onChanged: (val) => _record.burningScoreNRSIce = val,
              hint: '0-10',
            ),
          ],
          const SizedBox(height: 16),
          // Test mày đay do choline
          CustomRadioGroup(
            label: 'Mày đay do choline',
            value: _record.cholinergicUrticariaTest,
            options: const ['Dương tính', 'Âm tính'],
            onChanged: (val) =>
                setState(() => _record.cholinergicUrticariaTest = val),
          ),
          if (_record.cholinergicUrticariaTest == 'Dương tính') ...[
            CustomTextField(
              label: 'Thời gian xuất hiện tổn thương (phút)',
              value: _record.cholinergicAppearanceTime,
              keyboardType: TextInputType.number,
              onChanged: (val) => _record.cholinergicAppearanceTime = val,
            ),
            CustomTextField(
              label: 'Điểm ngứa NRS (khi test choline)',
              value: _record.itchScoreNRSCholine,
              keyboardType: TextInputType.number,
              onChanged: (val) => _record.itchScoreNRSCholine = val,
              hint: '0-10',
            ),
            CustomTextField(
              label: 'Điểm đau NRS (khi test choline)',
              value: _record.painScoreNRSCholine,
              keyboardType: TextInputType.number,
              onChanged: (val) => _record.painScoreNRSCholine = val,
              hint: '0-10',
            ),
            CustomTextField(
              label: 'Điểm bỏng rát NRS (khi test choline)',
              value: _record.burningScoreNRSCholine,
              keyboardType: TextInputType.number,
              onChanged: (val) => _record.burningScoreNRSCholine = val,
              hint: '0-10',
            ),
          ],
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Mức độ hoạt động bệnh CUSI',
            value: _record.cusiScore,
            keyboardType: TextInputType.number,
            onChanged: (val) => _record.cusiScore = val,
          ),
          CustomTextField(
            label: 'Căn nguyên khác',
            value: _record.otherCause,
            onChanged: (val) => _record.otherCause = val,
            maxLines: 2,
          ),
          CustomTextField(
            label: 'Mức độ kiểm soát bệnh ACT',
            value: _record.actScore,
            keyboardType: TextInputType.number,
            onChanged: (val) => _record.actScore = val,
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SectionHeader(
            title: 'Hoàn thành bệnh án',
            icon: Icons.check_circle,
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green[50],
              border: Border.all(color: Colors.green[200]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Thông tin bệnh án tái khám đã được hoàn thành',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Bệnh nhân: ${_record.fullName ?? "Chưa nhập"}',
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  'Số CCCD: ${_record.nationalId ?? "Chưa nhập"}',
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  'SĐT: ${_record.phoneNumber ?? "Chưa nhập"}',
                  style: const TextStyle(fontSize: 14),
                ),
                if (_record.examinationDate != null)
                  Text(
                    'Ngày khám: ${_record.examinationDate}',
                    style: const TextStyle(fontSize: 14),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Nhấn "Hoàn thành" để gửi bệnh án đến hệ thống.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

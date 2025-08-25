import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urticaria/constant/color.dart';
import 'package:urticaria/cubit/auth/auth_cubit.dart';
import 'package:urticaria/feature/bottom_nav/bottom_nav_page.dart';
import 'package:urticaria/feature/medical_record_v2/cubits/chronic_initital/chronic_initial_cubit.dart';
import 'package:urticaria/feature/medical_record_v2/cubits/chronic_initital/chronic_initial_state.dart';
import 'package:urticaria/feature/medical_record_v2/screens/urticaria_form_selector_screen.dart';
import 'package:urticaria/utils/snack_bar.dart';
import '../models/chronic_urticaria_initial_record.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_radio_group.dart';
import '../widgets/custom_checkbox_group.dart';
import '../widgets/custom_multiple_choice_with_images.dart';
import '../widgets/image_upload_widget.dart';
import '../widgets/section_header.dart';

class ChronicUrticariaInitialFormScreen extends StatefulWidget {
  const ChronicUrticariaInitialFormScreen({Key? key}) : super(key: key);

  @override
  State<ChronicUrticariaInitialFormScreen> createState() =>
      _ChronicUrticariaInitialFormScreenState();
}

class _ChronicUrticariaInitialFormScreenState
    extends State<ChronicUrticariaInitialFormScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 10;

  final ChronicUrticariaInitialRecord _record = ChronicUrticariaInitialRecord();
  Map<String, List<String>> _rashLocationImages = {};
  Map<String, List<String>> _angioedemaLocationImages = {};

  final List<String> _stepTitles = [
    'Thông tin cơ bản',
    'Bệnh án mãn tính',
    'Lịch sử các đợt bệnh',
    'Sẩn phù',
    'Phù mạch',
    'Tiền sử - Bệnh sử',
    'Khám thực thể',
    'Chẩn đoán & Xét nghiệm',
    'Điều trị & Theo dõi',
    'Hoàn thành',
  ];

  // Face sub-options for location selection
  final Map<String, List<String>> _faceSubOptions = {
    'Mặt': ['Mặt thẳng', 'Nghiêng trái', 'Nghiêng phải'],
    'Thân': ['Thân trước, Thân sau']
  };

  // Helper function to calculate weeks between dates
  int _calculateWeeksBetween(String? startMonth, String? startYear,
      String? endMonth, String? endYear) {
    if (startYear == null || endYear == null) return 0;

    try {
      int startM = startMonth != null ? int.parse(startMonth) : 1;
      int startY = int.parse(startYear);
      int endM = endMonth != null ? int.parse(endMonth) : 12;
      int endY = int.parse(endYear);

      DateTime startDate = DateTime(startY, startM);
      DateTime endDate = DateTime(endY, endM);

      return endDate.difference(startDate).inDays ~/ 7;
    } catch (e) {
      return 0;
    }
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
    // Update record with image data
    _record.rashLocationImages = _rashLocationImages;
    _record.angioedemaLocationImages = _angioedemaLocationImages;

    context.read<ChronicInitialCubit>().submitForm(_record);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Bệnh án mãn tính lần 1 - ${_stepTitles[_currentStep]}',
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocListener<ChronicInitialCubit, ChronicInitialState>(
        listener: (context, state) async {
          if (state is ChronicInitialSubmitted) {
            context.showSnackBarSuccess(
                text: "Tạo yêu cầu thành công", positionTop: true);
            await Future.delayed(const Duration(seconds: 2));
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const BottomNavPage(),
                ));
          } else if (state is ChronicInitialError) {
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
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      Text(
                        '${((_currentStep + 1) / _totalSteps * 100).round()}%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (_currentStep + 1) / _totalSteps,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primaryColor),
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
                  _buildChronicUrticariaStep(),
                  _buildOutbreakHistoryStep(),
                  _buildRashStep(),
                  _buildAngioedemaStep(),
                  _buildDiseasedHistoryStep(),
                  _buildMedicalHistoryStep(),
                  _buildPhysicalExamStep(),
                  _buildDiagnosisStep(),
                  _buildTreatmentStep(),
                  _buildCompletionStep(),
                ],
              ),
            ),
            // Navigation buttons
            BlocBuilder<ChronicInitialCubit, ChronicInitialState>(
              builder: (context, state) {
                final isSubmitting = state is ChronicInitialSubmitting;

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
                            backgroundColor: AppColors.primaryColor,
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
            title: 'Thông tin cơ bản của bệnh nhân',
            icon: Icons.person,
            color: AppColors.primaryColor,
          ),
          CustomTextField(
            label: 'Họ và tên',
            value: _record.fullName,
            onChanged: (value) => _record.fullName = value,
            isRequired: true,
          ),
          CustomTextField(
            label: 'Số căn cước công dân',
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
            label: 'Giới tính',
            value: _record.gender,
            options: const ['Nam', 'Nữ'],
            onChanged: (value) => setState(() => _record.gender = value),
          ),
          CustomTextField(
            label: 'Số điện thoại',
            value: _record.phoneNumber,
            onChanged: (value) => _record.phoneNumber = value,
            isRequired: true,
            keyboardType: TextInputType.phone,
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
            isRequired: true,
          ),
          CustomRadioGroup(
            label: 'Tiền sử tiếp xúc',
            value: _record.exposureHistory,
            options: const ['Hóa chất', 'Ánh sáng', 'Bụi', 'Khác', 'Không'],
            onChanged: (value) =>
                setState(() => _record.exposureHistory = value),
            isRequired: true,
          ),
          CustomTextField(
            label: 'Ngày mở hồ sơ',
            value: _record.recordOpenDate,
            onChanged: (value) => _record.recordOpenDate = value,
            hint: 'dd/mm/yyyy',
            keyboardType: TextInputType.datetime,
          ),
          CustomTextField(
            label: 'Ngày khám',
            value: _record.examinationDate,
            onChanged: (value) => _record.examinationDate = value,
            hint: 'dd/mm/yyyy',
            keyboardType: TextInputType.datetime,
          ),
        ],
      ),
    );
  }

  Widget _buildChronicUrticariaStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SectionHeader(
            title: 'Bệnh án mãn tính lần 1 - phần chung',
            icon: Icons.medical_services,
            color: AppColors.primaryColor,
          ),
          // CustomRadioGroup(
          //   label: 'Đợt bệnh ≥ 6 tuần',
          //   value: _record.continuousOutbreak6Weeks,
          //   options: const ['Có', 'Không'],
          //   onChanged: (value) =>
          //       setState(() => _record.continuousOutbreak6Weeks = value),
          // ),
          CustomRadioGroup(
            label: 'Loại tổn thương',
            value: _record.rashOrAngioedema,
            options: const ['Sẩn phù', 'Phù mạch', 'Cả hai'],
            onChanged: (value) =>
                setState(() => _record.rashOrAngioedema = value),
          ),
          CustomTextField(
            label: 'Lần đầu tổn thương từ bao nhiêu tuần',
            value: _record.firstOutbreakSinceWeeks,
            onChanged: (value) =>
                setState(() => _record.firstOutbreakSinceWeeks = value),
            keyboardType: TextInputType.number,
          ),
          CustomTextField(
            label: 'Số đợt bị mày đay (≥ 2 lần/tuần)',
            value: _record.outbreakCount,
            onChanged: (value) => setState(() => _record.outbreakCount = value),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  Widget _buildOutbreakHistoryStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SectionHeader(
            title: 'Lịch sử các đợt bệnh chi tiết',
            icon: Icons.history,
            color: AppColors.primaryColor,
          ),
          // Đợt 1
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue[200]!),
              borderRadius: BorderRadius.circular(8),
              color: Colors.blue[50],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Đợt 1',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Từ tháng',
                        value: _record.outbreak1StartMonth,
                        onChanged: (value) =>
                            setState(() => _record.outbreak1StartMonth = value),
                        keyboardType: TextInputType.number,
                        hint: '01-12',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomTextField(
                        label: 'Năm *',
                        value: _record.outbreak1StartYear,
                        onChanged: (value) =>
                            setState(() => _record.outbreak1StartYear = value),
                        keyboardType: TextInputType.number,
                        hint: 'YYYY',
                        isRequired: true,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Đến tháng',
                        value: _record.outbreak1EndMonth,
                        onChanged: (value) =>
                            setState(() => _record.outbreak1EndMonth = value),
                        keyboardType: TextInputType.number,
                        hint: '01-12',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomTextField(
                        label: 'Năm *',
                        value: _record.outbreak1EndYear,
                        onChanged: (value) =>
                            setState(() => _record.outbreak1EndYear = value),
                        keyboardType: TextInputType.number,
                        hint: 'YYYY',
                        isRequired: true,
                      ),
                    ),
                  ],
                ),
                CustomRadioGroup(
                  label: 'Có điều trị trong đợt hay không',
                  value: _record.outbreak1TreatmentReceived,
                  options: const ['Có', 'Không', 'Không nhớ'],
                  onChanged: (value) => setState(
                      () => _record.outbreak1TreatmentReceived = value),
                ),
                if (_record.outbreak1TreatmentReceived == 'Có') ...[
                  CustomRadioGroup(
                    label: 'Đáp ứng điều trị',
                    value: _record.outbreak1DrugResponse,
                    options: const [
                      'Khỏi hoàn toàn',
                      'Không khỏi',
                      'Giảm',
                      'Nặng lên'
                    ],
                    onChanged: (value) =>
                        setState(() => _record.outbreak1DrugResponse = value),
                  ),
                  if (_record.outbreak1DrugResponse == 'Giảm' ||
                      _record.outbreak1DrugResponse == 'Nặng lên')
                    CustomRadioGroup(
                      label: 'Triệu chứng giảm/nặng lên',
                      value: _record.outbreak1DrugResponseSymptom,
                      options: const ['Nốt đỏ', 'Ngứa', 'Cả hai'],
                      onChanged: (value) => setState(
                          () => _record.outbreak1DrugResponseSymptom = value),
                    ),
                ],
              ],
            ),
          ),

          // Đợt 2
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.orange[200]!),
              borderRadius: BorderRadius.circular(8),
              color: Colors.orange[50],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Đợt 2',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Từ tháng',
                        value: _record.outbreak2StartMonth,
                        onChanged: (value) =>
                            setState(() => _record.outbreak2StartMonth = value),
                        keyboardType: TextInputType.number,
                        hint: '01-12',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomTextField(
                        label: 'Năm',
                        value: _record.outbreak2StartYear,
                        onChanged: (value) =>
                            setState(() => _record.outbreak2StartYear = value),
                        keyboardType: TextInputType.number,
                        hint: 'YYYY',
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Đến tháng',
                        value: _record.outbreak2EndMonth,
                        onChanged: (value) =>
                            setState(() => _record.outbreak2EndMonth = value),
                        keyboardType: TextInputType.number,
                        hint: '01-12',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomTextField(
                        label: 'Năm',
                        value: _record.outbreak2EndYear,
                        onChanged: (value) =>
                            setState(() => _record.outbreak2EndYear = value),
                        keyboardType: TextInputType.number,
                        hint: 'YYYY',
                      ),
                    ),
                  ],
                ),
                CustomRadioGroup(
                  label: 'Có điều trị trong đợt hay không',
                  value: _record.outbreak2TreatmentReceived,
                  options: const ['Có', 'Không', 'Không nhớ'],
                  onChanged: (value) => setState(
                      () => _record.outbreak2TreatmentReceived = value),
                ),
                if (_record.outbreak2TreatmentReceived == 'Có') ...[
                  CustomRadioGroup(
                    label: 'Đáp ứng điều trị',
                    value: _record.outbreak2DrugResponse,
                    options: const [
                      'Khỏi hoàn toàn',
                      'Không khỏi',
                      'Giảm',
                      'Nặng lên'
                    ],
                    onChanged: (value) =>
                        setState(() => _record.outbreak2DrugResponse = value),
                  ),
                  if (_record.outbreak2DrugResponse == 'Giảm' ||
                      _record.outbreak2DrugResponse == 'Nặng lên')
                    CustomRadioGroup(
                      label: 'Triệu chứng giảm/nặng lên',
                      value: _record.outbreak2DrugResponseSymptom,
                      options: const ['Nốt đỏ', 'Ngứa', 'Cả hai'],
                      onChanged: (value) => setState(
                          () => _record.outbreak2DrugResponseSymptom = value),
                    ),
                ],
              ],
            ),
          ),

          // Đợt 3
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green[200]!),
              borderRadius: BorderRadius.circular(8),
              color: Colors.green[50],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Đợt 3',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Từ tháng',
                        value: _record.outbreak3StartMonth,
                        onChanged: (value) =>
                            setState(() => _record.outbreak3StartMonth = value),
                        keyboardType: TextInputType.number,
                        hint: '01-12',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomTextField(
                        label: 'Năm',
                        value: _record.outbreak3StartYear,
                        onChanged: (value) =>
                            setState(() => _record.outbreak3StartYear = value),
                        keyboardType: TextInputType.number,
                        hint: 'YYYY',
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Đến tháng',
                        value: _record.outbreak3EndMonth,
                        onChanged: (value) =>
                            setState(() => _record.outbreak3EndMonth = value),
                        keyboardType: TextInputType.number,
                        hint: '01-12',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomTextField(
                        label: 'Năm',
                        value: _record.outbreak3EndYear,
                        onChanged: (value) =>
                            setState(() => _record.outbreak3EndYear = value),
                        keyboardType: TextInputType.number,
                        hint: 'YYYY',
                      ),
                    ),
                  ],
                ),
                CustomRadioGroup(
                  label: 'Có điều trị trong đợt hay không',
                  value: _record.outbreak3TreatmentReceived,
                  options: const ['Có', 'Không', 'Không nhớ'],
                  onChanged: (value) => setState(
                      () => _record.outbreak3TreatmentReceived = value),
                ),
                if (_record.outbreak3TreatmentReceived == 'Có') ...[
                  CustomRadioGroup(
                    label: 'Đáp ứng điều trị',
                    value: _record.outbreak3DrugResponse,
                    options: const [
                      'Khỏi hoàn toàn',
                      'Không khỏi',
                      'Giảm',
                      'Nặng lên'
                    ],
                    onChanged: (value) =>
                        setState(() => _record.outbreak3DrugResponse = value),
                  ),
                  if (_record.outbreak3DrugResponse == 'Giảm' ||
                      _record.outbreak3DrugResponse == 'Nặng lên')
                    CustomRadioGroup(
                      label: 'Triệu chứng giảm/nặng lên',
                      value: _record.outbreak3DrugResponseSymptom,
                      options: const ['Nốt đỏ', 'Ngứa', 'Cả hai'],
                      onChanged: (value) => setState(
                          () => _record.outbreak3DrugResponseSymptom = value),
                    ),
                ],
              ],
            ),
          ),

          // Đợt hiện tại
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red[200]!),
              borderRadius: BorderRadius.circular(8),
              color: Colors.red[50],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Đợt hiện tại',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Từ tháng',
                        value: _record.currentOutbreakStartMonth,
                        onChanged: (value) => setState(() {
                          _record.currentOutbreakStartMonth = value;
                          _record.currentOutbreakWeeks = _calculateWeeksBetween(
                            _record.currentOutbreakStartMonth,
                            _record.currentOutbreakStartYear,
                            _record.currentOutbreakEndMonth,
                            _record.currentOutbreakEndYear,
                          ).toString();
                        }),
                        keyboardType: TextInputType.number,
                        hint: '01-12',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomTextField(
                        label: 'Năm *',
                        value: _record.currentOutbreakStartYear,
                        onChanged: (value) => setState(() {
                          _record.currentOutbreakStartYear = value;
                          _record.currentOutbreakWeeks = _calculateWeeksBetween(
                            _record.currentOutbreakStartMonth,
                            _record.currentOutbreakStartYear,
                            _record.currentOutbreakEndMonth,
                            _record.currentOutbreakEndYear,
                          ).toString();
                        }),
                        keyboardType: TextInputType.number,
                        hint: 'YYYY',
                        isRequired: true,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Đến tháng',
                        value: _record.currentOutbreakEndMonth,
                        onChanged: (value) => setState(() {
                          _record.currentOutbreakEndMonth = value;
                          _record.currentOutbreakWeeks = _calculateWeeksBetween(
                            _record.currentOutbreakStartMonth,
                            _record.currentOutbreakStartYear,
                            _record.currentOutbreakEndMonth,
                            _record.currentOutbreakEndYear,
                          ).toString();
                        }),
                        keyboardType: TextInputType.number,
                        hint: '01-12',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomTextField(
                        label: 'Năm *',
                        value: _record.currentOutbreakEndYear,
                        onChanged: (value) => setState(() {
                          _record.currentOutbreakEndYear = value;
                          _record.currentOutbreakWeeks = _calculateWeeksBetween(
                            _record.currentOutbreakStartMonth,
                            _record.currentOutbreakStartYear,
                            _record.currentOutbreakEndMonth,
                            _record.currentOutbreakEndYear,
                          ).toString();
                        }),
                        keyboardType: TextInputType.number,
                        hint: 'YYYY',
                        isRequired: true,
                      ),
                    ),
                  ],
                ),
                if (_record.currentOutbreakWeeks != null &&
                    _record.currentOutbreakWeeks!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Đợt này bạn bị: ${_record.currentOutbreakWeeks} tuần',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                CustomRadioGroup(
                  label: 'Có điều trị trong đợt hay không',
                  value: _record.currentTreatmentReceived,
                  options: const ['Có', 'Không', 'Không nhớ'],
                  onChanged: (value) =>
                      setState(() => _record.currentTreatmentReceived = value),
                ),
                if (_record.currentTreatmentReceived == 'Có') ...[
                  CustomRadioGroup(
                    label: 'Đáp ứng điều trị',
                    value: _record.currentDrugResponse,
                    options: const [
                      'Khỏi hoàn toàn',
                      'Không khỏi',
                      'Giảm',
                      'Nặng lên'
                    ],
                    onChanged: (value) =>
                        setState(() => _record.currentDrugResponse = value),
                  ),
                  if (_record.currentDrugResponse == 'Giảm' ||
                      _record.currentDrugResponse == 'Nặng lên')
                    CustomRadioGroup(
                      label: 'Triệu chứng giảm/nặng lên',
                      value: _record.currentDrugResponseSymptom,
                      options: const ['Nốt đỏ', 'Ngứa', 'Cả hai'],
                      onChanged: (value) => setState(
                          () => _record.currentDrugResponseSymptom = value),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRashStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SectionHeader(
            title: 'Sẩn phù',
            icon: Icons.healing,
            color: AppColors.primaryColor,
          ),
          CustomRadioGroup(
            label: 'Nốt đỏ xuất hiện khi nào?',
            value: _record.rashAppearanceTime,
            options: const [
              'Một cách ngẫu nhiên',
              'Khi có các yếu tố kích thích'
            ],
            onChanged: (value) =>
                setState(() => _record.rashAppearanceTime = value),
          ),
          if (_record.rashAppearanceTime == 'Khi có các yếu tố kích thích')
            CustomCheckboxGroup(
              label: 'Các yếu tố kích thích',
              selectedValues: _record.rashTriggerFactors ?? [],
              options: const [
                'Gãi, chà xát, sau tắm',
                'Ra mồ hôi, +/- vận động',
                'Không có mồ hôi, +/- ngâm tắm nước nóng',
                'Khi thời tiết lạnh + nhiệt lượng cơ thể tăng',
                'Mang vật nặng',
                'Tiếp xúc với đồ vật lạnh',
                'Tiếp xúc với ánh sáng',
                'Do rung',
                'Do các chất cụ thể'
              ],
              onChanged: (values) =>
                  setState(() => _record.rashTriggerFactors = values),
            ),
          CustomCheckboxGroup(
            label: 'Yếu tố làm nặng bệnh',
            selectedValues: _record.rashWorseningFactors ?? [],
            options: const ['Stress', 'Thức ăn', 'Chống viêm, giảm đau'],
            onChanged: (values) =>
                setState(() => _record.rashWorseningFactors = values),
          ),
          if (_record.rashWorseningFactors?.contains('Thức ăn') == true)
            CustomTextField(
              label: 'Chi tiết thức ăn gây nặng bệnh',
              value: _record.rashFoodTriggerDetail,
              onChanged: (value) => _record.rashFoodTriggerDetail = value,
            ),
          if (_record.rashWorseningFactors?.contains('Chống viêm, giảm đau') ==
              true)
            CustomTextField(
              label: 'Chi tiết thuốc gây nặng bệnh',
              value: _record.rashDrugTriggerDetail,
              onChanged: (value) => _record.rashDrugTriggerDetail = value,
            ),
          CustomMultipleChoiceWithImages(
            label: 'Vị trí nốt đỏ',
            selectedValues: _record.rashLocation ?? [],
            options: const [
              'Mặt',
              'Miệng',
              'Thân',
              'Bàn tay (chụp ảnh 2 bàn tay)',
              'Cẳng tay',
              'Cánh tay',
              'Sinh dục',
              'Đùi',
              'Cẳng chân',
              'Bàn chân (chụp ảnh 2 bàn chân)'
            ],
            subOptions: _faceSubOptions,
            imagePaths: _rashLocationImages,
            onChanged: (values) =>
                setState(() => _record.rashLocation = values),
            onImagesChanged: (images) =>
                setState(() => _rashLocationImages = images),
          ),
          CustomRadioGroup(
            label: 'Kích thước nốt đỏ khi dùng thuốc',
            value: _record.rashSizeOnTreatment,
            options: const ['<3mm', '3-10mm', '10-50mm', '>50mm'],
            onChanged: (value) =>
                setState(() => _record.rashSizeOnTreatment = value),
          ),
          CustomRadioGroup(
            label: 'Kích thước nốt đỏ khi không dùng thuốc',
            value: _record.rashSizeNoTreatment,
            options: const ['<3mm', '3-10mm', '10-50mm', '>50mm'],
            onChanged: (value) =>
                setState(() => _record.rashSizeNoTreatment = value),
          ),
          CustomRadioGroup(
            label: 'Ranh giới nốt đỏ',
            value: _record.rashBorder,
            options: const ['Có bờ', 'Không bờ'],
            onChanged: (value) => setState(() => _record.rashBorder = value),
          ),
          CustomRadioGroup(
            label: 'Hình dạng',
            value: _record.rashShape,
            options: const ['Tròn/Oval', 'Dài', 'Hình dạng khác'],
            onChanged: (value) => setState(() => _record.rashShape = value),
          ),
          CustomRadioGroup(
            label: 'Màu sắc',
            value: _record.rashColor,
            options: const [
              'Trùng màu da',
              'Đỏ hồng',
              'Trắng',
              'Xuất huyết (đỏ đậm, tím)',
              'Có quầng trắng xung quanh nốt đỏ'
            ],
            onChanged: (value) => setState(() => _record.rashColor = value),
          ),
          CustomRadioGroup(
            label: 'Thời gian tồn tại khi dùng thuốc',
            value: _record.rashDurationOnTreatment,
            options: const ['<1h', '1h-6h', '6h-12h', '12h-24h', 'Không biết'],
            onChanged: (value) =>
                setState(() => _record.rashDurationOnTreatment = value),
          ),
          CustomRadioGroup(
            label: 'Thời gian tồn tại khi không dùng thuốc',
            value: _record.rashDurationNoTreatment,
            options: const ['<1h', '1h-6h', '6h-12h', '12h-24h', 'Không biết'],
            onChanged: (value) =>
                setState(() => _record.rashDurationNoTreatment = value),
          ),
          CustomCheckboxGroup(
            label: 'Đặc điểm bề mặt',
            selectedValues: _record.rashSurface ?? [],
            options: const [
              'Có vảy',
              'Có mụn nước',
              'Có giãn mạch',
              'Không vảy',
              'Không mụn nước',
              'Không giãn mạch',
            ],
            onChanged: (values) => setState(() => _record.rashSurface = values),
          ),
          CustomRadioGroup(
            label: 'Thời điểm xuất hiện nốt đỏ trong ngày',
            value: _record.rashTimeOfDay,
            options: const [
              'Sáng',
              'Trưa',
              'Chiều',
              'Tối',
              'Đêm',
              'Không có thời điểm cụ thể'
            ],
            onChanged: (value) => setState(() => _record.rashTimeOfDay = value),
          ),
          CustomRadioGroup(
            label: 'Số lượng nốt đỏ trung bình/ngày',
            value: _record.rashCountPerDay,
            options: const ['0-20', '21-50', '>50'],
            onChanged: (value) =>
                setState(() => _record.rashCountPerDay = value),
          ),
          CustomRadioGroup(
            label: 'Cảm giác tại vị trí nốt đỏ',
            value: _record.rashSensation,
            options: const ['Ngứa', 'Bỏng rát', 'Tức', 'Đau'],
            onChanged: (value) => setState(() => _record.rashSensation = value),
          ),
        ],
      ),
    );
  }

  Widget _buildAngioedemaStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SectionHeader(
            title: 'Phù mạch',
            icon: Icons.face,
            color: AppColors.primaryColor,
          ),
          CustomTextField(
            label: 'Số lần bị sưng phù từ trước đến nay',
            value: _record.angioedemaCount,
            onChanged: (value) => _record.angioedemaCount = value,
            keyboardType: TextInputType.number,
          ),
          CustomMultipleChoiceWithImages(
            label: 'Vị trí sưng phù',
            selectedValues: _record.angioedemaLocation ?? [],
            options: const [
              'Mắt',
              'Môi',
              'Lưỡi',
              'Thanh quản',
              'Sinh dục',
              'Bàn tay',
              'Bàn chân',
              'Khác'
            ],
            imagePaths: _angioedemaLocationImages,
            onChanged: (values) =>
                setState(() => _record.angioedemaLocation = values),
            onImagesChanged: (images) =>
                setState(() => _angioedemaLocationImages = images),
          ),
          CustomCheckboxGroup(
            label: 'Đặc điểm bề mặt',
            selectedValues: _record.angioedemaSurface ?? [],
            options: const [
              'Có vảy',
              'Có mụn nước',
              'Có giãn mạch',
              'Không vảy',
              'Không mụn nước',
              'Không giãn mạch',
            ],
            onChanged: (values) =>
                setState(() => _record.angioedemaSurface = values),
          ),
          CustomRadioGroup(
            label: 'Thời gian tồn tại khi dùng thuốc',
            value: _record.angioedemaDurationOnTreatment,
            options: const [
              '<1h',
              '1h-6h',
              '6h-12h',
              '12h-24h',
              '24h-48h',
              '48h-72h',
              '>72h',
              'Không biết'
            ],
            onChanged: (value) =>
                setState(() => _record.angioedemaDurationOnTreatment = value),
          ),
          CustomRadioGroup(
            label: 'Thời gian tồn tại khi không dùng thuốc',
            value: _record.angioedemaDurationNoTreatment,
            options: const [
              '<1h',
              '1h-6h',
              '6h-12h',
              '12h-24h',
              '24h-48h',
              '48h-72h',
              '>72h',
              'Không biết'
            ],
            onChanged: (value) =>
                setState(() => _record.angioedemaDurationNoTreatment = value),
          ),
          CustomRadioGroup(
            label: 'Thời điểm xuất hiện sưng phù trong ngày',
            value: _record.angioedemaTimeOfDay,
            options: const [
              'Sáng',
              'Trưa',
              'Chiều',
              'Tối',
              'Đêm',
              'Không có thời điểm cụ thể'
            ],
            onChanged: (value) =>
                setState(() => _record.angioedemaTimeOfDay = value),
          ),
          CustomRadioGroup(
            label: 'Cảm giác tại vị trí sưng phù',
            value: _record.angioedemaSensation,
            options: const ['Ngứa', 'Bỏng rát', 'Tức', 'Đau'],
            onChanged: (value) =>
                setState(() => _record.angioedemaSensation = value),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDiseasedHistoryStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CustomRadioGroup(
          label:
              'Bạn đã bao giờ phải khám cấp cứu/nằm viện vì bệnh này hay chưa?',
          value: _record.emergencyVisitHistory,
          options: const ['Rồi', 'Chưa'],
          onChanged: (value) =>
              setState(() => _record.emergencyVisitHistory = value),
        ),
        CustomRadioGroup(
          label:
              'Bạn đã bao giờ bị khó thở trong đợt bệnh này (liên quan đến bệnh mề đay) hay chưa?',
          value: _record.breathingDifficultyHistory,
          options: const ['Có', 'Không'],
          onChanged: (value) =>
              setState(() => _record.breathingDifficultyHistory = value),
        ),
      ]),
    );
  }

  Widget _buildMedicalHistoryStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Tiền sử - Bệnh sử',
            icon: Icons.history_edu,
            color: AppColors.primaryColor,
          ),
          CustomTextField(
            label: 'Bệnh sử các đợt bệnh trước đây',
            value: _record.pastOutbreakHistory,
            onChanged: (value) => _record.pastOutbreakHistory = value,
            maxLines: 3,
            hint: 'Mô tả tự do',
          ),
          CustomRadioGroup(
            label: 'Đã từng điều trị trước đó',
            value: _record.previousTreatment,
            options: const ['Có', 'Không', 'Không rõ'],
            onChanged: (value) =>
                setState(() => _record.previousTreatment = value),
          ),
          CustomTextField(
            label:
                'Chi tiết thuốc, liều, thời gian, tuân thủ, đáp ứng điều trị',
            value: _record.previousTreatmentDetails,
            onChanged: (value) => _record.previousTreatmentDetails = value,
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          const Text(
            'Tiền sử cá nhân',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          CustomRadioGroup(
            label: 'Tiền sử mắc bệnh lý cơ địa (cá nhân)',
            value: _record.personalAtopyHistory,
            options: const ['Có', 'Không', 'Không rõ'],
            onChanged: (value) =>
                setState(() => _record.personalAtopyHistory = value),
          ),
          CustomRadioGroup(
            label: 'Tiền sử mắc bệnh tuyến giáp',
            value: _record.personalThyroidDiseaseHistory,
            options: const ['Có', 'Không', 'Không rõ'],
            onChanged: (value) =>
                setState(() => _record.personalThyroidDiseaseHistory = value),
          ),
          CustomRadioGroup(
            label: 'Tiền sử mắc bệnh tự miễn',
            value: _record.personalAutoimmuneHistory,
            options: const ['Có', 'Không', 'Không rõ'],
            onChanged: (value) =>
                setState(() => _record.personalAutoimmuneHistory = value),
          ),
          CustomTextField(
            label: 'Tiền sử mắc bệnh lý khác',
            value: _record.personalOtherDiseaseHistory,
            onChanged: (value) => _record.personalOtherDiseaseHistory = value,
            maxLines: 3,
          ),
          CustomTextField(
            label: 'Tiền sử dị ứng thuốc hoặc thức ăn',
            value: _record.personalDrugFoodAllergyHistory,
            onChanged: (value) =>
                _record.personalDrugFoodAllergyHistory = value,
            maxLines: 3,
          ),
          CustomRadioGroup(
            label: 'Tiền sử phản vệ',
            value: _record.personalAnaphylaxisHistory,
            options: const ['Có', 'Không', 'Không rõ'],
            onChanged: (value) =>
                setState(() => _record.personalAnaphylaxisHistory = value),
          ),
          const SizedBox(height: 24),
          const Text(
            'Tiền sử gia đình',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          CustomRadioGroup(
            label: 'Tiền sử gia đình mắc mày đay mạn tính',
            value: _record.familyChronicUrticariaHistory,
            options: const ['Có', 'Không', 'Không rõ'],
            onChanged: (value) =>
                setState(() => _record.familyChronicUrticariaHistory = value),
          ),
          CustomRadioGroup(
            label: 'Tiền sử gia đình mắc bệnh lý cơ địa',
            value: _record.familyAtopyHistory,
            options: const ['Có', 'Không', 'Không rõ'],
            onChanged: (value) =>
                setState(() => _record.familyAtopyHistory = value),
          ),
          CustomRadioGroup(
            label: 'Tiền sử gia đình mắc bệnh tự miễn',
            value: _record.familyAutoimmuneHistory,
            options: const ['Có', 'Không', 'Không rõ'],
            onChanged: (value) =>
                setState(() => _record.familyAutoimmuneHistory = value),
          ),
          CustomTextField(
            label: 'Chi tiết về bệnh của thành viên gia đình (nếu có)',
            value: _record.familyHistoryDetail,
            onChanged: (value) => _record.familyHistoryDetail = value,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildPhysicalExamStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Khám thực thể',
            icon: Icons.monitor_heart,
            color: AppColors.primaryColor,
          ),
          CustomRadioGroup(
            label: 'Có sốt hay không',
            value: _record.fever,
            options: const ['Có', 'Không', 'Không rõ'],
            onChanged: (value) => setState(() => _record.fever = value),
          ),
          if (_record.fever == 'Có')
            CustomTextField(
              label: 'Nhiệt độ cơ thể khi sốt (°C)',
              value: _record.feverTemperature,
              onChanged: (value) => _record.feverTemperature = value,
              keyboardType: TextInputType.number,
            ),
          CustomTextField(
            label: 'Mạch (lần/phút)',
            value: _record.pulseRate,
            onChanged: (value) => _record.pulseRate = value,
            keyboardType: TextInputType.number,
          ),
          CustomTextField(
            label: 'Huyết áp (mmHg)',
            value: _record.bloodPressure,
            onChanged: (value) => _record.bloodPressure = value,
            keyboardType: TextInputType.text,
            hint: 'Ví dụ: 120/80',
          ),
          CustomRadioGroup(
            label: 'Có bất thường cơ quan khác hay không',
            value: _record.organAbnormality,
            options: const ['Có', 'Không', 'Không rõ'],
            onChanged: (value) =>
                setState(() => _record.organAbnormality = value),
          ),
          if (_record.organAbnormality == 'Có')
            CustomTextField(
              label: 'Mô tả chi tiết bất thường cơ quan',
              value: _record.organAbnormalityDetail,
              onChanged: (value) => _record.organAbnormalityDetail = value,
              maxLines: 3,
            ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Chẩn đoán sơ bộ',
            value: _record.preliminaryDiagnosis,
            onChanged: (value) => _record.preliminaryDiagnosis = value,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosisStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SectionHeader(
            title: 'Kết quả test & Cận lâm sàng',
            icon: Icons.science,
            color: AppColors.primaryColor,
          ),
          // Test da vẽ nổi
          CustomRadioGroup(
            label: 'Kết quả da vẽ nổi (Dermatographism)',
            value: _record.dermatographismTest,
            options: const ['Dương tính', 'Âm tính'],
            onChanged: (val) =>
                setState(() => _record.dermatographismTest = val),
          ),
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
          const SizedBox(height: 16),
          // Test mày đay do lạnh - Temptest
          CustomRadioGroup(
            label: 'Mày đay do lạnh (Temptest)',
            value: _record.coldUrticariaTemptest,
            options: const ['Dương tính', 'Âm tính'],
            onChanged: (val) =>
                setState(() => _record.coldUrticariaTemptest = val),
          ),
          CustomTextField(
            label: 'Vùng nhiệt độ dương tính (°C)',
            value: _record.positiveTemperature,
            keyboardType: TextInputType.number,
            onChanged: (val) => _record.positiveTemperature = val,
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
          const SizedBox(height: 16),
          // Test mày đay do lạnh - Test cục đá
          CustomRadioGroup(
            label: 'Mày đay do lạnh - Test cục đá',
            value: _record.coldUrticariaIceTest,
            options: const ['Dương tính', 'Âm tính'],
            onChanged: (val) =>
                setState(() => _record.coldUrticariaIceTest = val),
          ),
          CustomTextField(
            label: 'Ngưỡng thời gian (phút)',
            value: _record.timeThreshold,
            keyboardType: TextInputType.number,
            onChanged: (val) => _record.timeThreshold = val,
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
          const SizedBox(height: 16),
          // Test mày đay do choline
          CustomRadioGroup(
            label: 'Mày đay do choline',
            value: _record.cholinergicUrticariaTest,
            options: const ['Dương tính', 'Âm tính'],
            onChanged: (val) =>
                setState(() => _record.cholinergicUrticariaTest = val),
          ),
          CustomTextField(
            label: 'Thời gian xuất hiện tổn thương (phút)',
            value: _record.lesionAppearanceTime,
            keyboardType: TextInputType.number,
            onChanged: (val) => _record.lesionAppearanceTime = val,
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
            label: 'Mức độ kiểm soát bệnh UCT',
            value: _record.uctScore,
            keyboardType: TextInputType.number,
            onChanged: (val) => _record.uctScore = val,
            hint: '0-16',
          ),
          CustomTextField(
            label: 'Mức độ kiểm soát bệnh ACT',
            value: _record.actScore,
            keyboardType: TextInputType.number,
            onChanged: (val) => _record.actScore = val,
          ),
          const SizedBox(height: 16),
          const Text(
            'Cận lâm sàng',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'WBC (G/L)',
            value: _record.wbc,
            onChanged: (value) => _record.wbc = value,
            keyboardType: TextInputType.number,
          ),
          CustomTextField(
            label: 'EO (%)',
            value: _record.eo,
            onChanged: (value) => _record.eo = value,
            keyboardType: TextInputType.number,
          ),
          CustomTextField(
            label: 'BA (%)',
            value: _record.ba,
            onChanged: (value) => _record.ba = value,
            keyboardType: TextInputType.number,
          ),
          CustomTextField(
            label: 'CRP (mg/L)',
            value: _record.crp,
            onChanged: (value) => _record.crp = value,
            keyboardType: TextInputType.number,
          ),
          CustomTextField(
            label: 'ESR (mm/h)',
            value: _record.esr,
            onChanged: (value) => _record.esr = value,
            keyboardType: TextInputType.number,
          ),
          CustomTextField(
            label: 'FT3 (pmol/L)',
            value: _record.ft3,
            onChanged: (value) => _record.ft3 = value,
            keyboardType: TextInputType.number,
          ),
          CustomTextField(
            label: 'FT4 (pmol/L)',
            value: _record.ft4,
            onChanged: (value) => _record.ft4 = value,
            keyboardType: TextInputType.number,
          ),
          CustomTextField(
            label: 'TSH (mIU/L)',
            value: _record.tsh,
            onChanged: (value) => _record.tsh = value,
            keyboardType: TextInputType.number,
          ),
          CustomTextField(
            label: 'Total IgE (kU/L)',
            value: _record.totalIgE,
            onChanged: (value) => _record.totalIgE = value,
            keyboardType: TextInputType.number,
          ),
          CustomTextField(
            label: 'Anti-TPO (IU/mL)',
            value: _record.antiTPO,
            onChanged: (value) => _record.antiTPO = value,
            keyboardType: TextInputType.number,
          ),
          CustomTextField(
            label: 'ANA Hep-2',
            value: _record.anaHep2,
            onChanged: (value) => _record.anaHep2 = value,
          ),
          CustomTextField(
            label: 'Mô hình lắng đọng',
            value: _record.depositionPattern,
            onChanged: (value) => _record.depositionPattern = value,
          ),
          CustomTextField(
            label: 'Siêu âm tuyến giáp',
            value: _record.thyroidUltrasound,
            onChanged: (value) => _record.thyroidUltrasound = value,
            maxLines: 2,
          ),
          CustomTextField(
            label: 'Test huyết thanh tự thân',
            value: _record.autologousSerumSkinTest,
            onChanged: (value) => _record.autologousSerumSkinTest = value,
          ),
          CustomTextField(
            label: 'Đường kính mối phù (mm)',
            value: _record.whealDiameter,
            onChanged: (value) => _record.whealDiameter = value,
            keyboardType: TextInputType.number,
          ),
          CustomTextField(
            label: 'Xét nghiệm khác',
            value: _record.otherLabTests,
            onChanged: (value) => _record.otherLabTests = value,
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Chẩn đoán xác định',
            value: _record.finalDiagnosis,
            onChanged: (value) => _record.finalDiagnosis = value,
            maxLines: 3,
            isRequired: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SectionHeader(
            title: 'Điều trị & Theo dõi',
            icon: Icons.medication,
            color: AppColors.primaryColor,
          ),
          CustomTextField(
            label: 'Thuốc điều trị',
            value: _record.treatmentMedications,
            onChanged: (value) => _record.treatmentMedications = value,
            maxLines: 4,
            hint: 'Ghi rõ tên thuốc, liều dùng, cách dùng',
            isRequired: true,
          ),
          CustomTextField(
            label: 'Hẹn khám lại',
            value: _record.followUpDate,
            onChanged: (value) => _record.followUpDate = value,
            hint: 'dd/mm/yyyy',
            keyboardType: TextInputType.datetime,
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
            color: AppColors.primaryColor,
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
                  'Thông tin bệnh án mãn tính lần 1 đã được hoàn thành',
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
                if (_record.finalDiagnosis != null)
                  Text(
                    'Chẩn đoán: ${_record.finalDiagnosis}',
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

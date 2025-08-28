import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urticaria/constant/color.dart';
import 'package:urticaria/cubit/auth/auth_cubit.dart';
import 'package:urticaria/feature/bottom_nav/bottom_nav_page.dart';
import 'package:urticaria/feature/medical_record_v2/cubits/acute_urticaria/acute_urticaria_cubit.dart';
import 'package:urticaria/feature/medical_record_v2/cubits/acute_urticaria/acute_urticaria_state.dart';
import 'package:urticaria/feature/medical_record_v2/screens/urticaria_form_selector_screen.dart';
import 'package:urticaria/utils/snack_bar.dart';
import '../models/acute_urticaria_record.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_radio_group.dart';
import '../widgets/custom_checkbox_group.dart';
import '../widgets/custom_multiple_choice_with_images.dart';
import '../widgets/image_upload_widget.dart';
import '../widgets/section_header.dart';

class AcuteUrticariaFormScreen extends StatefulWidget {
  const AcuteUrticariaFormScreen({Key? key}) : super(key: key);

  @override
  State<AcuteUrticariaFormScreen> createState() =>
      _AcuteUrticariaFormScreenState();
}

class _AcuteUrticariaFormScreenState extends State<AcuteUrticariaFormScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 8;

  final AcuteUrticariaRecord _record = AcuteUrticariaRecord();
  Map<String, List<String>> _rashLocationImages = {};
  Map<String, List<String>> _angioedemaLocationImages = {};

  final List<String> _stepTitles = [
    'Thông tin cơ bản',
    'Bệnh án cấp tính',
    'Sẩn phù',
    'Phù mạch',
    'Yếu tố khởi phát',
    'Khám thực thể',
    'Chẩn đoán & Xét nghiệm',
    'Điều trị & Hẹn tái khám',
  ];

  // Face sub-options for location selection
  final Map<String, List<String>> _faceSubOptions = {
    'Mặt': ['Mặt thẳng', 'Nghiêng trái', 'Nghiêng phải'],
  };

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

    context.read<AcuteUrticariaCubit>().submitForm(_record);
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Bệnh án cấp tính - ${_stepTitles[_currentStep]}',
          style:
              const TextStyle(color: AppColors.whiteColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
      ),
      body: BlocListener<AcuteUrticariaCubit, AcuteUrticariaState>(
        listener: (context, state) async {
          if (state is AcuteUrticariaSubmitted) {
            context.showSnackBarSuccess(
                text: "Tạo yêu cầu thành công", positionTop: true);
            await Future.delayed(Duration(seconds: 2));
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomNavPage(),
                ));
          } else if (state is AcuteUrticariaError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Column(
          children: [
            // Progress indicator
            Container(
              padding: const EdgeInsets.all(16),
              color: AppColors.whiteColor,
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
                  _buildAcuteUrticariaStep(),
                  _buildRashStep(),
                  _buildAngioedemaStep(),
                  _buildTriggerFactorsStep(),
                  _buildPhysicalExamStep(),
                ],
              ),
            ),
            // Navigation buttons
            BlocBuilder<AcuteUrticariaCubit, AcuteUrticariaState>(
              builder: (context, state) {
                final isSubmitting = state is AcuteUrticariaSubmitting;

                return Container(
                  padding: const EdgeInsets.all(16),
                  color: AppColors.whiteColor,
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
                            foregroundColor: AppColors.whiteColor,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: isSubmitting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.whiteColor),
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
        ],
      ),
    );
  }

  Widget _buildAcuteUrticariaStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SectionHeader(
            title: 'Bệnh án cấp tính - phần chung',
            icon: Icons.medical_services,
            color: AppColors.primaryColor,
          ),
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
                        onChanged: (value) => setState(() {
                          _record.outbreak1StartMonth = value;
                        }),
                        keyboardType: TextInputType.number,
                        hint: '01-12',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomTextField(
                        label: 'Năm *',
                        value: _record.outbreak1StartYear,
                        onChanged: (value) => setState(() {
                          _record.outbreak1StartYear = value;
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
                        value: _record.outbreak1EndMonth,
                        onChanged: (value) => setState(() {
                          _record.outbreak1EndMonth = value;
                        }),
                        keyboardType: TextInputType.number,
                        hint: '01-12',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomTextField(
                        label: 'Năm *',
                        value: _record.outbreak1EndYear,
                        onChanged: (value) => setState(() {
                          _record.outbreak1EndYear = value;
                        }),
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
              'Bàn tay',
              'Cẳng tay',
              'Cánh tay',
              'Sinh dục',
              'Đùi',
              'Cẳng chân',
              'Bàn chân'
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
        ],
      ),
    );
  }

  Widget _buildTriggerFactorsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SectionHeader(
            title: 'Yếu tố khởi phát & Tiền sử',
            icon: Icons.history,
            color: AppColors.primaryColor,
          ),
          const Text(
            'Yếu tố khởi phát',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          CustomRadioGroup(
            label: 'Triệu chứng nhiễm trùng',
            value: _record.triggerInfection,
            options: const ['Có', 'Không', 'Không biết'],
            onChanged: (value) =>
                setState(() => _record.triggerInfection = value),
          ),
          CustomRadioGroup(
            label: 'Thức ăn',
            value: _record.triggerFood,
            options: const ['Có', 'Không', 'Không biết'],
            onChanged: (value) => setState(() => _record.triggerFood = value),
          ),
          CustomRadioGroup(
            label: 'Thuốc',
            value: _record.triggerDrug,
            options: const ['Có', 'Không', 'Không biết'],
            onChanged: (value) => setState(() => _record.triggerDrug = value),
          ),
          CustomRadioGroup(
            label: 'Côn trùng đốt',
            value: _record.triggerInsectBite,
            options: const ['Có', 'Không', 'Không biết'],
            onChanged: (value) =>
                setState(() => _record.triggerInsectBite = value),
          ),
          CustomTextField(
            label: 'Khác (ghi rõ)',
            value: _record.triggerOther,
            onChanged: (value) => _record.triggerOther = value,
          ),
          const SizedBox(height: 24),
          const Text(
            'Tiền sử bản thân',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          CustomRadioGroup(
            label: 'Tiền sử dị ứng',
            value: _record.personalAllergyHistory,
            options: const ['Có', 'Không', 'Không biết'],
            onChanged: (value) =>
                setState(() => _record.personalAllergyHistory = value),
          ),
          CustomRadioGroup(
            label: 'Tiền sử dị ứng thuốc',
            value: _record.personalDrugHistory,
            options: const ['Có', 'Không', 'Không biết'],
            onChanged: (value) =>
                setState(() => _record.personalDrugHistory = value),
          ),
          CustomRadioGroup(
            label: 'Tiền sử mắc mày đay',
            value: _record.personalUrticariaHistory,
            options: const ['Có', 'Không', 'Không biết'],
            onChanged: (value) =>
                setState(() => _record.personalUrticariaHistory = value),
          ),
          CustomTextField(
            label: 'Tiền sử bệnh khác (ghi rõ)',
            value: _record.personalOtherHistory,
            onChanged: (value) => _record.personalOtherHistory = value,
          ),
        ],
      ),
    );
  }

  Widget _buildPhysicalExamStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SectionHeader(
            title: 'Khám thực thể',
            icon: Icons.monitor_heart,
            color: AppColors.primaryColor,
          ),
          CustomRadioGroup(
            label: 'Sốt',
            value: _record.fever,
            options: const ['Có', 'Không'],
            onChanged: (value) => setState(() => _record.fever = value),
          ),
          if (_record.fever == 'Có')
            CustomTextField(
              label: 'Nhiệt độ (°C)',
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
          ),
        ],
      ),
    );
  }
}

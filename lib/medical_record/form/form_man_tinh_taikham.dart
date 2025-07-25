import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widget/button.dart';
import '../common_admin_info_form.dart';
import '../patient/patient_cubit.dart';
import '../widgets/image_upload_widget.dart';

class FormManTinhTaiKham extends StatefulWidget {
  const FormManTinhTaiKham({super.key});

  @override
  State<FormManTinhTaiKham> createState() => _FormManTinhTaiKhamState();
}

class _FormManTinhTaiKhamState extends State<FormManTinhTaiKham> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final birthdayController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final evaluationController = TextEditingController();
  final symptomsController = TextEditingController();
  final historyController = TextEditingController();
  final currentTreatmentController = TextEditingController();
  final sideEffectsController = TextEditingController();
  final notesController = TextEditingController();

  String? selectedGender;
  List<String> images = [];
  List<String> selectedSymptoms = [];
  String? treatmentEffectiveness;
  String? currentSeverity;
  bool hasCurrentUrticaria = false;
  bool hasDrugAllergy = false;
  bool hasNewSymptoms = false;
  bool hasSideEffects = false;

  final List<String> followUpSymptoms = [
    'Cải thiện rõ rệt',
    'Cải thiện một phần',
    'Không thay đổi',
    'Nặng hơn',
    'Triệu chứng mới',
    'Tái phát',
    'Biến chứng',
    'Nhiễm trùng thứ phát',
  ];

  final List<String> effectivenessOptions = [
    'Rất hiệu quả - Triệu chứng giảm >75%',
    'Hiệu quả - Triệu chứng giảm 50-75%',
    'Hiệu quả một phần - Triệu chứng giảm 25-50%',
    'Ít hiệu quả - Triệu chứng giảm <25%',
    'Không hiệu quả - Không cải thiện',
    'Tệ hơn - Triệu chứng nặng hơn',
  ];

  final List<String> severityOptions = [
    'Nhẹ - Kiểm soát tốt',
    'Trung bình - Kiểm soát một phần',
    'Nặng - Khó kiểm soát',
    'Rất nặng - Không kiểm soát được',
  ];

  @override
  void initState() {
    super.initState();
    final profile = context.read<PatientProfileCubit>().state;
    nameController.text = profile.name;
    birthdayController.text = profile.birthday;
    addressController.text = profile.address;
  }

  @override
  void dispose() {
    nameController.dispose();
    birthdayController.dispose();
    addressController.dispose();
    phoneController.dispose();
    emailController.dispose();
    evaluationController.dispose();
    symptomsController.dispose();
    historyController.dispose();
    currentTreatmentController.dispose();
    sideEffectsController.dispose();
    notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      if (treatmentEffectiveness == null) {
        _showErrorSnackBar('Vui lòng đánh giá hiệu quả điều trị');
        return;
      }

      _showSuccessDialog();
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: Colors.green.shade600,
                size: 50,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Cập nhật bệnh án thành công!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Bệnh án tái khám đã được lưu vào hệ thống',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0066CC),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Hoàn thành',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const themeColor = Color(0xFF0066CC);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "Bệnh án mạn tính tái khám",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header
              _buildHeaderCard(),

              const SizedBox(height: 20),

              // Thông tin hành chính
              _buildAdminInfoSection(),

              const SizedBox(height: 20),

              // Đánh giá hiệu quả điều trị
              _buildTreatmentEvaluationSection(),

              const SizedBox(height: 20),

              // Tình trạng hiện tại
              _buildCurrentStatusSection(),

              const SizedBox(height: 20),

              // Triệu chứng hiện tại
              _buildCurrentSymptomsSection(),

              const SizedBox(height: 20),

              // Điều trị hiện tại
              _buildCurrentTreatmentSection(),

              const SizedBox(height: 20),

              // Tác dụng phụ
              _buildSideEffectsSection(),

              const SizedBox(height: 20),

              // Tiền sử mới
              _buildNewHistorySection(),

              const SizedBox(height: 20),

              // Upload ảnh
              _buildImageUploadSection(),

              const SizedBox(height: 20),

              // Ghi chú
              _buildNotesSection(),

              const SizedBox(height: 32),

              // Submit button
              _buildSubmitButton(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.shade600,
            Colors.green.shade400,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.refresh,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Bệnh án mạn tính tái khám',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Theo dõi tiến triển và đánh giá\nhiệu quả điều trị',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAdminInfoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.person,
                  color: Colors.blue.shade600,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Thông tin bệnh nhân',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CommonAdministrativeInfoForm(
            nameController: nameController,
            birthdayController: birthdayController,
            addressController: addressController,
            phoneController: phoneController,
            emailController: emailController,
            selectedGender: selectedGender,
            onGenderChanged: (value) => setState(() => selectedGender = value),
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentEvaluationSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.assessment,
                  color: Colors.green.shade600,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Đánh giá hiệu quả điều trị',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const Text(
                ' *',
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'So với lần khám trước, tình trạng bệnh của bạn như thế nào?',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          ...effectivenessOptions.map((option) {
            final isSelected = treatmentEffectiveness == option;
            return GestureDetector(
              onTap: () => setState(() => treatmentEffectiveness = option),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:
                      isSelected ? Colors.green.shade50 : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? Colors.green.shade300
                        : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? Colors.green.shade600
                              : Colors.grey.shade400,
                          width: 2,
                        ),
                        color: isSelected
                            ? Colors.green.shade600
                            : Colors.transparent,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 14,
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        option,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected
                              ? Colors.green.shade700
                              : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: 16),
          TextFormField(
            controller: evaluationController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Mô tả chi tiết về hiệu quả điều trị',
              hintText: 'Những thay đổi cụ thể bạn nhận thấy...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFF0066CC), width: 2),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              prefixIcon:
                  const Icon(Icons.description, color: Color(0xFF0066CC)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStatusSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.health_and_safety,
                  color: Colors.blue.shade600,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Mức độ nghiêm trọng hiện tại',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: severityOptions.map((severity) {
              final isSelected = currentSeverity == severity;
              return GestureDetector(
                onTap: () => setState(() => currentSeverity = severity),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.blue.shade600
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? Colors.blue.shade600
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Text(
                    severity,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          _buildSwitchTile(
            'Có tổn thương mày đay hiện tại không?',
            hasCurrentUrticaria,
            (value) => setState(() => hasCurrentUrticaria = value),
            Icons.healing,
            Colors.red.shade600,
          ),
          const SizedBox(height: 12),
          _buildSwitchTile(
            'Có từng bị dị ứng thuốc không?',
            hasDrugAllergy,
            (value) => setState(() => hasDrugAllergy = value),
            Icons.warning,
            Colors.orange.shade600,
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentSymptomsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.medical_services,
                  color: Colors.purple.shade600,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Triệu chứng hiện tại',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: followUpSymptoms.map((symptom) {
              final isSelected = selectedSymptoms.contains(symptom);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedSymptoms.remove(symptom);
                    } else {
                      selectedSymptoms.add(symptom);
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.purple.shade600
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isSelected
                          ? Colors.purple.shade600
                          : Colors.grey.shade300,
                      width: 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.purple.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected) ...[
                        const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        symptom,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: symptomsController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Mô tả chi tiết triệu chứng hiện tại',
              hintText: 'Những thay đổi so với lần khám trước...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFF0066CC), width: 2),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              prefixIcon:
                  const Icon(Icons.description, color: Color(0xFF0066CC)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentTreatmentSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.medication,
                  color: Colors.teal.shade600,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Điều trị hiện tại',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: currentTreatmentController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Thuốc và phương pháp điều trị hiện tại',
              hintText: 'Tên thuốc, liều dùng, tần suất sử dụng...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFF0066CC), width: 2),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              prefixIcon:
                  const Icon(Icons.medication_liquid, color: Color(0xFF0066CC)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSideEffectsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.warning_amber,
                  color: Colors.orange.shade600,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Tác dụng phụ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSwitchTile(
            'Có gặp tác dụng phụ từ thuốc không?',
            hasSideEffects,
            (value) => setState(() => hasSideEffects = value),
            Icons.report_problem,
            Colors.orange.shade600,
          ),
          if (hasSideEffects) ...[
            const SizedBox(height: 16),
            TextFormField(
              controller: sideEffectsController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Mô tả tác dụng phụ',
                hintText: 'Các triệu chứng bất thường bạn gặp phải...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color(0xFF0066CC), width: 2),
                ),
                filled: true,
                fillColor: Colors.orange.shade50,
                prefixIcon:
                    Icon(Icons.info_outline, color: Colors.orange.shade600),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNewHistorySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.history_edu,
                  color: Colors.indigo.shade600,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Tiền sử bệnh mới',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSwitchTile(
            'Có tiền sử bệnh mới phát sinh không?',
            hasNewSymptoms,
            (value) => setState(() => hasNewSymptoms = value),
            Icons.new_releases,
            Colors.indigo.shade600,
          ),
          if (hasNewSymptoms) ...[
            const SizedBox(height: 16),
            TextFormField(
              controller: historyController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Tiền sử bệnh mới (nếu có)',
                hintText: 'Các bệnh lý mới xuất hiện từ lần khám trước...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color(0xFF0066CC), width: 2),
                ),
                filled: true,
                fillColor: Colors.indigo.shade50,
                prefixIcon: Icon(Icons.medical_information,
                    color: Colors.indigo.shade600),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    bool value,
    Function(bool) onChanged,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: value ? color.withOpacity(0.1) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value ? color : Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: value ? color : Colors.grey.shade600,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: value ? FontWeight.w600 : FontWeight.normal,
                color: value ? color : Colors.black87,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: color,
          ),
        ],
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.photo_camera,
                  color: Colors.blue.shade600,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Hình ảnh so sánh',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Chụp ảnh hiện tại để so sánh với lần khám trước',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          ImageUploadWidget(
            imageUrls: images,
            onImagesChanged: (newImages) => setState(() => images = newImages),
            maxImages: 5,
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.note_add,
                  color: Colors.grey.shade700,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Ghi chú thêm',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: notesController,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Thông tin bổ sung',
              hintText:
                  'Các thông tin khác:\n• Mong muốn điều trị\n• Thắc mắc cần tư vấn\n• Kế hoạch tái khám...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFF0066CC), width: 2),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              alignLabelWithHint: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade600, Colors.green.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.update,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              'Cập nhật bệnh án tái khám',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

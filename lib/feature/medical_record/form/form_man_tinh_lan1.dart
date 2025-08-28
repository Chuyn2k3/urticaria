import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constant/color.dart';
import '../common_admin_info_form.dart';
import '../patient/patient_cubit.dart';
import '../widgets/image_upload_widget.dart';

class FormManTinhLan1 extends StatefulWidget {
  const FormManTinhLan1({super.key});

  @override
  State<FormManTinhLan1> createState() => _FormManTinhLan1State();
}

class _FormManTinhLan1State extends State<FormManTinhLan1> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final birthdayController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final symptomsController = TextEditingController();
  final historyController = TextEditingController();
  final onsetTimeController = TextEditingController();
  final frequencyController = TextEditingController();
  final medicationHistoryController = TextEditingController();
  final triggerFactorsController = TextEditingController();
  final notesController = TextEditingController();

  String? selectedGender;
  List<String> images = [];
  List<String> selectedSymptoms = [];
  String? selectedFrequency;
  String? selectedSeverity;
  bool hasCurrentUrticaria = false;
  bool hasDrugAllergy = false;
  bool hasOtherMedication = false;
  bool hasFamilyHistory = false;

  final List<String> chronicSymptoms = [
    'Ngứa kéo dài',
    'Mề đay tái phát',
    'Sưng phù mạn tính',
    'Da khô, bong tróc',
    'Thay đổi màu da',
    'Dày da, chai cứng',
    'Nhiễm trùng thứ phát',
    'Rối loạn giấc ngủ',
  ];

  final List<String> frequencyOptions = [
    'Hàng ngày',
    '3-4 lần/tuần',
    '1-2 lần/tuần',
    'Vài lần/tháng',
    'Theo mùa',
    'Không đều',
  ];

  final List<String> severityLevels = [
    'Nhẹ - Ít ảnh hưởng sinh hoạt',
    'Trung bình - Ảnh hưởng một phần',
    'Nặng - Ảnh hưởng nghiêm trọng',
    'Rất nặng - Không thể sinh hoạt bình thường',
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
    symptomsController.dispose();
    historyController.dispose();
    onsetTimeController.dispose();
    frequencyController.dispose();
    medicationHistoryController.dispose();
    triggerFactorsController.dispose();
    notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      if (selectedSymptoms.isEmpty) {
        _showErrorSnackBar('Vui lòng chọn ít nhất một triệu chứng');
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
            const Icon(Icons.error_outline, color: AppColors.whiteColor),
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
              'Tạo bệnh án thành công!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Bệnh án mạn tính lần 1 đã được lưu vào hệ thống',
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
                      color: AppColors.whiteColor, fontWeight: FontWeight.w600),
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
          "Bệnh án mạn tính lần 1",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: themeColor,
        foregroundColor: AppColors.whiteColor,
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

              // Triệu chứng mạn tính
              _buildSymptomsSection(),

              const SizedBox(height: 20),

              // Mức độ nghiêm trọng
              _buildSeveritySection(),

              const SizedBox(height: 20),

              // Thời gian và tần suất
              _buildTimeFrequencySection(),

              const SizedBox(height: 20),

              // Yếu tố kích thích
              _buildTriggerFactorsSection(),

              const SizedBox(height: 20),

              // Tiền sử và thuốc
              _buildMedicalHistorySection(),

              const SizedBox(height: 20),

              // Tình trạng hiện tại
              _buildCurrentStatusSection(),

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
            Colors.orange.shade600,
            Colors.orange.shade400,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
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
              color: AppColors.whiteColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.history,
              color: AppColors.whiteColor,
              size: 32,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Bệnh án mạn tính lần 1',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.whiteColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Dành cho bệnh nhân mày đay mạn tính\nlần đầu tiên đến khám',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.whiteColor.withOpacity(0.9),
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
        color: AppColors.whiteColor,
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

  Widget _buildSymptomsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
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
                  Icons.medical_services,
                  color: Colors.orange.shade600,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Triệu chứng mạn tính',
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
            'Chọn các triệu chứng mạn tính bạn đang gặp phải',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: chronicSymptoms.map((symptom) {
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
                        ? Colors.orange.shade600
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isSelected
                          ? Colors.orange.shade600
                          : Colors.grey.shade300,
                      width: 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.3),
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
                          color: AppColors.whiteColor,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        symptom,
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.whiteColor
                              : Colors.black87,
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
              labelText: 'Mô tả chi tiết triệu chứng',
              hintText:
                  'Vị trí xuất hiện, đặc điểm, thời điểm nặng nhất trong ngày...',
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

  Widget _buildSeveritySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
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
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.priority_high,
                  color: Colors.red.shade600,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Mức độ nghiêm trọng',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...severityLevels.map((level) {
            final isSelected = selectedSeverity == level;
            return GestureDetector(
              onTap: () => setState(() => selectedSeverity = level),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.red.shade50 : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        isSelected ? Colors.red.shade300 : Colors.grey.shade300,
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
                              ? Colors.red.shade600
                              : Colors.grey.shade400,
                          width: 2,
                        ),
                        color: isSelected
                            ? Colors.red.shade600
                            : Colors.transparent,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: AppColors.whiteColor,
                              size: 14,
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        level,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                          color:
                              isSelected ? Colors.red.shade700 : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTimeFrequencySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
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
                  Icons.schedule,
                  color: Colors.green.shade600,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Thời gian và tần suất',
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
            controller: onsetTimeController,
            decoration: InputDecoration(
              labelText: 'Thời gian khởi phát triệu chứng *',
              hintText: 'Ví dụ: 6 tháng trước, 1 năm trước...',
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
                  const Icon(Icons.access_time, color: Color(0xFF0066CC)),
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Vui lòng nhập thời gian khởi phát';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Text(
            'Tần suất xuất hiện triệu chứng',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: frequencyOptions.map((frequency) {
              final isSelected = selectedFrequency == frequency;
              return GestureDetector(
                onTap: () => setState(() => selectedFrequency = frequency),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.green.shade600
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? Colors.green.shade600
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Text(
                    frequency,
                    style: TextStyle(
                      color: isSelected ? AppColors.whiteColor : Colors.black87,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTriggerFactorsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
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
                  Icons.warning_amber,
                  color: Colors.purple.shade600,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Yếu tố kích thích',
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
            controller: triggerFactorsController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Yếu tố có thể gây kích thích',
              hintText:
                  'Ví dụ: Thức ăn, thuốc, thời tiết, stress, vật liệu tiếp xúc...',
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
                  const Icon(Icons.info_outline, color: Color(0xFF0066CC)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalHistorySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
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
                'Tiền sử bệnh và thuốc',
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
            controller: historyController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Tiền sử bệnh/tình trạng khác',
              hintText: 'Các bệnh lý khác, phẫu thuật, tai nạn...',
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
              prefixIcon: const Icon(Icons.medical_information,
                  color: Color(0xFF0066CC)),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: medicationHistoryController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Thuốc đã sử dụng trước đây',
              hintText: 'Tên thuốc, liều dùng, hiệu quả, tác dụng phụ...',
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
                  const Icon(Icons.medication, color: Color(0xFF0066CC)),
            ),
          ),
          const SizedBox(height: 16),
          _buildSwitchTile(
            'Có tiền sử gia đình bị mày đay',
            hasFamilyHistory,
            (value) => setState(() => hasFamilyHistory = value),
            Icons.family_restroom,
            Colors.indigo.shade600,
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStatusSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
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
                  Icons.health_and_safety,
                  color: Colors.teal.shade600,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Tình trạng hiện tại',
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
          const SizedBox(height: 12),
          _buildSwitchTile(
            'Hiện đang sử dụng thuốc điều trị khác?',
            hasOtherMedication,
            (value) => setState(() => hasOtherMedication = value),
            Icons.medication_liquid,
            Colors.blue.shade600,
          ),
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
        color: AppColors.whiteColor,
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
                'Hình ảnh triệu chứng',
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
            'Chụp ảnh vùng da bị ảnh hưởng để theo dõi tiến triển bệnh',
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
        color: AppColors.whiteColor,
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
                  'Các thông tin khác mà bạn muốn bác sĩ biết:\n• Ảnh hưởng đến công việc, học tập\n• Tác động tâm lý\n• Mong muốn điều trị...',
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
          colors: [Colors.orange.shade600, Colors.orange.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
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
              Icons.save,
              color: AppColors.whiteColor,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              'Lưu bệnh án mạn tính lần 1',
              style: TextStyle(
                color: AppColors.whiteColor,
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

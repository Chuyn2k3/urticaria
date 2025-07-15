// File: forms/form_man_tinh_lan1.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../common_admin_info_form.dart';
import '../patient/patient_cubit.dart';

class FormManTinhLan1 extends StatefulWidget {
  const FormManTinhLan1({super.key});

  @override
  State<FormManTinhLan1> createState() => _FormManTinhLan1State();
}

class _FormManTinhLan1State extends State<FormManTinhLan1> {
  final nameController = TextEditingController();
  final birthdayController = TextEditingController();
  final addressController = TextEditingController();
  final symptomsController = TextEditingController();
  final historyController = TextEditingController();
  final onsetTimeController = TextEditingController();
  final frequencyController = TextEditingController();
  final medicationHistoryController = TextEditingController();

  bool hasCurrentUrticaria = false;
  bool hasDrugAllergy = false;
  bool hasOtherMedication = false;

  void _submit() {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đã lưu bệnh án mạn tính lần 1.")));
    Navigator.pop(context);
  }

  @override
  void initState() {
    final profile = context.read<PatientProfileCubit>().state;
    nameController.text = profile.name;
    birthdayController.text = profile.birthday;
    addressController.text = profile.address;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF0066CC);
    return BlocProvider(
      create: (context) => PatientProfileCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Bệnh án mạn tính lần 1"),
          backgroundColor: themeColor,
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              CommonAdministrativeInfoForm(
                nameController: nameController,
                birthdayController: birthdayController,
                addressController: addressController,
              ),
              const SizedBox(height: 24),
              Text('Thông tin bệnh',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: themeColor)),
              const SizedBox(height: 8),
              _buildInput('Triệu chứng hiện tại', symptomsController,
                  maxLines: 3, color: themeColor),
              const SizedBox(height: 8),
              _buildInput('Tiền sử bệnh/tình trạng khác', historyController,
                  maxLines: 3, color: themeColor),
              const SizedBox(height: 8),
              _buildInput(
                  'Thời gian khởi phát triệu chứng', onsetTimeController,
                  color: themeColor),
              const SizedBox(height: 8),
              _buildInput('Tần suất xuất hiện triệu chứng', frequencyController,
                  color: themeColor),
              const SizedBox(height: 8),
              _buildInput(
                  'Thuốc đã sử dụng trước đây', medicationHistoryController,
                  color: themeColor),
              SwitchListTile(
                title: const Text('Có tổn thương mày đay hiện tại không?'),
                value: hasCurrentUrticaria,
                onChanged: (v) => setState(() => hasCurrentUrticaria = v),
                activeColor: themeColor,
              ),
              CheckboxListTile(
                title: const Text('Có từng bị dị ứng thuốc không?'),
                value: hasDrugAllergy,
                onChanged: (v) => setState(() => hasDrugAllergy = v ?? false),
                activeColor: themeColor,
              ),
              SwitchListTile(
                title: const Text('Hiện đang sử dụng thuốc điều trị khác?'),
                value: hasOtherMedication,
                onChanged: (v) => setState(() => hasOtherMedication = v),
                activeColor: themeColor,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Lưu bệnh án mạn tính lần 1",
                      style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller,
      {int maxLines = 1, required Color color}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}

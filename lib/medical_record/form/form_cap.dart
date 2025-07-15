// File: forms/form_cap.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widget/button.dart';
import '../common_admin_info_form.dart';
import '../patient/patient_cubit.dart';

class FormCap extends StatefulWidget {
  const FormCap({super.key});

  @override
  State<FormCap> createState() => _FormCapState();
}

class _FormCapState extends State<FormCap> {
  final nameController = TextEditingController();
  final birthdayController = TextEditingController();
  final addressController = TextEditingController();
  final symptomsController = TextEditingController();
  final historyController = TextEditingController();

  bool hasCurrentUrticaria = false;
  bool hasDrugAllergy = false;

  void _submit() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Đã lưu bệnh án cấp.")),
    );
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
    final themeColor =
        const Color(0xFF0066CC); // Màu xanh dương logo Bệnh viện Da liễu
    return BlocProvider(
      create: (context) => PatientProfileCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Bệnh án cấp"),
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
              const SizedBox(height: 24),
              SaveButton(
                onPressed: _submit,
                title: "Lưu bệnh án cấp",
                color: themeColor,
              ),
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: themeColor,
              //       padding: const EdgeInsets.symmetric(vertical: 14),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(12),
              //       ),
              //     ),
              //     onPressed: _submit,
              //     child: const Text("Lưu bệnh án cấp",
              //         style: TextStyle(color: Colors.white)),
              //   ),
              // )
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

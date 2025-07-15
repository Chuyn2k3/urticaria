// File: forms/form_man_tinh_taikham.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widget/button.dart';
import '../common_admin_info_form.dart';
import '../patient/patient_cubit.dart';

class FormManTinhTaiKham extends StatefulWidget {
  const FormManTinhTaiKham({super.key});

  @override
  State<FormManTinhTaiKham> createState() => _FormManTinhTaiKhamState();
}

class _FormManTinhTaiKhamState extends State<FormManTinhTaiKham> {
  final nameController = TextEditingController();
  final birthdayController = TextEditingController();
  final addressController = TextEditingController();
  final evaluationController = TextEditingController();
  final symptomsController = TextEditingController();
  final historyController = TextEditingController();

  bool hasCurrentUrticaria = false;
  bool hasDrugAllergy = false;

  void _submit() {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đã lưu bệnh án mạn tính tái khám.")));
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
          title: const Text("Bệnh án mạn tính tái khám"),
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
              Text('Đánh giá điều trị & tình trạng hiện tại',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: themeColor)),
              const SizedBox(height: 8),
              _buildInput(
                  'Đánh giá hiệu quả điều trị trước đây', evaluationController,
                  maxLines: 3, color: themeColor),
              const SizedBox(height: 8),
              _buildInput('Triệu chứng hiện tại', symptomsController,
                  maxLines: 3, color: themeColor),
              const SizedBox(height: 8),
              _buildInput('Tiền sử bệnh mới (nếu có)', historyController,
                  maxLines: 3, color: themeColor),
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
                title: "Lưu bệnh án mạn tính tái khám",
                onPressed: _submit,
                color: themeColor,
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

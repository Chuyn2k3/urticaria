// File: widgets/common_admin_info_form.dart
import 'package:flutter/material.dart';

class CommonAdministrativeInfoForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController birthdayController;
  final TextEditingController addressController;

  const CommonAdministrativeInfoForm({
    super.key,
    required this.nameController,
    required this.birthdayController,
    required this.addressController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Thông tin hành chính',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _buildInput('Họ và tên', nameController),
        const SizedBox(height: 8),
        _buildInput('Năm sinh', birthdayController,
            keyboardType: TextInputType.number),
        const SizedBox(height: 8),
        _buildInput('Địa chỉ', addressController),
      ],
    );
  }

  Widget _buildInput(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}

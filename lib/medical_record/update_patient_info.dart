import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urticaria/medical_record/patient/patient_cubit.dart';
import '../widget/button.dart';

class UpdatePatientProfileScreen extends StatefulWidget {
  const UpdatePatientProfileScreen({super.key});

  @override
  State<UpdatePatientProfileScreen> createState() =>
      _UpdatePatientProfileScreenState();
}

class _UpdatePatientProfileScreenState
    extends State<UpdatePatientProfileScreen> {
  final nameController = TextEditingController();
  final birthdayController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void initState() {
    final state = context.read<PatientProfileCubit>().state;
    nameController.text = state.name;
    birthdayController.text = state.birthday;
    addressController.text = state.address;
    super.initState();
  }

  void _save() {
    context.read<PatientProfileCubit>().updateProfile(
          name: nameController.text.trim(),
          birthday: birthdayController.text.trim(),
          address: addressController.text.trim(),
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF0066CC);

    return BlocProvider(
      create: (context) => PatientProfileCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Cập nhật thông tin cá nhân'),
          backgroundColor: themeColor,
          foregroundColor: Colors.white,
          //automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildInput('Họ tên', nameController, themeColor),
              const SizedBox(height: 12),
              _buildInput('Năm sinh', birthdayController, themeColor,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              _buildInput('Địa chỉ', addressController, themeColor),
              const Spacer(),
              SaveButton(
                title: "Lưu thông tin cá nhân",
                onPressed: _save,
                color: themeColor,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(
      String label, TextEditingController controller, Color color,
      {TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
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

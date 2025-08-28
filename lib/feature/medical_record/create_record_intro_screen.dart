// File: create_record_intro_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urticaria/feature/medical_record/patient/patient_cubit.dart';
import '../../constant/color.dart';
import '../../enum/record_type.dart';
import 'create_record_form_screen.dart';

class CreateRecordIntroScreen extends StatefulWidget {
  const CreateRecordIntroScreen({super.key});

  @override
  State<CreateRecordIntroScreen> createState() =>
      _CreateRecordIntroScreenState();
}

class _CreateRecordIntroScreenState extends State<CreateRecordIntroScreen> {
  final _durationController = TextEditingController();
  int currentStep = 0;
  bool hasFrequentSymptoms = false;
  bool isReturningVisit = false;

  void _handleStep1() {
    final durationText = _durationController.text.trim();
    if (durationText.isEmpty || int.tryParse(durationText) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập số tuần bị bệnh")),
      );
      return;
    }

    final durationWeeks = int.parse(durationText);

    if (durationWeeks < 6) {
      _navigate(RecordType.cap);
    } else {
      setState(() => currentStep = 1);
    }
  }

  void _handleStep2() {
    final type =
        isReturningVisit ? RecordType.manTinhTaiKham : RecordType.manTinhLan1;
    _navigate(type);
  }

  void _navigate(RecordType type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateRecordFormScreen(recordType: type),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF0066CC);
    return BlocProvider(
      create: (context) => PatientProfileCubit(),
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          title: const Text('Tạo bệnh án mới'),
          backgroundColor: themeColor,
          foregroundColor: AppColors.whiteColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: currentStep == 0
              ? _buildStep1(themeColor)
              : _buildStep2(themeColor),
        ),
      ),
    );
  }

  Widget _buildStep1(Color themeColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Bạn bị bệnh bao lâu rồi? (tính theo tuần)',
            style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
          controller: _durationController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            hintText: 'Ví dụ: 2, 5, 10',
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: themeColor, width: 1.5),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text('Triệu chứng có xuất hiện >= 3 ngày/tuần không?',
            style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        SwitchListTile(
          value: hasFrequentSymptoms,
          onChanged: (v) => setState(() => hasFrequentSymptoms = v),
          title: const Text('Có triệu chứng thường xuyên'),
          activeColor: themeColor,
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _handleStep1,
            style: ElevatedButton.styleFrom(
              backgroundColor: themeColor,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Tiếp tục',
                style: TextStyle(color: AppColors.whiteColor)),
          ),
        )
      ],
    );
  }

  Widget _buildStep2(Color themeColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Bạn đã từng khám bệnh này trước đây chưa?',
            style: TextStyle(fontSize: 16)),
        const SizedBox(height: 16),
        RadioListTile<bool>(
          title: const Text('Chưa, đây là lần đầu'),
          value: false,
          groupValue: isReturningVisit,
          onChanged: (v) => setState(() => isReturningVisit = v ?? false),
          activeColor: themeColor,
        ),
        RadioListTile<bool>(
          title: const Text('Rồi, tôi đã từng khám trước đó'),
          value: true,
          groupValue: isReturningVisit,
          onChanged: (v) => setState(() => isReturningVisit = v ?? true),
          activeColor: themeColor,
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _handleStep2,
            style: ElevatedButton.styleFrom(
              backgroundColor: themeColor,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Tiếp tục',
                style: TextStyle(color: AppColors.whiteColor)),
          ),
        )
      ],
    );
  }
}

// File: screens/create_record_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urticaria/medical_record/patient/patient_cubit.dart';
import '../enum/record_type.dart';
import 'form/form_cap.dart';
import 'form/form_man_tinh_lan1.dart';
import 'form/form_man_tinh_taikham.dart';

class CreateRecordFormScreen extends StatelessWidget {
  const CreateRecordFormScreen({super.key, required this.recordType});
  final RecordType recordType;
  @override
  Widget build(BuildContext context) {
    Widget form;
    switch (recordType) {
      case RecordType.cap:
        form = const FormCap();
        break;
      case RecordType.manTinhLan1:
        form = const FormManTinhLan1();
        break;
      case RecordType.manTinhTaiKham:
        form = const FormManTinhTaiKham();
        break;
    }

    return BlocProvider(
      create: (context) => PatientProfileCubit(),
      child: Scaffold(
        //appBar: AppBar(title: Text(recordType.displayName)),
        body: form,
      ),
    );
  }
}

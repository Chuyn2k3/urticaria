import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urticaria/core/repositories/appointment_repository.dart';
import 'package:urticaria/feature/medical_record_v2/screens/medical_form_screen.dart';
import 'package:urticaria/models/appointment/appointment_request.dart';
import 'package:urticaria/utils/snack_bar.dart';

import '../../../constant/color.dart';
import '../../../cubit/appointment/appointment_cubit.dart';
import '../../../utils/validator.dart';
import '../../../widget/appbar/custom_app_bar.dart';
import '../../../widget/button/primary_button.dart';
import '../../../widget/text_field/input_text_field.dart';

class ClassificationScreen extends StatelessWidget {
  const ClassificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppointmentCubit(),
      child: const ClassificationView(),
    );
  }
}

class ClassificationView extends StatefulWidget {
  const ClassificationView({super.key});

  @override
  State<ClassificationView> createState() => _ClassificationViewState();
}

class _ClassificationViewState extends State<ClassificationView> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _reasonCtrl = TextEditingController();

  bool? everVisited;
  bool? hasContinuousAttack;
  bool? isFirstTimeOver6Weeks;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _reasonCtrl.dispose();
    super.dispose();
  }

  /// Xác định templateId dựa trên câu trả lời
  /// Xác định templateId dựa trên câu trả lời
  /// Cấp tính = 16, Mạn tính lần 1 = 17, Mạn tính tái khám = 18
  int classifyTemplateId() {
    // Câu 2: Không -> Cấp tính
    if (hasContinuousAttack == false) {
      return 16;
    }

    // Câu 2: Có
    if (hasContinuousAttack == true) {
      // Câu 1: Không -> Mạn tính lần 1
      if (everVisited == false) {
        return 17;
      }

      // Câu 1: Có -> phải xét câu 3
      if (everVisited == true) {
        if (isFirstTimeOver6Weeks == true) return 17; // Mạn tính lần 1
        if (isFirstTimeOver6Weeks == false) return 18; // Mạn tính tái khám
      }
    }

    // Mặc định (phòng lỗi)
    return 16;
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    // Bắt buộc Câu 1 và Câu 2
    if (everVisited == null || hasContinuousAttack == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng trả lời đầy đủ các câu hỏi")),
      );
      return;
    }

    // Nếu Câu 2 = Có và Câu 1 = Có thì mới cần Câu 3
    if (hasContinuousAttack == true &&
        everVisited == true &&
        isFirstTimeOver6Weeks == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng trả lời đầy đủ các câu hỏi")),
      );
      return;
    }

    final request = AppointmentRequest(
      reason: _reasonCtrl.text.trim(),
      appointmentDate: DateTime.now().toIso8601String(),
      status: "PENDING",
      fullName: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      notes: "Phân loại từ câu hỏi",
      customInfo: {
        "everVisited": everVisited,
        "hasContinuousAttack": hasContinuousAttack,
        "isFirstTimeOver6Weeks":
            (everVisited == true && hasContinuousAttack == true)
                ? isFirstTimeOver6Weeks
                : null,
      },
    );

    context.read<AppointmentCubit>().createAppointment(request);
  }

  Widget _buildQuestion({
    required String title,
    required bool? groupValue,
    required Function(bool?) onChanged,
  }) {
    return Card(
      color: AppColors.whiteColor,
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text("Có"),
                    value: true,
                    activeColor: Colors.blue,
                    groupValue: groupValue,
                    onChanged: onChanged,
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text("Không"),
                    value: false,
                    activeColor: Colors.blue,
                    groupValue: groupValue,
                    onChanged: onChanged,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppointmentCubit, AppointmentState>(
      listener: (context, state) {
        if (state is AppointmentFailure) {
          context.showSnackBarFail(
            text: "❌ Lỗi khi tạo hẹn khám",
            positionTop: true,
          );
        }
        if (state is AppointmentSuccess) {
          final templateId = classifyTemplateId();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MedicalFormScreen(
                templateId: templateId,
                appointmentId: state.appointment.id,
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AppointmentLoading;

        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: CustomAppbar.basic(
            onTap: () => Navigator.pop(context),
            widgetTitle: const Text(
              'Phân loại bệnh án',
              style: TextStyle(
                  color: AppColors.whiteColor, fontWeight: FontWeight.bold),
            ),
            backgroundColor: AppColors.primaryColor,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Câu hỏi phân loại",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue)),
                  _buildQuestion(
                    title:
                        "1. Bạn đã từng khám ở phòng khám mày đay BV da liễu TW chưa?",
                    groupValue: everVisited,
                    onChanged: (val) => setState(() => everVisited = val),
                  ),
                  _buildQuestion(
                    title:
                        "2. Bạn đã có đợt nào bị liên tục ≥ 6 tuần chưa (≥ 2 lần/tuần)?",
                    groupValue: hasContinuousAttack,
                    onChanged: (val) =>
                        setState(() => hasContinuousAttack = val),
                  ),
                  if (everVisited == true && hasContinuousAttack == true)
                    _buildQuestion(
                      title:
                          "3. Đây có phải lần đầu bạn bị liên tục > 6 tuần không?",
                      groupValue: isFirstTimeOver6Weeks,
                      onChanged: (val) =>
                          setState(() => isFirstTimeOver6Weeks = val),
                    ),

                  const SizedBox(height: 16),
                  const Divider(),
                  const Text("Thông tin đặt lịch",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue)),
                  const SizedBox(height: 8),

                  /// Họ tên
                  InputTextField(
                    label: "Họ tên",
                    textController: _nameCtrl,
                    validator: (val) => Validator.validateString(
                      str: val ?? "",
                      name: "Họ tên",
                      minLength: 0,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 12),

                  /// Số điện thoại
                  InputTextField(
                    label: "Số điện thoại",
                    textController: _phoneCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 10,
                    validator: (val) =>
                        Validator.validatePhoneNumber(val ?? ""),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 12),

                  /// Lý do khám
                  InputTextField(
                    label: "Lý do khám",
                    textController: _reasonCtrl,
                    minLine: 3,
                    maxLine: 5,
                    validator: (val) => Validator.validateString(
                      str: val ?? "",
                      name: "Lý do khám",
                      minLength: 3,
                    ),
                    textAlign: TextAlign.left,
                  ),

                  const SizedBox(height: 24),

                  /// Nút xác nhận
                  Center(
                    child: PrimaryButton.icon(
                      label: isLoading ? "Đang xử lý..." : "Xác nhận",
                      iconData: isLoading ? null : Icons.check,
                      isLoading: isLoading,
                      onPressed: isLoading ? null : () => _submit(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

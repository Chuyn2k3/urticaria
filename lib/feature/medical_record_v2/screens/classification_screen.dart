import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urticaria/core/repositories/appointment_repository.dart';
import 'package:urticaria/feature/medical_record_v2/screens/medical_form_screen.dart';
import 'package:urticaria/models/appointment/appointment_request.dart';

/// Lưu câu trả lời 3 câu hỏi
class ClassificationAnswers {
  bool? hasExamBefore; // Đã từng khám?
  bool? hasContinuousEpisode; // Có đợt liên tục >= 6 tuần?
  bool? isFirstContinuousEpisode; // Đây có phải lần đầu đợt liên tục?

  ClassificationAnswers({
    this.hasExamBefore,
    this.hasContinuousEpisode,
    this.isFirstContinuousEpisode,
  });

  bool get isCompleted =>
      hasExamBefore != null &&
      hasContinuousEpisode != null &&
      isFirstContinuousEpisode != null;
}

/// Hàm xác định templateId dựa trên câu trả lời
int classifyTemplateId(ClassificationAnswers answers) {
  if (!answers.hasExamBefore! && !answers.hasContinuousEpisode!) {
    return 16; // Cấp tính
  }
  if (!answers.hasExamBefore! && answers.hasContinuousEpisode!) {
    return 17; // Mạn tính lần 1
  }
  if (answers.hasExamBefore! && !answers.hasContinuousEpisode!) {
    return 16; // Cấp tính
  }
  if (answers.hasExamBefore! &&
      answers.hasContinuousEpisode! &&
      answers.isFirstContinuousEpisode!) {
    return 17; // Mạn tính lần 1
  }
  if (answers.hasExamBefore! &&
      answers.hasContinuousEpisode! &&
      !answers.isFirstContinuousEpisode!) {
    return 18; // Mạn tính tái khám
  }
  return 16;
}

class ClassificationScreen extends StatefulWidget {
  const ClassificationScreen({super.key});

  @override
  State<ClassificationScreen> createState() => _ClassificationScreenState();
}

class _ClassificationScreenState extends State<ClassificationScreen> {
  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _reasonCtrl = TextEditingController();

  // Phân loại câu trả lời
  bool? everVisited;
  bool? hasContinuousAttack;
  bool? isFirstTimeOver6Weeks;

  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _reasonCtrl.dispose();
    super.dispose();
  }

  int classifyTemplateId() {
    // Cấp tính = 16, Mạn tính lần 1 = 17, Mạn tính tái khám = 18
    if (everVisited == false && hasContinuousAttack == false) {
      return 16; // Cấp tính
    }
    if ((everVisited == false && hasContinuousAttack == true) ||
        (everVisited == true &&
            hasContinuousAttack == true &&
            isFirstTimeOver6Weeks == true)) {
      return 17; // Mạn tính lần 1
    }
    if (everVisited == true &&
        hasContinuousAttack == true &&
        isFirstTimeOver6Weeks == false) {
      return 18; // Mạn tính tái khám
    }
    // Default fallback
    return 16;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (everVisited == null ||
        hasContinuousAttack == null ||
        isFirstTimeOver6Weeks == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng trả lời đầy đủ 3 câu hỏi")),
      );
      return;
    }

    final templateId = classifyTemplateId();
    final appointmentRepo = context.read<AppointmentRepository>();

    final request = AppointmentRequest(
      reason: _reasonCtrl.text.trim(),
      appointmentDate: DateTime.now().toIso8601String(),
      status: "scheduled",
      fullName: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      notes: "Phân loại từ câu hỏi",
      customInfo: {
        "everVisited": everVisited,
        "hasContinuousAttack": hasContinuousAttack,
        "isFirstTimeOver6Weeks": isFirstTimeOver6Weeks,
      },
    );

    setState(() => _loading = true);

    try {
      final response = await appointmentRepo.createAppointment(request);
      final appointmentId = response.data?.id;
      if (appointmentId == null) throw Exception("Không tạo được appointment");

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MedicalFormScreen(
            templateId: templateId,
            appointmentId: appointmentId,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Lỗi: $e")),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Phân loại bệnh án")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ================== PHẦN 3 CÂU HỎI ==================
              const Text("Câu hỏi phân loại",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

              const SizedBox(height: 8),
              const Text(
                  "1. Bạn đã từng khám ở phòng khám mày đay bệnh viện da liễu TW hay chưa?"),
              SwitchListTile(
                title: Text(
                    everVisited == true ? "Đã từng khám" : "Chưa từng khám"),
                value: everVisited ?? false,
                onChanged: (val) => setState(() => everVisited = val),
              ),

              const SizedBox(height: 8),
              const Text(
                  "2. Bạn đã có đợt nào bị liên tục >= 6 tuần chưa (Liên tục = ≥ 2 lần/tuần)?"),
              SwitchListTile(
                title: Text(hasContinuousAttack == true ? "Có" : "Chưa"),
                value: hasContinuousAttack ?? false,
                onChanged: (val) => setState(() => hasContinuousAttack = val),
              ),

              const SizedBox(height: 8),
              const Text(
                  "3. Đây có phải lần đầu bạn bị liên tục lớn > 6 tuần không?"),
              SwitchListTile(
                title: Text(isFirstTimeOver6Weeks == true
                    ? "Lần đầu"
                    : "Không phải lần đầu"),
                value: isFirstTimeOver6Weeks ?? false,
                onChanged: (val) => setState(() => isFirstTimeOver6Weeks = val),
              ),

              const Divider(height: 32),

              /// ================== THÔNG TIN APPOINTMENT ==================
              const Text("Thông tin đặt lịch",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: "Họ tên"),
                validator: (val) =>
                    val == null || val.isEmpty ? "Bắt buộc" : null,
              ),
              TextFormField(
                controller: _phoneCtrl,
                decoration: const InputDecoration(labelText: "Số điện thoại"),
                validator: (val) =>
                    val == null || val.isEmpty ? "Bắt buộc" : null,
              ),
              TextFormField(
                controller: _reasonCtrl,
                decoration: const InputDecoration(labelText: "Lý do khám"),
                validator: (val) =>
                    val == null || val.isEmpty ? "Bắt buộc" : null,
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : _submit,
                  icon: _loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.check),
                  label: Text(_loading ? "Đang xử lý..." : "Xác nhận"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

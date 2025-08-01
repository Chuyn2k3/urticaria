import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urticaria/feature/medical_record/patient/patient_cubit.dart';
import '../../enum/record_type.dart';
import 'create_record_form_screen.dart';

class CreateRecordIntroScreen extends StatefulWidget {
  const CreateRecordIntroScreen({super.key});

  @override
  State<CreateRecordIntroScreen> createState() =>
      _CreateRecordIntroScreenState();
}

class _CreateRecordIntroScreenState extends State<CreateRecordIntroScreen>
    with TickerProviderStateMixin {
  final _durationController = TextEditingController();
  int currentStep = 0;
  bool hasFrequentSymptoms = false;
  bool isReturningVisit = false;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _durationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleStep1() {
    final durationText = _durationController.text.trim();
    if (durationText.isEmpty || int.tryParse(durationText) == null) {
      _showErrorSnackBar("Vui lòng nhập số tuần bị bệnh hợp lệ");
      return;
    }

    final durationWeeks = int.parse(durationText);
    if (durationWeeks <= 0) {
      _showErrorSnackBar("Số tuần phải lớn hơn 0");
      return;
    }

    if (durationWeeks < 6) {
      _navigate(RecordType.cap);
    } else {
      setState(() => currentStep = 1);
      _animationController.reset();
      _animationController.forward();
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
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            CreateRecordFormScreen(recordType: type),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF0066CC);
    return BlocProvider(
      create: (context) => PatientProfileCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          title: const Text(
            'Tạo bệnh án mới',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: themeColor,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: AnimatedBuilder(
          animation: _slideAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(300 * (1 - _slideAnimation.value), 0),
              child: Opacity(
                opacity: _slideAnimation.value,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: currentStep == 0
                      ? _buildStep1(themeColor)
                      : _buildStep2(themeColor),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStep1(Color themeColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProgressIndicator(0, themeColor),
        const SizedBox(height: 32),
        _buildStepCard(
          themeColor,
          'Thời gian mắc bệnh',
          'Để chúng tôi có thể phân loại chính xác tình trạng của bạn',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bạn bị bệnh bao lâu rồi? (tính theo tuần)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: themeColor, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Ví dụ: 2, 5, 10',
                  prefixIcon: Icon(Icons.access_time, color: themeColor),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: themeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: themeColor.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: themeColor, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'Triệu chứng có xuất hiện >= 3 ngày/tuần không?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      value: hasFrequentSymptoms,
                      onChanged: (v) => setState(() => hasFrequentSymptoms = v),
                      title: const Text(
                        'Có triệu chứng thường xuyên',
                        style: TextStyle(fontSize: 14),
                      ),
                      activeColor: themeColor,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        _buildActionButton(
          'Tiếp tục',
          themeColor,
          _handleStep1,
        ),
      ],
    );
  }

  Widget _buildStep2(Color themeColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProgressIndicator(1, themeColor),
        const SizedBox(height: 32),
        _buildStepCard(
          themeColor,
          'Lịch sử khám bệnh',
          'Thông tin này giúp bác sĩ hiểu rõ hơn về tình trạng của bạn',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bạn đã từng khám bệnh này trước đây chưa?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 20),
              _buildRadioOption(
                'Chưa, đây là lần đầu',
                'Tôi chưa từng khám bệnh da liễu này trước đây',
                false,
                themeColor,
              ),
              const SizedBox(height: 16),
              _buildRadioOption(
                'Rồi, tôi đã từng khám trước đó',
                'Tôi đã có kinh nghiệm điều trị bệnh này',
                true,
                themeColor,
              ),
            ],
          ),
        ),
        const Spacer(),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() {
                  currentStep = 0;
                  _animationController.reset();
                  _animationController.forward();
                }),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: themeColor),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Quay lại',
                  style: TextStyle(
                    color: themeColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: _buildActionButton(
                'Tạo bệnh án',
                themeColor,
                _handleStep2,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(int step, Color themeColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildStepCircle(1, step >= 0, themeColor),
          Expanded(
            child: Container(
              height: 2,
              color: step >= 1 ? themeColor : Colors.grey.shade300,
            ),
          ),
          _buildStepCircle(2, step >= 1, themeColor),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int stepNumber, bool isActive, Color themeColor) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isActive ? themeColor : Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          stepNumber.toString(),
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey.shade600,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildStepCard(
    Color themeColor,
    String title,
    String subtitle,
    Widget content,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: themeColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          content,
        ],
      ),
    );
  }

  Widget _buildRadioOption(
    String title,
    String subtitle,
    bool value,
    Color themeColor,
  ) {
    final isSelected = isReturningVisit == value;

    return GestureDetector(
      onTap: () => setState(() => isReturningVisit = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? themeColor.withOpacity(0.1) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? themeColor : Colors.transparent,
            width: 2,
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
                  color: isSelected ? themeColor : Colors.grey.shade400,
                  width: 2,
                ),
                color: isSelected ? themeColor : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? themeColor : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String text,
    Color themeColor,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: themeColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

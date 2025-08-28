import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:urticaria/feature/signup/sigup_success.dart';
import 'package:urticaria/feature/signup/widgets/signup_process.dart';
import '../../utils/colors.dart';
import '../../utils/helper.dart';
import '../../widget/button.dart';

class SignupInfo extends StatefulWidget {
  const SignupInfo({Key? key}) : super(key: key);

  @override
  State<SignupInfo> createState() => _SignupInfoState();
}

class _SignupInfoState extends State<SignupInfo> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _emailController = TextEditingController();

  bool isMale = true;

  void handleDatePicker(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      _dobController.text =
          "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
    }
  }

  void onSubmit() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SignupSuccess()),
    );
    print("✅ Tạo tài khoản thành công");
    print("Họ tên: ${_fullNameController.text}");
    print("Ngày sinh: ${_dobController.text}");
    print("Email: ${_emailController.text}");
    print("Giới tính: ${isMale ? 'Nam' : 'Nữ'}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              children: [
                const SizedBox(height: 12),
                const SignUpProcess(currentProcess: SignUpProcessEnum.Step3),
                const SizedBox(height: 16),
                Text(
                  "Điền thông tin của bạn",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Chúng tôi cần một vài thông tin để tạo tài khoản cho bạn.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _fullNameController,
                        decoration: const InputDecoration(
                          labelText: "Họ và tên",
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? "Vui lòng nhập họ tên"
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _dobController,
                        readOnly: true,
                        onTap: () => handleDatePicker(context),
                        inputFormatters: [
                          MaskTextInputFormatter(
                            mask: '##/##/####',
                            filter: {"#": RegExp(r'[0-9]')},
                          ),
                        ],
                        decoration: InputDecoration(
                          labelText: "Ngày sinh",
                          prefixIcon: const Icon(Icons.cake_outlined),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () => handleDatePicker(context),
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? "Vui lòng chọn ngày sinh"
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Vui lòng nhập email";
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return "Email không hợp lệ";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Giới tính",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => setState(() => isMale = true),
                              icon: Icon(
                                Icons.male,
                                color: isMale ? Colors.blue : Colors.grey,
                              ),
                              label: Text("Nam"),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: isMale ? Colors.blue : Colors.grey,
                                ),
                                foregroundColor:
                                    isMale ? Colors.blue : Colors.black54,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => setState(() => isMale = false),
                              icon: Icon(
                                Icons.female,
                                color: !isMale ? Colors.pink : Colors.grey,
                              ),
                              label: Text("Nữ"),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: !isMale ? Colors.pink : Colors.grey,
                                ),
                                foregroundColor:
                                    !isMale ? Colors.pink : Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      SaveButton(
                          title: "Tạo tài khoản",
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              onSubmit();
                            }
                          },
                          color: AppColors.primary),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

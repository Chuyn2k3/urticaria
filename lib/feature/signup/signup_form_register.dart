// import 'package:flutter/services.dart';
// import 'package:flutter/material.dart';
// import 'package:urticaria/feature/signup/signup_otp_v2.dart';
// import 'package:urticaria/feature/signup/widgets/signup_process.dart';
// import '../../utils/colors.dart';
// import '../../utils/helper.dart';
// import '../../utils/icons.dart';
// import '../../utils/styles.dart';
// import '../../widget/app_button.dart';
// import '../../widget/app_button_outline.dart';
// import '../../widget/app_input.dart';
//
// class SignupForm extends StatefulWidget {
//   const SignupForm({Key? key}) : super(key: key);
//
//   @override
//   _SignupFormState createState() => _SignupFormState();
// }
//
// class _SignupFormState extends State<SignupForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _phoneController = TextEditingController();
//   final _passController = TextEditingController();
//   final _confirmPassController = TextEditingController();
//
//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;
//
//   String? _validatePhone(String? value) {
//     if (value == null || value.isEmpty) {
//       return "Vui lòng nhập số điện thoại";
//     }
//     if (!RegExp(r'^\d{10,11}$').hasMatch(value)) {
//       return "Số điện thoại không hợp lệ";
//     }
//     return null;
//   }
//
//   String? _validatePassword(String? value) {
//     if (value == null || value.length < 6) {
//       return "Mật khẩu phải có ít nhất 6 ký tự";
//     }
//     return null;
//   }
//
//   String? _validateConfirmPassword(String? value) {
//     if (value != _passController.text) {
//       return "Mật khẩu xác nhận không khớp";
//     }
//     return null;
//   }
//
//   void _onSubmit() {
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => SignupOtpV2(),
//         ));
//     // if (_formKey.currentState!.validate()) {
//     //   // Thực hiện logic gửi form đăng ký tại đây
//     //   print("Đăng ký thành công với số điện thoại: ${_phoneController.text}");
//     // }
//   }
//
//   @override
//   void dispose() {
//     _phoneController.dispose();
//     _passController.dispose();
//     _confirmPassController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         backgroundColor: AppColors.background,
//         body: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SignUpProcess(currentProcess: SignUpProcessEnum.Step1),
//                 Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       Text(
//                         "Đăng ký",
//                         style:
//                             Styles.heading2.copyWith(color: AppColors.primary),
//                       ),
//                       Padding(
//                         padding:
//                             EdgeInsets.only(top: heightConvert(context, 25)),
//                         child: AppInput(
//                           iconLeft: IconEnums.phone,
//                           hintText: "Số điện thoại",
//                           controller: _phoneController,
//                           //validationError: _validatePhone,
//                           keyboardType: TextInputType.phone,
//                         ),
//                       ),
//                       AppInput(
//                         maxLine: 1,
//                         iconLeft: IconEnums.lock,
//                         iconRight:
//                             _obscurePassword ? IconEnums.eyeOff : IconEnums.eye,
//                         hintText: "Nhập mật khẩu",
//                         controller: _passController,
//                         //validationError: _validatePassword,
//                         obscureText: _obscurePassword,
//                         onTapIconRight: () {
//                           setState(() {
//                             _obscurePassword = !_obscurePassword;
//                           });
//                         },
//                         listFormat: [
//                           FilteringTextInputFormatter.deny(RegExp(r'[ ]')),
//                         ],
//                       ),
//                       AppInput(
//                         maxLine: 1,
//                         iconLeft: IconEnums.lock,
//                         iconRight: _obscureConfirmPassword
//                             ? IconEnums.eyeOff
//                             : IconEnums.eye,
//                         hintText: "Nhập lại mật khẩu",
//                         controller: _confirmPassController,
//                         //validationError: _validateConfirmPassword,
//                         obscureText: _obscureConfirmPassword,
//                         onTapIconRight: () {
//                           setState(() {
//                             _obscureConfirmPassword = !_obscureConfirmPassword;
//                           });
//                         },
//                         listFormat: [
//                           FilteringTextInputFormatter.deny(RegExp(r'[ ]')),
//                         ],
//                       ),
//                       AppButton(
//                         title: "ĐĂNG KÝ",
//                         onPressed: _onSubmit,
//                         iconRight: IconEnums.user_plus,
//                         isLeftGradient: true,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         bottomNavigationBar: const BuildHotline2(),
//       ),
//     );
//   }
// }
//
// class BuildHotline2 extends StatelessWidget {
//   const BuildHotline2({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(bottom: 16),
//             child: Text(
//               "Bạn đang gặp khó khăn? Hãy gọi cho chúng tôi",
//               style: Styles.subtitleLarge.copyWith(color: AppColors.neutral600),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(bottom: 24),
//             child: AppButtonOutline(
//               text: "HOTLINE",
//               phoneNumber: "19001234",
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

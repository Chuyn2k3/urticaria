import 'package:flutter/material.dart';
import 'package:urticaria/feature/signup/signup_info.dart';
import 'package:urticaria/feature/signup/widgets/otp_widget.dart';
import 'package:urticaria/feature/signup/widgets/signup_process.dart';

import '../../utils/colors.dart';
import '../../utils/helper.dart';

class SignupOtpV2 extends StatefulWidget {
  const SignupOtpV2({Key? key}) : super(key: key);

  @override
  _SignupOtpV2State createState() => _SignupOtpV2State();
}

class _SignupOtpV2State extends State<SignupOtpV2> {
  String? secretKey;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: widthConvert(context, 16), vertical: 16.0),
                child: SignUpProcess(
                  currentProcess: SignUpProcessEnum.Step2,
                ),
              ),
              TestOTPWidget(
                phoneNumber: "+84901234567",
                onCompleted: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignupInfo(),
                    )),
                onResend: () => print("Đã gửi lại mã"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

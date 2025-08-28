import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../constant/color.dart';

class TestOTPWidget extends StatefulWidget {
  const TestOTPWidget({
    Key? key,
    required this.phoneNumber,
    this.countDown = 60,
    this.onCompleted,
    this.onResend,
  }) : super(key: key);

  final String phoneNumber;
  final int countDown;
  final VoidCallback? onCompleted;
  final VoidCallback? onResend;

  @override
  State<TestOTPWidget> createState() => _TestOTPWidgetState();
}

class _TestOTPWidgetState extends State<TestOTPWidget> {
  late Timer _timer;
  int _start = 0;
  int wrongAttempts = 3;
  final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _start = widget.countDown;
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_start > 0) {
          _start--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void onOtpCompleted(String otp) {
    if (_start <= 0) {
      print("OTP hết hạn.");
      return;
    }

    if (otp == "123456") {
      print("✅ OTP đúng!");
      widget.onCompleted?.call();
    } else {
      setState(() {
        wrongAttempts--;
      });
      if (wrongAttempts > 0) {
        print("❌ Sai mã OTP. Còn $wrongAttempts lần thử.");
      } else {
        print("🚫 Bạn đã nhập sai quá số lần cho phép.");
      }
    }
  }

  void onResendPressed() {
    setState(() {
      _start = widget.countDown;
      wrongAttempts = 3;
    });
    startTimer();
    print("🔁 Đã gửi lại mã OTP.");
    widget.onResend?.call();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Nhập mã xác thực",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            "Mã OTP đã được gửi đến số điện thoại",
            style: TextStyle(fontSize: 14),
          ),
          Text(
            widget.phoneNumber,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 24),
          PinCodeTextField(
            length: 6,
            appContext: context,
            controller: _otpController,
            keyboardType: TextInputType.number,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.circle,
              borderRadius: BorderRadius.circular(5),
              fieldHeight: 42,
              fieldWidth: 42,
              activeColor: Colors.blue,
              inactiveColor: Colors.grey,
              selectedColor: Colors.blueAccent,
              activeFillColor: AppColors.whiteColor,
              inactiveFillColor: Colors.grey[200],
              selectedFillColor: AppColors.whiteColor,
            ),
            animationDuration: const Duration(milliseconds: 300),
            enableActiveFill: true,
            onCompleted: onOtpCompleted,
            onChanged: (value) {},
            beforeTextPaste: (text) => true,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Không nhận được mã? "),
              TextButton(
                onPressed: _start > 0 ? null : onResendPressed,
                child: Text(
                  "Gửi lại",
                  style: TextStyle(
                    color: _start > 0 ? Colors.grey : Colors.blue,
                  ),
                ),
              )
            ],
          ),
          Text(
            "$_start giây",
            style: const TextStyle(fontSize: 16),
          ),
          if (wrongAttempts <= 1)
            const Padding(
              padding: EdgeInsets.only(top: 12.0),
              child: Text(
                "⚠️ Cảnh báo: Lần thử cuối!",
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}

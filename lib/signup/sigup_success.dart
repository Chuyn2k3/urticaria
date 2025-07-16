import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/colors.dart';

class SignupSuccess extends StatelessWidget {
  const SignupSuccess({Key? key}) : super(key: key);

  void onClickHome(BuildContext context) {
    // Quay về trang đầu hoặc đẩy sang màn hình chính (bạn có thể sửa lại route tùy app)
    Navigator.of(context).popUntil((route) => route.isFirst);
    // Hoặc Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Ngăn nút back
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle,
                      size: 120, color: AppColors.primary),
                  const SizedBox(height: 40),
                  const Text(
                    "Đăng ký thành công!",
                    style: TextStyle(
                        fontSize: 24,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Bạn đã đăng ký tài khoản thành công.\nChúc bạn trải nghiệm tuyệt vời!",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: () => onClickHome(context),
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              left: 16, top: 8, bottom: 8, right: 20),
                          margin: const EdgeInsets.only(left: 44, top: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(4),
                              bottomRight: Radius.circular(4),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(194, 198, 201, 0.3),
                                offset: Offset(2, 3),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: const Text(
                            'QUAY LẠI TRANG CHỦ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(194, 198, 201, 0.3),
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: const Icon(Icons.arrow_back_ios,
                                  size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

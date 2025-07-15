import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:urticaria/home/home_page.dart';
import 'package:urticaria/widget/touchable_opacity.dart';

import '../bottom_nav/bottom_nav_page.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/icons.dart';
import '../utils/styles.dart';
import 'app_dialog_confirm.dart';
import 'app_input.dart';
import 'button_login_widget.dart';

class FormInputWidget extends StatefulWidget {
  const FormInputWidget(
      {Key? key,
      required this.phoneController,
      required this.passwordController})
      : super(key: key);
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  @override
  State<FormInputWidget> createState() => _FormInputWidgetState();
}

class _FormInputWidgetState extends State<FormInputWidget> {
  final _formKey = GlobalKey<FormState>();

  void _showDialogForgot(BuildContext context) async {
    await showDialog<bool>(
      context: context,
      builder: (c) => DialogConfirm(
        title: 'Thông báo',
        subTitle:
            'Vui lòng liên hệ tổng đài hỗ trợ để được hướng dẫn lấy lại mật khẩu',
        buttonRight: 'Hủy bỏ',
        buttonLeft: 'Gọi ngay',
        onButtonLeft: () async {},
        onButtonRight: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              InkWell(
                focusColor: AppColors.transparent,
                onTap: () async {},
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0, left: 8.0),
                      child: SvgPicture.asset(
                        IconEnums.phone,
                        height: 24,
                      ),
                    ),
                    Expanded(
                      child: IgnorePointer(
                        ignoring: false,
                        child: AppInput(
                          controller: widget.phoneController,
                          validator: (phoneNumber) {
                            if (phoneNumber == null ||
                                phoneNumber.trim().isEmpty) {
                              return "";
                            }
                            if (!Reges.regIsPhone
                                .hasMatch(phoneNumber.trim())) {
                              return "";
                            }
                            return null;
                          },
                          enabled: true,
                          hintText: "",
                          onTapIconRight: () async {
                            widget.phoneController.clear();
                          },
                          iconRight: IconEnums.close,
                          onChangeValue: (value) {},
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 8.0),
                    child: SvgPicture.asset(
                      IconEnums.lock,
                      height: 24,
                    ),
                  ),
                  Expanded(
                    child: AppInput(
                      controller: widget.passwordController,
                      maxLine: 1,
                      // validator: (password) {
                      //   if (password == null || password.isEmpty) {
                      //     return l10n(context)!.validate_empty;
                      //   }
                      //   if (password.length < 8) {
                      //     return "Tối thiểu 8 ký tự";
                      //   }
                      //   if (!Reges.regIsPassword.hasMatch(password)) {
                      //     return "Cần chứa ký tự đặc biệt";
                      //   }
                      //   return null;
                      // },
                      hintText: "",
                      obscureText: true,
                      onChangeValue: (value) {},
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    child: Text(
                      "Quên mật khẩu",
                      style: Styles.content.copyWith(color: AppColors.primary),
                    ),
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(
                height: 16.0,
              ),
            ],
          ),
        ),
        ButtonLoginWidget(
          onLogin: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomNavPage(),
                ));
          },
          onBiometric: () async {
            // _settingStore.isActiveFinger = await SessionPrefs.getActiveFinger();
            // print('${_settingStore.isActiveFinger}');
            // if (_settingStore.isActiveFinger) {
            //   await _loginStore.biometricAuth(context);
            //   return;
            // }
            // showDialog(
            //     context: context,
            //     builder: (_) {
            //       return CupertinoAlertDialog(
            //         title: const Text("Lỗi đăng nhập"),
            //         content: const Text(
            //             "Bạn chưa cài đặt Touch ID/Face ID để sử dụng chức năng này. Vui lòng sử dụng mật khẩu để đăng nhập."),
            //         actions: <Widget>[
            //           CupertinoDialogAction(
            //             child: const Text("Ok"),
            //             onPressed: () {
            //               Navigator.pop(context, false);
            //             },
            //           ),
            //         ],
            //       );
            //     });
          },
        ),
        // if (Platform.isIOS)
        //   Padding(
        //     padding: const EdgeInsets.only(top: 4.0),
        //     child: SignInWithAppleButton(
        //         borderRadius: BorderRadius.circular(22),
        //         style: SignInWithAppleButtonStyle.white,
        //         onPressed: () {
        //           _loginStore.loginApple();
        //         }),
        //   ),
        // const Spacer(),
        const SizedBox(
          height: 16.0,
        ),
        // const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bạn chưa có tài khoản? ',
              style: Styles.content,
            ),
            TouchableOpacity(
              child: Text(
                'Đăng ký',
                style: Styles.content.copyWith(
                    color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
              onTap: () {},
            ),
          ],
        ),
        // AppButton(
        //   title: 'Facebook',
        //   onPressed: () async{
        //     await _loginStore.loginFacebook();
        //   },
        //   iconLeft: IconEnums.facebookLogo,
        //   iconRightColor: AppColors.background,
        // )
      ],
    );
  }
}

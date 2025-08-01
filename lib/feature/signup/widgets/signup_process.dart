import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:urticaria/router/go_router_name_enum.dart';
import 'package:urticaria/screens/login_page.dart';

import '../../../utils/colors.dart';
import '../../../utils/styles.dart';
import '../../../widget/touchable_opacity.dart';

enum SignUpProcessEnum { Step1, Step2, Step3 }

class SignUpProcess extends StatelessWidget {
  final SignUpProcessEnum currentProcess;
  final bool enableOTP; // ✅ thêm để điều khiển bước OTP
  final Function? onBackStep3;

  const SignUpProcess({
    Key? key,
    this.currentProcess = SignUpProcessEnum.Step1,
    this.enableOTP = true, // mặc định là bật OTP
    this.onBackStep3,
  }) : super(key: key);

  List<Widget> handleProcess(SignUpProcessEnum step, BuildContext context) {
    switch (step) {
      case SignUpProcessEnum.Step1:
        return [
          _buildOutlineCircle(
              AppColors.primary, null, AppColors.grayLight, "Bước 1"),
          _buildLineProcess(AppColors.grayLight),
          if (enableOTP) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildOutlineCircle(AppColors.grayLight, AppColors.grayLight,
                    AppColors.grayLight, "Bước 2"),
                //_buildLineProcess(AppColors.grayLight),
                _buildOutlineCircle(
                    AppColors.grayLight, AppColors.grayLight, null, "Bước 3"),
              ],
            )
          ] else ...[
            Row(
              children: [
                _buildOutlineCircle(
                    AppColors.grayLight, AppColors.grayLight, null, "Bước 2"),
              ],
            )
          ],
        ];
      case SignUpProcessEnum.Step2:
        return [
          _buildCheckCircle(null, AppColors.primary, "Bước 1"),
          _buildLineProcess(AppColors.primary),
          _buildOutlineCircle(AppColors.primary, AppColors.primary,
              enableOTP ? AppColors.grayLight : null, "Bước 2"),
          if (enableOTP) ...[
            _buildLineProcess(AppColors.grayLight),
            _buildOutlineCircle(
                AppColors.grayLight, AppColors.grayLight, null, "Bước 3"),
          ]
        ];
      case SignUpProcessEnum.Step3:
        return [
          _buildCheckCircle(null, AppColors.primary, "Bước 1"),
          if (enableOTP) ...[
            _buildCheckCircle(AppColors.primary, AppColors.primary, "Bước 2"),
            _buildLineProcess(AppColors.primary),
            _buildOutlineCircle(
                AppColors.primary, AppColors.primary, null, "Bước 3"),
          ] else ...[
            _buildLineProcess(AppColors.primary),
            _buildOutlineCircle(
                AppColors.primary, AppColors.primary, null, "Bước 2"),
          ],
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildBackBtn(context),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: handleProcess(currentProcess, context),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBackBtn(BuildContext context) {
    return TouchableOpacity(
      child: Column(
        children: [
          const Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: AppColors.grayLight,
          ),
          Text(
            "",
            style: Styles.subtitleSmall
                .copyWith(color: AppColors.primary, height: 20 / 12),
          )
        ],
      ),
      onTap: () {
        if (currentProcess == SignUpProcessEnum.Step3) {
          GoRouter.of(context).push(GoRouterName.login.routePath);
        } else {
          GoRouter.of(context).pop();
        }
      },
    );
  }

  Widget _buildCheckCircle(
      Color? leftCrossbarColor, Color? rightCrossbarColor, String text) {
    return SizedBox(
      width: 60,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: leftCrossbarColor != null
                    ? Container(
                        color: leftCrossbarColor,
                        height: 2,
                      )
                    : const SizedBox(),
              ),
              Container(
                width: 24,
                height: 24,
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 15,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              Expanded(
                child: rightCrossbarColor != null
                    ? Container(
                        color: rightCrossbarColor,
                        height: 2,
                      )
                    : const SizedBox(),
              ),
            ],
          ),
          Text(
            text,
            style: Styles.subtitleSmall
                .copyWith(color: AppColors.primary, height: 20 / 12),
          )
        ],
      ),
    );
  }

  Widget _buildOutlineCircle(Color outlineColor, Color? leftCrossbarColor,
      Color? rightCrossbarColor, String text) {
    return SizedBox(
      width: 60,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: leftCrossbarColor != null
                    ? Container(color: leftCrossbarColor, height: 2)
                    : const SizedBox(),
              ),
              Container(
                width: 24,
                height: 24,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  border: Border.all(color: outlineColor, width: 2),
                  //shape: BoxShape.circle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: outlineColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              Expanded(
                child: rightCrossbarColor != null
                    ? Container(color: rightCrossbarColor, height: 2)
                    : const SizedBox(),
              ),
            ],
          ),
          Text(
            text,
            style: Styles.subtitleSmall
                .copyWith(color: outlineColor, height: 20 / 12),
          )
        ],
      ),
    );
  }

  Widget _buildLineProcess(Color color) {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            color: color,
            height: 2,
            //width: 60,
          ),
          Text(
            '',
            style: Styles.subtitleSmall.copyWith(height: 20 / 12 + 0.08),
          )
        ],
      ),
    );
  }
}

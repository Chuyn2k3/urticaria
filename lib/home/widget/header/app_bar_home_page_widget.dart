import 'package:flutter/material.dart';
import 'package:urticaria/home/widget/header/user_stack.dart';
import '../../../utils/images.dart';
import '../../../widget/medical_unit_widget.dart';
import 'header_unauth.dart';

class AppBarHomePageWidget extends StatelessWidget {
  AppBarHomePageWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: SizedBox(
                        height: 70,
                        width: 70,
                        child: Image.asset(
                          ImageEnum.logoDaLieu,
                          // color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MedicalUnitWidget(),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            UserStack(),
          ],
        ),
      ),
    );
  }
}

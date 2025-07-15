import 'package:flutter/material.dart';
import '../../../utils/colors.dart';
import '../../../utils/helper.dart';
import '../../../utils/icons.dart';
import '../../../widget/circle_with_icon.dart';

class ShortcutMenu extends StatelessWidget {
  ShortcutMenu({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final double iconSize = widthConvert(context, 45);
    return Column(
      children: [
        FirstRowShortcut(iconSize: iconSize,),
        const SizedBox(height: 16),
        SecondRowShortcut(iconSize: iconSize, ),
      ],
    );
  }
}

class FirstRowShortcut extends StatelessWidget {
  FirstRowShortcut({
    Key? key,
    required this.iconSize,

  }) : super(key: key);
  final double iconSize;


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: CircleWithIcon(
            boxSize: iconSize,
            iconSize: iconSize,
            icon: IconEnums.nCalendar,
            title: 'Đặt lịch',
            colorIcon: AppColors.primary,
            onTap: () {

            },
          ),
        ),
        Expanded(
          child: CircleWithIcon(
            boxSize: iconSize,
            iconSize: iconSize,
            icon: IconEnums.electronicHealthRecords,
            colorIcon: AppColors.primary,
            title: 'Hồ sơ sức khoẻ',
            onTap: () {


            },
          ),
        ),
        Expanded(
          child: CircleWithIcon(
            colorIcon: AppColors.primary,
            boxSize: iconSize,
            iconSize: iconSize,
            icon: IconEnums.news,
            title: 'Tin tức',
            onTap: () {

            },
          ),
        ),
      ],
    );
  }
}

class SecondRowShortcut extends StatelessWidget {


  SecondRowShortcut({
    Key? key,
    required this.iconSize,

  }) : super(key: key);
  final double iconSize;


  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: CircleWithIcon(
              boxSize: iconSize,
              iconSize: iconSize,
              icon: IconEnums.iconNurse,
              colorIcon: AppColors.primary,
              title: 'Tra cứu',
              onTap: () {

              }),
        ),
        Expanded(
          child: CircleWithIcon(
            boxSize: iconSize,
            iconSize: iconSize,
            colorIcon: AppColors.error700,
            icon: IconEnums.nSos2,
            title: "",
            onTap: () {

            },
          ),
        ),
        Expanded(
          child: CircleWithIcon(
            boxSize: iconSize,
            iconSize: iconSize,
            icon: IconEnums.certificate,
            title: 'Ký BN',
            colorIcon: AppColors.primary,
            onTap: () {

            },
          ),
        ),
      ],
    );
  }
}

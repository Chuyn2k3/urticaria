import 'package:flutter/material.dart';
import 'package:urticaria/medical_record/appointment_call_info_screen.dart';

import '../../business/business_page.dart';
import '../../medical_record/create_record_intro_screen.dart';
import '../../utils/colors.dart';
import '../../utils/helper.dart';
import '../../utils/icons.dart';
import '../../widget/circle_with_icon.dart';

class ShortcutMenuCustomer extends StatelessWidget {
  ShortcutMenuCustomer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double iconSize = widthConvert(context, 45);
    return Column(
      children: [
        FirstShortcutCustomer(
          iconSize: iconSize,
        ),
        // const SizedBox(height: 16),
        // SecondShortcutCustomer(iconSize: iconSize, controller: controller),
      ],
    );
  }
}

class FirstShortcutCustomer extends StatelessWidget {
  FirstShortcutCustomer({
    Key? key,
    required this.iconSize,
  }) : super(key: key);
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Expanded(
        //   child: CircleWithIcon(
        //     boxSize: iconSize,
        //     iconSize: iconSize,
        //     icon: IconEnums.nCalendar,
        //     title: 'Đặt lịch',
        //     colorIcon: AppColors.primary,
        //     onTap: () {
        //       final MedicalAppointmentStore _appointmentStore =
        //       Modular.get<MedicalAppointmentStore>();
        //       _appointmentStore.changeSearchDataAtHome(false);
        //       Modular.to.pushNamed(AppRoutes.medicalPackagePage);
        //     },
        //   ),
        // ),
        //if (controller.isLogin) ...[
        Expanded(child: SizedBox.shrink()),
        Expanded(
          flex: 2,
          child: CircleWithIcon(
            boxSize: iconSize,
            iconSize: iconSize,
            icon: IconEnums.electronicHealthRecords,
            colorIcon: AppColors.primary,
            title: 'Hồ sơ sức khoẻ',
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BusinessPage(),
                  ));
            },
          ),
        ),
        //],
        Expanded(child: SizedBox.shrink()),
        Expanded(
          flex: 2,
          child: CircleWithIcon(
            boxSize: iconSize,
            iconSize: iconSize,
            icon: IconEnums.iconHeathScreen,
            title: 'Tạo bệnh án',
            colorIcon: AppColors.primary,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CreateRecordIntroScreen(),
                ),
              );
            },
          ),
        ),
        Expanded(child: SizedBox.shrink()),
        //
        // Expanded(
        //   flex: 2,
        //   child: CircleWithIcon(
        //     boxSize: iconSize,
        //     iconSize: iconSize,
        //     colorIcon: AppColors.primary,
        //     icon: IconEnums.news,
        //     title: 'Tin tức',
        //     onTap: () {},
        //   ),
        // ),
        // Expanded(child: SizedBox.shrink()),
        Expanded(
          flex: 2,
          child: CircleWithIcon(
            boxSize: iconSize,
            iconSize: iconSize,
            colorIcon: AppColors.primary,
            icon: IconEnums.iconPhoneCall,
            title: "Liên hệ",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AppointmentCallInfoScreen(),
                ),
              );
            },
          ),
        ),
        Expanded(child: SizedBox.shrink())
      ],
    );
  }
}

class SecondShortcutCustomer extends StatelessWidget {
  SecondShortcutCustomer({
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
              onTap: () {}),
        ),
        Expanded(
          child: CircleWithIcon(
            boxSize: iconSize,
            iconSize: iconSize,
            colorIcon: AppColors.error700,
            icon: IconEnums.nSos2,
            title: "",
            onTap: () {},
          ),
        ),
        Expanded(
          child: CircleWithIcon(
            boxSize: iconSize,
            iconSize: iconSize,
            icon: IconEnums.certificate,
            title: 'Ký BN',
            colorIcon: AppColors.primary,
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

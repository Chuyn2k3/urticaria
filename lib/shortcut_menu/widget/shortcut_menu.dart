import 'package:flutter/material.dart';
import 'package:urticaria/shortcut_menu/widget/shortcut_menu_customer.dart';

import '../../utils/colors.dart';

class ShortcutMenuWidget extends StatefulWidget {
  ShortcutMenuWidget({Key? key}) : super(key: key);

  @override
  State<ShortcutMenuWidget> createState() => _ShortcutMenuWidgetState();
}

class _ShortcutMenuWidgetState extends State<ShortcutMenuWidget> {


  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 16.0,),
        margin: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
        ),
        decoration: BoxDecoration(
            color: AppColors.background,
            border: Border.all(color: AppColors.lightSilver),
            borderRadius: BorderRadius.circular(16.0)),
        child: ShortcutMenuCustomer());
    // return Observer(builder: (context) {
    //   if (controller.isStaff) {
    //     return Column(
    //       children: [
    //         Container(
    //           padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
    //           margin: const EdgeInsets.only(
    //             left: 16.0,
    //             right: 16.0,
    //           ),
    //           decoration: BoxDecoration(
    //               color: AppColors.background,
    //               border: Border.all(color: AppColors.lightSilver),
    //               borderRadius: BorderRadius.circular(16.0)),
    //           child: ShortcutMenuStaff(),
    //         ),
    //         const SizedBox(
    //           height: 16.0,
    //         ),
    //         Container(
    //             padding: const EdgeInsets.only(top: 16.0,),
    //             margin: const EdgeInsets.only(
    //               left: 16.0,
    //               right: 16.0,
    //             ),
    //             decoration: BoxDecoration(
    //                 color: AppColors.background,
    //                 border: Border.all(color: AppColors.lightSilver),
    //                 borderRadius: BorderRadius.circular(16.0)),
    //             child: ShortcutMenuCustomer()),
    //       ],
    //     );
    //   } else {
    //     return Container(
    //         padding: const EdgeInsets.only(top: 16.0,),
    //         margin: const EdgeInsets.only(
    //           left: 16.0,
    //           right: 16.0,
    //         ),
    //         decoration: BoxDecoration(
    //             color: AppColors.background,
    //             border: Border.all(color: AppColors.lightSilver),
    //             borderRadius: BorderRadius.circular(16.0)),
    //         child: ShortcutMenuCustomer());
    //   }
    // });
  }
}

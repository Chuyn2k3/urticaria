import 'package:flutter/material.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/helper.dart';
import '../../../../utils/icons.dart';
import '../../../../utils/styles.dart';
import '../../../../widget/circle_with_icon.dart';

class NotificationMeeting extends StatelessWidget {
  NotificationMeeting({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthConvert(context, 375),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: widthConvert(context, 16),
          vertical: heightConvert(context, 12),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: widthConvert(context, 12)),
              child: const CircleWithIcon(
                boxSize: 48,
                iconSize: 48,
                icon: IconEnums.homeFill,
              ),
            ),
            Flexible(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "",
                      style: Styles.descriptionNoti,
                    ),
                    TextSpan(
                      text: "",
                      style: Styles.descriptionNoti
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

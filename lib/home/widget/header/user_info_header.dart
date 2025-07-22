import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../notification/notification_page.dart';
import '../../../utils/colors.dart';
import '../../../utils/icon_tabbar.dart';
import '../../../utils/styles.dart';

class UserInfoHeader extends StatelessWidget {
  UserInfoHeader({
    Key? key,
    this.userName,
    this.avatarUri,
  }) : super(key: key);
  final String? userName;
  final String? avatarUri;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(avatarUri ?? ''),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("Hello",
                                style: Styles.titleItem
                                    .copyWith(color: AppColors.background)),
                            Text(', ',
                                style: Styles.titleItem
                                    .copyWith(color: AppColors.background)),
                            Text(
                              userName ?? '',
                              style: Styles.titleItem
                                  .copyWith(color: AppColors.background),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificationScreen(),
                          ));
                    },
                    child: SvgPicture.asset(
                      TabIcon.notificationActive,
                      color: AppColors.background,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

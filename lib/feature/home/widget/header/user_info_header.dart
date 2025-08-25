import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:urticaria/cubit/profile/profile_cubit.dart';
import '../../../notification/notification_page.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/icon_tabbar.dart';
import '../../../../utils/styles.dart';

class UserInfoHeader extends StatelessWidget {
  const UserInfoHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileUserCubit, ProfileUserState>(
      builder: (context, state) {
        String userName = '';
        String? avatarUri;

        if (state is ProfileUserLoadedState) {
          userName = state.user.fullname;
          avatarUri =
              null; // nếu có field avatarUri trong model thì gán tại đây
        }

        return GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: avatarUri != null && avatarUri.isNotEmpty
                    ? CachedNetworkImageProvider(avatarUri)
                    : null,
                child: (avatarUri == null || avatarUri.isEmpty)
                    ? const Icon(Icons.person, size: 30, color: Colors.grey)
                    : null,
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
                                Flexible(
                                  child: Text(
                                    userName,
                                    style: Styles.titleItem
                                        .copyWith(color: AppColors.background),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotificationScreen(),
                            ),
                          );
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
      },
    );
  }
}

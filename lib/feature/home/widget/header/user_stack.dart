import 'package:flutter/material.dart';
import 'package:urticaria/feature/home/widget/header/user_info_header.dart';

import '../greeting_widget.dart';

class UserStack extends StatelessWidget {
  const UserStack({
    Key? key,
    this.padding,
    this.isLogout = false,
  }) : super(key: key);

  final EdgeInsets? padding;
  final bool? isLogout;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: 0,
          ).copyWith(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GreetingWidget(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: UserInfoHeader(),
              )
            ],
          ),
        ],
      ),
    );
  }
}

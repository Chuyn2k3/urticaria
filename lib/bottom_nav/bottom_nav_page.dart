import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:urticaria/medical_record/patient/patient_cubit.dart';
import '../home/home_page.dart';
import '../medical_record/update_patient_info.dart';
import '../screens/community_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/shedule_page.dart';
import '../utils/colors.dart';
import '../utils/icon_tabbar.dart';
import '../widget/app_dialog_confirm.dart';

class BottomNavPage extends StatefulWidget {
  const BottomNavPage({Key? key}) : super(key: key);

  @override
  State<BottomNavPage> createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {
  int currentIndex = 0; // Home
  bool isMainPage = true;
  bool isLogin = false;

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    // TODO: Check login logic
    setState(() {
      isLogin = true; // tạm set true để test
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PatientProfileCubit(),
      child: WillPopScope(
        onWillPop: () async {
          await _showExitDialog();
          return false;
        },
        child: Scaffold(
          body: [
            // DetailHospitalTest(),
            // CommunityPageModule(),
            // ScheduleModule(),
            // ProfileModule(),
            const HomePage(),
            CommunityScreen(),
            SchedulePage(),
            ProfileScreen(),
            //const NotificationPage(),
          ][currentIndex],
          bottomNavigationBar: FABBottomAppBar(
            currentIndex: currentIndex,
            onTabSelected: (id) {
              setState(() {
                currentIndex = id;
              });
            },
            items: [
              FABBottomAppBarItem(
                  text: 'Thông tin', assets: TabIcon.medicalUnit),
              FABBottomAppBarItem(
                  text: 'Cộng đồng', assets: TabIcon.communityActive),
              FABBottomAppBarItem(
                  text: 'Lịch khám', assets: TabIcon.calendarInactive),
              FABBottomAppBarItem(
                  text: 'Cá nhân', assets: TabIcon.userInactive),
            ],
            notchedShape: const CircularNotchedRectangle(),
            color: AppColors.gray500,
            selectedColor: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Future<bool?> _showExitDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (c) => DialogConfirm(
        title: 'Thoát ứng dụng',
        subTitle: 'Bạn chắc chắn muốn thoát ứng dụng?',
        buttonRight: 'Hủy bỏ',
        buttonLeft: 'Đồng ý',
        onButtonLeft: () {
          SystemNavigator.pop();
          exit(0);
        },
        onButtonRight: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
      ),
    );
  }
}

class FABBottomAppBarItem {
  FABBottomAppBarItem({
    required this.text,
    required this.assets,
  });

  final String text;
  final String assets;
}

class FABBottomAppBar extends StatefulWidget {
  final List<FABBottomAppBarItem> items;
  final String? centerItemText;
  final double? height;
  final double? iconSize;
  final Color? backgroundColor;
  final Color? color;
  final Color? selectedColor;
  final NotchedShape? notchedShape;
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const FABBottomAppBar({
    Key? key,
    required this.items,
    required this.onTabSelected,
    required this.currentIndex,
    this.centerItemText,
    this.height,
    this.iconSize,
    this.backgroundColor,
    this.color,
    this.selectedColor,
    this.notchedShape,
  }) : super(key: key);

  @override
  State<FABBottomAppBar> createState() => _FABBottomAppBarState();
}

class _FABBottomAppBarState extends State<FABBottomAppBar> {
  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(widget.items.length, (int index) {
      return _buildTabItem(
        item: widget.items[index],
        index: index,
        isSelected: widget.currentIndex == index,
        onPressed: widget.onTabSelected,
      );
    });

    // Chèn khoảng giữa để FloatingActionButton nhô lên
    //  items.insert(items.length ~/ 2, _buildMiddleTabItem());

    return BottomAppBar(
      shape: widget.notchedShape,
      notchMargin: 10.0,
      color: widget.backgroundColor ?? Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
    );
  }

  Widget _buildTabItem({
    required FABBottomAppBarItem item,
    required int index,
    required bool isSelected,
    required ValueChanged<int> onPressed,
  }) {
    final Color iconColor = isSelected ? Color(0xFF0066CC) : Colors.grey;

    return Expanded(
      child: SizedBox(
        height: widget.height ?? 60,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => onPressed(index),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  item.assets,
                  color: iconColor,
                  width: widget.iconSize ?? 20,
                  height: widget.iconSize ?? 20,
                ),
                const SizedBox(height: 4),
                Text(
                  item.text,
                  style: TextStyle(
                    color: iconColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMiddleTabItem() {
    return Expanded(
      child: SizedBox(
        height: widget.height ?? 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: widget.iconSize ?? 20),
            if (widget.centerItemText != null)
              Text(
                widget.centerItemText!,
                style: TextStyle(color: widget.color ?? Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}

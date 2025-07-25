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

class _BottomNavPageState extends State<BottomNavPage>
    with TickerProviderStateMixin {
  int currentIndex = 0;
  bool isMainPage = true;
  bool isLogin = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    checkLogin();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> checkLogin() async {
    setState(() {
      isLogin = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PatientProfileCubit(),
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (!didPop) {
            await _showExitDialog();
          }
        },
        child: Scaffold(
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: [
              const HomePage(),
              CommunityScreen(),
              SchedulePage(),
              ProfileScreen(),
            ][currentIndex],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: FABBottomAppBar(
              currentIndex: currentIndex,
              onTabSelected: (id) {
                setState(() {
                  currentIndex = id;
                });
                _animationController.forward().then((_) {
                  _animationController.reset();
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

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
      child: BottomAppBar(
        shape: widget.notchedShape,
        notchMargin: 10.0,
        color: widget.backgroundColor ?? Colors.white,
        elevation: 0,
        height: 80, // Đặt chiều cao cố định
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items,
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required FABBottomAppBarItem item,
    required int index,
    required bool isSelected,
    required ValueChanged<int> onPressed,
  }) {
    final Color iconColor = isSelected ? const Color(0xFF0066CC) : Colors.grey;

    return Expanded(
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onPressed(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isSelected
                  ? const Color(0xFF0066CC).withOpacity(0.1)
                  : Colors.transparent,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Quan trọng: giới hạn kích thước
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  scale: isSelected ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: SvgPicture.asset(
                    item.assets,
                    color: iconColor,
                    width: widget.iconSize ?? 22, // Giảm kích thước icon
                    height: widget.iconSize ?? 22,
                  ),
                ),
                const SizedBox(height: 2), // Giảm khoảng cách
                Flexible(
                  // Thêm Flexible để tránh overflow
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      color: iconColor,
                      fontSize: isSelected ? 11 : 10, // Giảm font size
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    child: Text(
                      item.text,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

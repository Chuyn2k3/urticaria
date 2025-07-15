import 'package:flutter/material.dart';
import 'package:urticaria/home/widget/header/app_bar_home_page_widget.dart';
import 'package:urticaria/home/widget/section_health_new/section_health_new.dart';

import '../shortcut_menu/widget/shortcut_menu.dart';
import '../utils/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF0066CC);
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {},
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.zero,
          child: Stack(
            children: [
              Container(
                height: true
                    ? MediaQuery.of(context).size.height / 3
                    : MediaQuery.of(context).size.height / 4 + 30,
                decoration: BoxDecoration(
                    // color: HexColor('02457A'),
                    // color: Colors.blue,
                    color: themeColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(48.0),
                      bottomRight: Radius.circular(48.0),
                    )),
              ),
              Column(
                children: [
                  AppBarHomePageWidget(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 12.0,
                      ),
                      // Container(
                      //   padding: const EdgeInsets.all(16.0),
                      //   margin: const EdgeInsets.all(16.0),
                      //   decoration: BoxDecoration(
                      //       borderRadius: ViewConstants.defaultBorderRadius),
                      //   child: Row(
                      //     children: [
                      //       Expanded(child: LogInBtn()),
                      //       const SizedBox(width: 16.0),
                      //       const Expanded(child: SignInBtn())
                      //     ],
                      //   ),
                      // ),
                      ShortcutMenuWidget(),
                      // const PackageCategoryWidget(),
                      // const ProminentDoctorWidget(),
                      // //SliderHome(),
                      // PromotionNewsSection(),
                      const SectionHealthNew(),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

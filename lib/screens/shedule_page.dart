import 'package:flutter/material.dart';

import '../utils/colors.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  final List<Tab> _tabs = const [
    Tab(
      text: 'Chưa diễn ra',
    ),
    Tab(text: 'Đã diễn ra'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //const themeColor = Color(0xFF0066CC);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Lịch khám'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ScheduleUpcomingPage(),
          ScheduleCompletedPage(),
        ],
      ),
    );
  }
}

class ScheduleUpcomingPage extends StatelessWidget {
  const ScheduleUpcomingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      "Danh sách lịch khám chưa diễn ra",
    ));
  }
}

class ScheduleCompletedPage extends StatelessWidget {
  const ScheduleCompletedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      "Danh sách lịch khám đã hoàn tất",
    ));
  }
}

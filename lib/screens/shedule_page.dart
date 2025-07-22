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
    Tab(text: 'Chưa diễn ra'),
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
    final upcomingAppointments = [
      {
        'type': 'Khám cấp',
        'doctor': 'BS. Lê Thị Mai',
        'time': 'Thứ 4, 24/07 - 09:00',
        'status': 'Chờ khám',
      },
      {
        'type': 'Khám lại lần 1',
        'doctor': 'BS. Nguyễn Văn Hùng',
        'time': 'Thứ 6, 26/07 - 14:30',
        'status': 'Chờ khám',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: upcomingAppointments.length,
      itemBuilder: (context, index) {
        final item = upcomingAppointments[index];

        return Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon khám bệnh
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.medical_services,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                // Nội dung
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['type'] ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.person_outline,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            item['doctor'] ?? '',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black54),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            item['time'] ?? '',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black54),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Trạng thái
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item['status'] ?? '',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ScheduleCompletedPage extends StatelessWidget {
  const ScheduleCompletedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final completedAppointments = [
      {
        'type': 'Tái khám lần 2',
        'doctor': 'BS. Nguyễn Hữu Phước',
        'time': 'Thứ 2, 15/07 - 10:00',
        'status': 'Đã khám',
      },
      {
        'type': 'Khám lại lần 1',
        'doctor': 'BS. Trần Thị Hương',
        'time': 'Thứ 3, 16/07 - 16:00',
        'status': 'Đã khám',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: completedAppointments.length,
      itemBuilder: (context, index) {
        final item = completedAppointments[index];

        return Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon khám bệnh
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.medical_services,
                      color: AppColors.primary, size: 28),
                ),
                const SizedBox(width: 12),

                // Nội dung chính
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['type']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '👨‍⚕️ Bác sĩ: ${item['doctor']}',
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black87),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '🕒 Thời gian: ${item['time']}',
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black87),
                      ),
                    ],
                  ),
                ),

                // Trạng thái
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: item['status'] == 'Đã khám'
                        ? Colors.green.shade100
                        : Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item['status']!,
                    style: TextStyle(
                      color: item['status'] == 'Đã khám'
                          ? Colors.green
                          : Colors.orange,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

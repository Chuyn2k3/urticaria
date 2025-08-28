import 'package:flutter/material.dart';

import '../../constant/color.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  static const Color primaryBlue = Color(0xFF0066CC);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F9FF),
        appBar: AppBar(
          title: const Text('Thông báo'),
          backgroundColor: primaryBlue,
          foregroundColor: AppColors.whiteColor,
          bottom: const TabBar(
            labelColor: AppColors.whiteColor,
            unselectedLabelColor: AppColors.whiteColor,
            indicatorColor: AppColors.whiteColor,
            tabs: [
              Tab(text: 'Cơ sở y tế'),
              Tab(text: 'Hệ thống'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _NotificationListView(isFromCSYT: true),
            _NotificationListView(isFromCSYT: false),
          ],
        ),
      ),
    );
  }
}

class _NotificationListView extends StatelessWidget {
  final bool isFromCSYT;

  const _NotificationListView({required this.isFromCSYT});

  static const Color primaryBlue = Color(0xFF0066CC);

  @override
  Widget build(BuildContext context) {
    // Danh sách fake data
    final allNotifications = [
      {
        'title': 'Kết quả xét nghiệm',
        'message': 'Xét nghiệm máu của bạn đã có kết quả.',
        'time': '5 phút trước',
        'fromCSYT': true,
        'icon': Icons.bloodtype,
      },
      {
        'title': 'Lịch tái khám',
        'message': 'Bạn có lịch tái khám lúc 9h sáng mai.',
        'time': '1 giờ trước',
        'fromCSYT': true,
        'icon': Icons.calendar_month,
      },
      {
        'title': 'Cập nhật hồ sơ',
        'message': 'Hồ sơ sức khỏe của bạn đã được cập nhật.',
        'time': 'Hôm qua',
        'fromCSYT': true,
        'icon': Icons.folder_shared,
      },
      {
        'title': 'Thông báo bảo trì',
        'message': 'App sẽ bảo trì từ 23h hôm nay.',
        'time': 'Hôm nay',
        'fromCSYT': false,
        'icon': Icons.settings,
      },
      {
        'title': 'Chính sách mới',
        'message': 'Chính sách bảo mật vừa được cập nhật.',
        'time': '2 ngày trước',
        'fromCSYT': false,
        'icon': Icons.privacy_tip,
      },
    ];

    final filtered = allNotifications
        .where((item) => item['fromCSYT'] == isFromCSYT)
        .toList();

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = filtered[index];

        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFFE6F0FA),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: primaryBlue.withOpacity(0.1),
              child: Icon(
                item['icon'] as IconData,
                color: primaryBlue,
              ),
            ),
            title: Text(
              item['title'] as String,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  item['message'] as String,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item['time'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
            isThreeLine: true,
            onTap: () {
              // Mở chi tiết nếu cần
            },
          ),
        );
      },
    );
  }
}

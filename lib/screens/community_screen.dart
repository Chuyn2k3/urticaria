import 'package:flutter/material.dart';

import '../utils/colors.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const themeColor = Color(0xFF0066CC);

    final posts = [
      {
        "title": "Chăm sóc da mùa hè: Những điều cần lưu ý",
        "author": "Bệnh viện Da liễu TW",
        "date": "12/07/2025",
        "excerpt":
            "Ánh nắng mạnh, mồ hôi và bụi bẩn có thể khiến làn da dễ bị tổn thương. Hãy cùng chúng tôi tìm hiểu các bước chăm sóc da đúng cách...",
      },
      {
        "title": "Cảnh báo bệnh da liễu do thời tiết ẩm",
        "author": "PGS.TS Trần Lan Hương",
        "date": "10/07/2025",
        "excerpt":
            "Thời tiết nồm ẩm khiến các bệnh lý da liễu có xu hướng gia tăng. Đặc biệt là viêm da tiếp xúc, dị ứng... Hãy cùng theo dõi các khuyến cáo từ chuyên gia.",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Cộng đồng'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: posts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final post = posts[index];
          return _buildPostCard(post, themeColor);
        },
      ),
    );
  }

  Widget _buildPostCard(Map<String, String> post, Color themeColor) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post["title"] ?? "",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${post["author"]} • ${post["date"]}',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 12),
            Text(
              post["excerpt"] ?? "",
              style: const TextStyle(fontSize: 15),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () {
                  // TODO: mở chi tiết bài viết
                },
                style: TextButton.styleFrom(foregroundColor: themeColor),
                child: const Text('Xem thêm'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

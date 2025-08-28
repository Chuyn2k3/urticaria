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
        "category": "Chăm sóc da",
        "readTime": "5 phút đọc",
      },
      {
        "title": "Cảnh báo bệnh da liễu do thời tiết ẩm",
        "author": "PGS.TS Trần Lan Hương",
        "date": "10/07/2025",
        "excerpt":
            "Thời tiết nồm ẩm khiến các bệnh lý da liễu có xu hướng gia tăng. Đặc biệt là viêm da tiếp xúc, dị ứng... Hãy cùng theo dõi các khuyến cáo từ chuyên gia.",
        "category": "Bệnh học",
        "readTime": "7 phút đọc",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Cộng đồng',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: themeColor,
        foregroundColor: AppColors.whiteColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: posts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final post = posts[index];
          return _buildPostCard(post, themeColor, index);
        },
      ),
    );
  }

  Widget _buildPostCard(Map<String, String> post, Color themeColor, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 500 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    // TODO: mở chi tiết bài viết
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category and read time
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: themeColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                post["category"] ?? "",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: themeColor,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              post["readTime"] ?? "",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Title
                        Text(
                          post["title"] ?? "",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                            height: 1.3,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Excerpt
                        Text(
                          post["excerpt"] ?? "",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 16),

                        // Author and date
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: themeColor.withOpacity(0.1),
                              child: Icon(
                                Icons.person,
                                size: 16,
                                color: themeColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    post["author"] ?? "",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF374151),
                                    ),
                                  ),
                                  Text(
                                    post["date"] ?? "",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: themeColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                                color: themeColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

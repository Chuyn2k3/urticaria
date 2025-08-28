import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:urticaria/feature/home/widget/section_health_new/section_item.dart';
import '../../../../constant/color.dart';
import '../../../../utils/images.dart';
import '../section_title.dart';

class SectionHealthNew extends StatefulWidget {
  const SectionHealthNew({Key? key}) : super(key: key);

  @override
  State<SectionHealthNew> createState() => _SectionHealthNewState();
}

class _SectionHealthNewState extends State<SectionHealthNew> {
  final CarouselSliderController _controllerSlider = CarouselSliderController();
  int _currentIndex = 0;

  final List<Map<String, String>> healthTips = [
    {
      'title': 'Chăm sóc da mùa hè',
      'description': 'Bảo vệ làn da khỏi tác hại của tia UV',
      'image': ImageEnum.meday,
    },
    {
      'title': 'Điều trị mày đay',
      'description': 'Phương pháp điều trị hiệu quả',
      'image': ImageEnum.meday,
    },
    {
      'title': 'Phòng ngừa dị ứng da',
      'description': 'Những lưu ý quan trọng',
      'image': ImageEnum.meday,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tin tức sức khỏe',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Xem tất cả',
                  style: TextStyle(
                    color: Color(0xFF0066CC),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CarouselSlider(
              options: CarouselOptions(
                height: 200,
                autoPlayInterval: const Duration(seconds: 4),
                autoPlay: true,
                aspectRatio: 2,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                enableInfiniteScroll: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              carouselController: _controllerSlider,
              items: healthTips.map((tip) {
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF0066CC),
                        Color(0xFF004499),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -50,
                        top: -50,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.whiteColor.withOpacity(0.1),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              tip['title'] ?? '',
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              tip['description'] ?? '',
                              style: TextStyle(
                                color: AppColors.whiteColor.withOpacity(0.9),
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Đọc thêm',
                                style: TextStyle(
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Dots indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: healthTips.asMap().entries.map((entry) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _currentIndex == entry.key ? 24 : 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: _currentIndex == entry.key
                    ? const Color(0xFF0066CC)
                    : Colors.grey.shade300,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

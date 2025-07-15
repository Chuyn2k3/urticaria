import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:urticaria/home/widget/section_health_new/section_item.dart';

import '../../../utils/colors.dart';
import '../../../utils/images.dart';
import '../section_title.dart';

class SectionHealthNew extends StatefulWidget {
  const SectionHealthNew({
    Key? key,
  }) : super(key: key);

  @override
  State<SectionHealthNew> createState() => _SectionHealthNewState();
}

class _SectionHealthNewState extends State<SectionHealthNew> {
  final CarouselSliderController _controllerSlider = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
          child: SectionTitle(
            fontWeight: FontWeight.w900,
            title: "",
            color: AppColors.background,
            seeAll: 'Xem tất cả',
            onTap: () {},
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          // padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
          decoration: BoxDecoration(
              // color: AppColors.background,
              borderRadius: BorderRadius.circular(16.0)),
          child: CarouselSlider(
            options: CarouselOptions(
              height: 120,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlay: true,
              aspectRatio: 2,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              enlargeStrategy: CenterPageEnlargeStrategy.height,
              enableInfiniteScroll: true,
              onPageChanged: (index, reason) {},
            ),
            carouselController: _controllerSlider,
            items: List.generate(5, (index) {
              return SectionHealthItems(
                count: 5,
                created: DateTime.now(),
                image: ImageEnum.meday,
                title: "",
                isFixImage: true,
                onPress: () => {},
              );
            }),
          ),
        ),
      ],
    );
  }
}

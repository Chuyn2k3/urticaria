import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:urticaria/home/widget/section_title.dart';

import '../../utils/colors.dart';
import '../../utils/helper.dart';

class PackageCategoryWidget extends StatefulWidget {
  const PackageCategoryWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<PackageCategoryWidget> createState() => _PackageCategoryWidgetState();
}

class _PackageCategoryWidgetState extends State<PackageCategoryWidget> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  Future<void> _scrollListener() async {
    if (_scrollController.offset <=
            _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {}
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
          child: SectionTitle(
            fontWeight: FontWeight.w900,
            title: 'Gói khám nổi bật',
            // color: AppColors.background,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.lightSilver),
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16.0)),
          height: heightConvert(context, 120),
          child: ListView.builder(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {},
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.network(
                        '',
                        fit: BoxFit.fill,
                        errorBuilder: (_, __, ___) {
                          return const Icon(Icons.error);
                        },
                      ),
                    ),
                  ),
                );
              },
              itemCount: 5),
        ),
      ],
    );
  }
}

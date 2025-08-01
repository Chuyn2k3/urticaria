import 'package:flutter/material.dart';
import 'package:urticaria/feature/business/page/business_list_booking.dart';

import '../../widget/appbar/app_bar.dart';

class BusinessPage extends StatefulWidget {
  const BusinessPage({
    Key? key,
  }) : super(key: key);

  @override
  State<BusinessPage> createState() => _BusinessPageState();
}

class _BusinessPageState extends State<BusinessPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Hồ sơ sức khỏe',
        isBack: true,
      ),
      body: Column(
        children: [Expanded(child: BusinessListBooking())],
      ),
    );
  }
}

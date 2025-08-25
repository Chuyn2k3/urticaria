import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urticaria/cubit/uas7/uas7_cubit.dart';
import 'package:urticaria/feature/uas7/uas7_daily_input_widget.dart';
import 'package:urticaria/feature/uas7/uas7_date_selector_widget.dart';
import 'package:urticaria/feature/uas7/uas7_summary_widget.dart';
import 'package:urticaria/widget/appbar/app_bar.dart';
import 'package:urticaria/widget/appbar/custom_app_bar.dart';

class Uas7FollowupScreen extends StatelessWidget {
  const Uas7FollowupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Uas7Cubit(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: CustomAppbar.basic(
          title: 'Theo dõi chấm điểm UAS7',
          onTap: () => Navigator.pop(context),
        ),
        body: const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Uas7DateSelectorWidget(),
              SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Uas7DailyInputWidget(),
                ),
              ),
              Divider(),
              Uas7SummaryWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urticaria/cubit/uas7/uas7_cubit.dart';
import 'package:urticaria/cubit/uas7/uas7_state.dart';

import '../../constant/color.dart';

class Uas7SummaryWidget extends StatelessWidget {
  const Uas7SummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Uas7Cubit, Uas7State>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: AppColors.whiteColor,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
            child: Row(
              children: [
                Expanded(
                    child: _buildScoreItem(
                        'Tổng điểm ngứa (ISS7)', state.totalItchScore)),
                Expanded(
                  child: _buildScoreItem(
                      'Tổng điểm sẩn phù (HSS7)', state.totalWhealScore),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildScoreItem(String label, int score) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Text(score.toString(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            )),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urticaria/cubit/uas7/uas7_cubit.dart';

class Uas7DateSelectorWidget extends StatelessWidget {
  const Uas7DateSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<Uas7Cubit>();
    final selectedDate = cubit.state.selectedDate;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Tooltip(
              message: 'Ngày trước',
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  cubit.selectDate(
                      selectedDate.subtract(const Duration(days: 1)));
                },
              ),
            ),
            Text(
              '${selectedDate.toLocal().toIso8601String().substring(0, 10)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Tooltip(
              message: 'Ngày tiếp theo',
              child: IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  final tomorrow = selectedDate.add(const Duration(days: 1));
                  if (!tomorrow.isAfter(DateTime.now())) {
                    cubit.selectDate(tomorrow);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

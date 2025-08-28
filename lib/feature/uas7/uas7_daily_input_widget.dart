import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urticaria/cubit/uas7/uas7_cubit.dart';
import 'package:urticaria/models/uas7_daily_record.dart';
import 'package:urticaria/utils/colors.dart';

class Uas7DailyInputWidget extends StatefulWidget {
  const Uas7DailyInputWidget({super.key});

  @override
  State<Uas7DailyInputWidget> createState() => _Uas7DailyInputWidgetState();
}

class _Uas7DailyInputWidgetState extends State<Uas7DailyInputWidget> {
  late int itchLevel;
  late int whealLevel;
  late TextEditingController noteController;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<Uas7Cubit>();
    final record = cubit.state.recordForSelectedDate;

    itchLevel = record?.itchLevel ?? 0;
    whealLevel = record?.whealLevel ?? 0;
    noteController = TextEditingController(text: record?.note ?? '');
  }

  void save() {
    final cubit = context.read<Uas7Cubit>();
    final selectedDate = cubit.state.selectedDate;

    cubit.addOrUpdateRecord(Uas7DailyRecord(
      date: selectedDate,
      itchLevel: itchLevel,
      whealLevel: whealLevel,
      note: noteController.text.isEmpty ? null : noteController.text,
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Lưu điểm thành công')),
    );
  }

  @override
  void didUpdateWidget(covariant Uas7DailyInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final cubit = context.read<Uas7Cubit>();
    final record = cubit.state.recordForSelectedDate;

    setState(() {
      itchLevel = record?.itchLevel ?? 0;
      whealLevel = record?.whealLevel ?? 0;
      noteController.text = record?.note ?? '';
    });
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: Colors.white,
      ),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chấm điểm ngày ${context.read<Uas7Cubit>().state.selectedDate.toLocal().toIso8601String().substring(0, 10)}',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Text('Mức độ ngứa (0-3)', style: theme.textTheme.bodyMedium),
            const SizedBox(height: 8),
            _buildDropdown<int>(
              value: itchLevel,
              items: List.generate(
                4,
                (i) => DropdownMenuItem(
                  value: i,
                  child: Text('$i - ${_getItchDescription(i)}'),
                ),
              ),
              onChanged: (val) => setState(() => itchLevel = val ?? 0),
            ),
            const SizedBox(height: 24),
            Text('Mức độ sẩn phù (0-3)', style: theme.textTheme.labelMedium),
            const SizedBox(height: 8),
            _buildDropdown<int>(
              value: whealLevel,
              items: List.generate(
                4,
                (i) => DropdownMenuItem(
                  value: i,
                  child: Text('$i - ${_getWhealDescription(i)}'),
                ),
              ),
              onChanged: (val) => setState(() => whealLevel = val ?? 0),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                labelText: 'Ghi chú (tuỳ chọn)',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              maxLines: 3,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: save,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  backgroundColor: AppColors.primary,
                ),
                child: const Text('Lưu',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
        color: Colors.white,
      ),
      child: DropdownButton<T>(
        value: value,
        items: items,
        onChanged: onChanged,
        isExpanded: true,
        underline: const SizedBox(),
        iconEnabledColor: Colors.blueAccent,
      ),
    );
  }

  String _getItchDescription(int level) {
    switch (level) {
      case 0:
        return 'Không ngứa';
      case 1:
        return 'Ngứa nhẹ, không khó chịu';
      case 2:
        return 'Ngứa nhiều, khó chịu nhưng chịu được';
      case 3:
        return 'Ngứa rất nhiều, không thể chịu đựng';
      default:
        return '';
    }
  }

  String _getWhealDescription(int level) {
    switch (level) {
      case 0:
        return 'Không nổi sẩn';
      case 1:
        return 'Nổi <20 sẩn';
      case 2:
        return 'Nổi 20-50 sẩn';
      case 3:
        return 'Nổi >50 sẩn';
      default:
        return '';
    }
  }
}

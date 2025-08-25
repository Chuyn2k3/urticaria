import 'package:equatable/equatable.dart';
import 'package:urticaria/models/uas7_daily_record.dart';

class Uas7State extends Equatable {
  final List<Uas7DailyRecord> records;
  final DateTime selectedDate;

  const Uas7State({
    this.records = const [],
    required this.selectedDate,
  });

  int get totalItchScore => records.fold(0, (sum, r) => sum + r.itchLevel);

  int get totalWhealScore => records.fold(0, (sum, r) => sum + r.whealLevel);

  @override
  List<Object?> get props => [records, selectedDate];

  Uas7DailyRecord? get recordForSelectedDate {
    try {
      return records.firstWhere((r) =>
          r.date.year == selectedDate.year &&
          r.date.month == selectedDate.month &&
          r.date.day == selectedDate.day);
    } catch (_) {
      return null;
    }
  }

  Uas7State copyWith({
    List<Uas7DailyRecord>? records,
    DateTime? selectedDate,
  }) {
    return Uas7State(
      records: records ?? this.records,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}

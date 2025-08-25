import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urticaria/cubit/uas7/uas7_state.dart';
import 'package:urticaria/models/uas7_daily_record.dart';

class Uas7Cubit extends Cubit<Uas7State> {
  Uas7Cubit() : super(Uas7State(selectedDate: DateTime.now()));

  void selectDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  void addOrUpdateRecord(Uas7DailyRecord newRecord) {
    final records = List<Uas7DailyRecord>.from(state.records);
    final index = records.indexWhere((r) =>
        r.date.year == newRecord.date.year &&
        r.date.month == newRecord.date.month &&
        r.date.day == newRecord.date.day);

    if (index != -1) {
      records[index] = newRecord;
    } else {
      records.add(newRecord);
    }

    records.sort((a, b) => a.date.compareTo(b.date));

    // Giữ lại 14 ngày gần nhất
    while (records.length > 14) {
      records.removeAt(0);
    }

    emit(state.copyWith(records: records));
  }
}

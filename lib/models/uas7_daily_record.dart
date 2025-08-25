class Uas7DailyRecord {
  final DateTime date;
  final int itchLevel; // 0-3
  final int whealLevel; // 0-3
  final String? note;

  Uas7DailyRecord({
    required this.date,
    required this.itchLevel,
    required this.whealLevel,
    this.note,
  });

  Uas7DailyRecord copyWith({
    int? itchLevel,
    int? whealLevel,
    String? note,
  }) {
    return Uas7DailyRecord(
      date: date,
      itchLevel: itchLevel ?? this.itchLevel,
      whealLevel: whealLevel ?? this.whealLevel,
      note: note ?? this.note,
    );
  }
}

class OpenHours {
  final String dayOfWeek;
  final String meridiem;
  final DateTime openTime;
  final DateTime closeTime;
  OpenHours({
    required this.dayOfWeek,
    required this.meridiem,
    required this.openTime,
    required this.closeTime,
  });

  OpenHours copyWith({
    String? dayOfWeek,
    String? meridiem,
    DateTime? openTime,
    DateTime? closeTime,
  }) {
    return OpenHours(
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      meridiem: meridiem ?? this.meridiem,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dayOfWeek': dayOfWeek,
      'meridiem': meridiem,
      'openTime': openTime.millisecondsSinceEpoch,
      'closeTime': closeTime.millisecondsSinceEpoch,
    };
  }

  factory OpenHours.fromMap(Map<String, dynamic> map) {
    return OpenHours(
      dayOfWeek: map['dayOfWeek'] as String,
      meridiem: map['meridiem'] as String,
      openTime: DateTime.fromMillisecondsSinceEpoch(map['openTime'] as int),
      closeTime: DateTime.fromMillisecondsSinceEpoch(map['closeTime'] as int),
    );
  }

  @override
  String toString() =>
      'OpenHours(dayOfWeek: $dayOfWeek, meridiem: $meridiem, openTime: $openTime, closeTime: $closeTime)';

  @override
  bool operator ==(covariant OpenHours other) {
    if (identical(this, other)) return true;

    return other.dayOfWeek == dayOfWeek &&
        other.meridiem == meridiem &&
        other.openTime == openTime &&
        other.closeTime == closeTime;
  }

  @override
  int get hashCode =>
      dayOfWeek.hashCode ^
      meridiem.hashCode ^
      openTime.hashCode ^
      closeTime.hashCode;
}

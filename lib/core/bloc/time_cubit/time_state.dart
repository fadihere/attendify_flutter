import 'package:flutter/material.dart';

@immutable
class TimeState {
  final String time;
  final String day;
  final String dMy;

  const TimeState({
    required this.time,
    required this.day,
    required this.dMy,
  });

  copyWith({
    String? time,
    String? day,
    String? dMy,
  }) {
    return TimeState(
      day: day ?? this.day,
      time: time ?? this.time,
      dMy: dMy ?? this.dMy,
    );
  }
}

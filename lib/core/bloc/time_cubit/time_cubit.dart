import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';

import 'time_state.dart';

class TimeCubit extends Cubit<TimeState> {
  TimeCubit()
      : super(TimeState(
          time: DateFormat.jm().format(DateTime.now()),
          day: DateFormat('EEEE').format(DateTime.now()),
          dMy: DateFormat('MMM dd, yyyy').format(DateTime.now()),
        ));

  init() {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      DateTime date = DateTime.now();
      try {
        date = await NTP.now();
      } catch (e) {
        date = DateTime.now();
      }
      emit(state.copyWith(
        time: DateFormat.jm().format(date),
        day: DateFormat('EEEE').format(date),
        dMy: DateFormat('MMM dd, yyyy').format(date),
      ));
    });
  }
}

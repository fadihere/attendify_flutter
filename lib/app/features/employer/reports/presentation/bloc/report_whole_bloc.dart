import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'report_whole_event.dart';
part 'report_whole_state.dart';

class ReportWholeBloc extends Bloc<ReportEvent, ReportState> {
  ReportWholeBloc() : super(const ReportState()) {
    on<SelectReportEvent>((event, emit) {
      emit(state.copyWith(reportType: event.selectedReport));
    });
  }
}

part of 'report_whole_bloc.dart';

class ReportEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SelectReportEvent extends ReportEvent {
  final String selectedReport;

  SelectReportEvent({
    required this.selectedReport,
  });
}

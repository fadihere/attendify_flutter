part of 'report_whole_bloc.dart';

class ReportState extends Equatable {
  final String reportType;
  const ReportState({
     this.reportType = "",
  });

  @override
  List<Object?> get props => [reportType];

  ReportState copyWith({
    String? reportType,
  }) {
    return ReportState(
      reportType: reportType ?? this.reportType,
    );
  }
}

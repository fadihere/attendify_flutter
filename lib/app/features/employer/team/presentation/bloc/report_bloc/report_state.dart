// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'report_bloc.dart';

class ReportState extends Equatable {
  final Status status;
  final List<LogsModel> logsList;
  final int presents;
  final int absents;
  final int lates;

  final List<InvoiceModel> invoice;
  const ReportState(
      {this.status = Status.initial,
      this.logsList = const [],
      this.presents = 0,
      this.absents = 0,
      this.lates = 0,
      this.invoice = const []});

  @override
  List<Object> get props => [
        status,
        logsList,
        presents,
        absents,
        lates,
        invoice,
      ];

  ReportState copyWith({
    Status? status,
    List<LogsModel>? logsList,
    int? presents,
    int? absents,
    int? lates,
    List<InvoiceModel>? invoice,
  }) {
    return ReportState(
      status: status ?? this.status,
      logsList: logsList ?? this.logsList,
      presents: presents ?? this.presents,
      absents: absents ?? this.absents,
      lates: lates ?? this.lates,
      invoice: invoice ?? this.invoice,
    );
  }
}

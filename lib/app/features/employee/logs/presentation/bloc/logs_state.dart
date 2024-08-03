// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'logs_bloc.dart';

class LogsState extends Equatable {
  final bool isLoadingState;
  final bool isInitState;
  final bool isSuccessState;
  final bool isFailedState;
  final String errorMessage;
  final List<LogsModel> logsList;
  final DateTime? startDate;
  final DateTime? endDate;

  const LogsState(
      {this.isLoadingState = false,
      this.isInitState = true,
      this.isFailedState = false,
      this.isSuccessState = false,
      this.errorMessage = '',
      this.logsList = const [],
      this.startDate,
      this.endDate});

  @override
  List<Object?> get props => [
        isLoadingState,
        isInitState,
        isFailedState,
        isSuccessState,
        errorMessage,
        logsList,
        startDate,
        endDate
      ];

  LogsState copyWith({
    bool? isLoadingState,
    bool? isInitStateState,
    bool? isSuccessState,
    bool? isFailedState,
    String? errorMessage,
    List<LogsModel>? logsList,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return LogsState(
      isLoadingState: isLoadingState ?? this.isLoadingState,
      isInitState: isInitStateState ?? isInitState,
      isSuccessState: isSuccessState ?? this.isSuccessState,
      isFailedState: isFailedState ?? this.isFailedState,
      errorMessage: errorMessage ?? this.errorMessage,
      logsList: logsList ?? this.logsList,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

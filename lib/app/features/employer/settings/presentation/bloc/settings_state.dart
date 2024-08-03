// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'settings_bloc.dart';

class SettingsEmrState extends Equatable {
  final Status? status;
  final bool loading;
  // final List<String> selectedWorkingDays;

  final WorkHrsModel? officeHrsModel;
  const SettingsEmrState({
    this.status,
    this.loading = false,
    // this.selectedWorkingDays = const [],
    this.officeHrsModel,
  });

  @override
  List<Object?> get props => [
        status,
        officeHrsModel,
        loading,
      ];

  SettingsEmrState copyWith({
    Status? status,
    bool? loading,
    WorkHrsModel? officeHrsModel,
  }) {
    return SettingsEmrState(
      status: status ?? this.status,
      loading: loading ?? this.loading,
      officeHrsModel: officeHrsModel ?? this.officeHrsModel,
    );
  }
}

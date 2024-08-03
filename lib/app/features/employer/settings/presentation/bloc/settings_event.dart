// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'settings_bloc.dart';

abstract class SettingsEmrEvent extends Equatable {
  const SettingsEmrEvent();

  @override
  List<Object> get props => [];
}

class UploadNewNumberEvent extends SettingsEmrEvent {}

class DeleteEmployerEvent extends SettingsEmrEvent {
  final String employerID;
  const DeleteEmployerEvent({required this.employerID});
}

class UpdateOfficeHrsEvent extends SettingsEmrEvent {
  final String employerID;
  final WorkHrsModel workHrsModel;

  const UpdateOfficeHrsEvent({
    required this.employerID,
    required this.workHrsModel,
  });
}

class FetchOfficeHrsEvent extends SettingsEmrEvent {
  final String employerID;
  const FetchOfficeHrsEvent({required this.employerID});
}

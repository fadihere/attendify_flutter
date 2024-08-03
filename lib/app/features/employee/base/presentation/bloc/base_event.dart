part of 'base_bloc.dart';

sealed class BaseEmpEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ChangeIndexEvent extends BaseEmpEvent {
  final int index;
  ChangeIndexEvent({required this.index});
}

part of 'base_bloc.dart';

abstract class BaseEmrState extends Equatable {
  const BaseEmrState();

  @override
  List<Object> get props => [];
}

class BaseInitial extends BaseEmrState {}

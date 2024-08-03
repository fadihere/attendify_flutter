import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'base_event.dart';
part 'base_state.dart';

class BaseEmpBloc extends Bloc<BaseEmpEvent, BaseEmpState> {
  BaseEmpBloc() : super(const BaseEmpState());
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'base_event.dart';
part 'base_state.dart';

class BaseEmrBloc extends Bloc<BaseEmrEvent, BaseEmrState> {
  BaseEmrBloc() : super(BaseInitial()) {
    on<BaseEmrEvent>((event, emit) {});
  }
}

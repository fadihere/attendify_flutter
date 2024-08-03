import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../app/features/employee/auth/data/datasources/local_db.dart';
import '../../../app/features/employer/auth/data/datasources/emr_local_db.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final AuthLocalDBEmrImpl authLocalEmr;
  final AuthLocalDBEmpImpl authLocalEmp;
  UserCubit({
    required this.authLocalEmr,
    required this.authLocalEmp,
  }) : super(UserStateInitial());

  void init() async {
    // final location = Location.instance;
    // final position = await location.getLocation();

    // if (position.isMock ?? false) {
    //   emit(MockLocation());
    // } else {
    //   try {
    //     authLocalEmp.getCurrentUser();
    //     emit(EmpLoggedIn());
    //     return;
    //   } catch (_) {}

    //   try {
    //     authLocalEmr.getCurrentUser();
    //     emit(EmrLoggedIn());
    //     return;
    //   } catch (_) {}
    //   emit(UserNotLoggedIn());
    // }
    try {
      authLocalEmp.getCurrentUser();
      emit(EmpLoggedIn());
      return;
    } catch (_) {}

    try {
      authLocalEmr.getCurrentUser();
      emit(EmrLoggedIn());
      return;
    } catch (_) {}
    emit(UserNotLoggedIn());
  }
}

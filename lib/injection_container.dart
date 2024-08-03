import 'package:attendify_lite/app/features/employee/Notifications/data/datasources/noti_emp_remote_db.dart';
import 'package:attendify_lite/app/features/employee/Notifications/data/repositories/noti_emp_repo.dart';
import 'package:attendify_lite/app/features/employee/Notifications/presentation/bloc/notifications_emp_bloc.dart';
import 'package:attendify_lite/app/features/employee/auth/data/repositories/emp_auth_repo.dart';
import 'package:attendify_lite/app/features/employee/auth/presentation/bloc/auth_bloc.dart';
import 'package:attendify_lite/app/features/employee/base/presentation/bloc/base_bloc.dart';
import 'package:attendify_lite/app/features/employee/home/data/datasources/home_remote_emp_db.dart';
import 'package:attendify_lite/app/features/employee/home/data/repositories/home_repo_emp.dart';
import 'package:attendify_lite/app/features/employee/home/presentation/bloc/camera_bloc/camera_bloc.dart';
import 'package:attendify_lite/app/features/employee/leave/data/datasources/leave_remote_emp_db.dart';
import 'package:attendify_lite/app/features/employee/leave/data/repositories/leave_repo_emp.dart';
import 'package:attendify_lite/app/features/employee/logs/data/datasources/logs_remote_db.dart';
import 'package:attendify_lite/app/features/employee/logs/data/repositories/logs_repo.dart';
import 'package:attendify_lite/app/features/employee/logs/presentation/bloc/logs_bloc.dart';
import 'package:attendify_lite/app/features/employer/auth/presentation/bloc/auth_bloc.dart';
import 'package:attendify_lite/app/features/employer/home/data/datasource/remote_db.dart';
import 'package:attendify_lite/app/features/employer/leave/data/network_services/remote_db.dart';
import 'package:attendify_lite/app/features/employer/leave/data/repositories/leave_repo.dart';
import 'package:attendify_lite/app/features/employer/leave/presentation/bloc/leave_emr_bloc.dart';
import 'package:attendify_lite/app/features/employer/location/data/datasources/loc_remote_db.dart';
import 'package:attendify_lite/app/features/employer/location/data/repositories/loc_repo_emr.dart';
import 'package:attendify_lite/app/features/employer/location/presentation/bloc/pick_location_bloc.dart';
import 'package:attendify_lite/app/features/employer/notifications/data/datasources/noti_remote_db.dart';
import 'package:attendify_lite/app/features/employer/notifications/data/respostories/noti_repo.dart';
import 'package:attendify_lite/app/features/employer/notifications/presentation/blocs/noti_emr_bloc.dart';
import 'package:attendify_lite/app/features/employer/reports/data/datasources/remote_reports.dart';
import 'package:attendify_lite/app/features/employer/reports/presentation/bloc/report_whole_bloc.dart';
import 'package:attendify_lite/app/features/employer/settings/data/datasource/setting_remote_db.dart';
import 'package:attendify_lite/app/features/employer/settings/data/repositories/settings_repositories_emr.dart';
import 'package:attendify_lite/app/features/employer/settings/presentation/bloc/settings_bloc.dart';
import 'package:attendify_lite/app/features/employer/team/presentation/bloc/report_bloc/report_bloc.dart';
import 'package:attendify_lite/app/features/employer/team/presentation/bloc/work_time_bloc/work_time_bloc.dart';
import 'package:attendify_lite/core/bloc/location_bloc/location_bloc.dart';
import 'package:attendify_lite/core/bloc/theme_cubit/theme_cubit.dart';
import 'package:attendify_lite/core/bloc/time_cubit/time_cubit.dart';
import 'package:attendify_lite/core/bloc/user_cubit/user_cubit.dart';
import 'package:attendify_lite/core/utils/functions/functions.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/features/employee/auth/data/datasources/local_db.dart';
import 'app/features/employee/auth/data/datasources/remote_db.dart';
import 'app/features/employee/leave/presentation/bloc/leave_bloc.dart';
import 'app/features/employee/settings/presentation/bloc/settings_bloc.dart';
import 'app/features/employer/auth/data/datasources/emr_local_db.dart';
import 'app/features/employer/auth/data/datasources/emr_remote_db.dart';
import 'app/features/employer/auth/data/repositories/emr_auth_repo.dart';
import 'app/features/employer/home/data/repositories/home_repository_emr.dart';
import 'app/features/employer/home/presentation/bloc/adm_home_bloc.dart';
import 'app/features/employer/singular/data/datasources/singular_local.dart';
import 'app/features/employer/singular/data/datasources/singular_remote.dart';
import 'app/features/employer/singular/data/repositories/singular_repo.dart';
import 'app/features/employer/team/data/datasources/team_remote.dart';
import 'app/features/employer/team/data/repositories/team_repo.dart';
import 'app/features/employer/team/presentation/bloc/team_bloc/team_bloc.dart';
import 'core/config/routes/app_router.dart';
import 'core/constants/app_constants.dart';
import 'core/gen/assets.gen.dart';
import 'core/network/network_info.dart';
import 'core/services/database/object_box.dart';

//*Service Locator
final sl = GetIt.instance;

Future<void> init() async {
  //! Features

  //* Blocs
  sl.registerFactory(() => ThemeCubit());
  sl.registerFactory(() => UserCubit(authLocalEmr: sl(), authLocalEmp: sl()));
  sl.registerFactory(() => AuthEmpBloc(authRepo: sl()));
  sl.registerFactory(() => AuthEmrBloc(auth: sl(), singularLocal: sl()));
  sl.registerFactory(() => BaseEmpBloc());
  sl.registerFactory(() => SettingsEmpBloc());
  sl.registerFactory(() => LogsBloc(logsRepo: sl()));
  sl.registerFactory(() => LocationBloc(homeRepo: sl()));
  sl.registerFactory(() => LeaveBloc(repo: sl()));
  sl.registerFactory(() => TimeCubit());
  sl.registerFactory(() => SettingsEmrBloc(settingRepoEmr: sl()));
  sl.registerFactory(() => AdmHomeBloc(homeRepoEmr: sl()));
  sl.registerFactory(() => CameraBloc());
  sl.registerFactory(() => TeamBloc(teamRepo: sl(), user: sl()));
  sl.registerFactory(() => PickLocationBloc(locRepo: sl()));
  sl.registerFactory(() => NotificationsEmpBloc(repo: sl()));
  sl.registerFactory(() => ReportBloc(repo: sl(), reportsRepo: sl()));
  sl.registerFactory(() => WorkTimeBloc(teamRepo: sl()));
  // sl.registerFactory(() => SingularBloc(singularRepo: sl()));
  sl.registerFactory(() => NotiEmrBloc(repo: sl(), homeRepo: sl()));
  sl.registerFactory(() => LeaveEmrBloc(repo: sl()));
  sl.registerFactory(() => ReportWholeBloc());

  //! Core

  //* Repos
  sl.registerLazySingleton(
    () => AuthRepoEmpImpl(
      networkInfo: sl(),
      authRemote: sl(),
      authLocal: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => LeaveRepoImpl(
      networkInfo: sl(),
      leaveDB: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => LeaveRepoEmpImpl(
      networkInfo: sl(),
      remoteDB: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => AuthRepoEmrImpl(
      networkInfo: sl(),
      authRemote: sl(),
      authLocal: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => HomeRepoEmrImpl(
      networkInfo: sl(),
      homeDB: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => LogsRepoImpl(
      logsRemoteDB: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => HomeRepoEmpImpl(
      empHomeRemoteDB: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => TeamRepoImpl(
      teamDB: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => LocRepoEmrImpl(
      networkInfo: sl(),
      locDB: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => SettingRepoEmrImpl(
      networkInfo: sl(),
      settingRemoteDBEmrImpl: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => NotficationEmpRepoImpl(
      networkInfo: sl(),
      notificationDB: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => NotiRepoImpl(
      networkInfo: sl(),
      db: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => SingularRepoImpl(
      remote: sl(),
      local: sl(),
    ),
  );

  sl.registerFactory(() => NetworkInfoImpl(sl()));

  //* Functions
  sl.registerFactory(() => getCountryCode());

  //* Data sources
  sl.registerFactory(() => AuthRemoteDBEmpImpl(dio: sl()));
  sl.registerFactory(() => AuthRemoteDBEmrImpl(dio: sl()));
  sl.registerFactory(() => AuthLocalDBEmpImpl(box: sl()));
  sl.registerFactory(() => AuthLocalDBEmrImpl(box: sl()));
  sl.registerFactory(() => LogsRemoteDBImpl(dio: sl()));
  sl.registerFactory(() => HomeRemoteDBEmpImpl(dio: sl()));
  sl.registerFactory(() => HomeRemoteEmrDBImpl(dio: sl()));
  sl.registerFactory(() => SettingRemoteEmrDBImpl(dio: sl()));
  sl.registerFactory(() => NotiEmpRemoteDBImpl(dio: sl()));
  sl.registerFactory(() => SingularLocalImpl());
  sl.registerFactory(() => SingularRemoteImpl(dio: sl()));
  sl.registerFactory(() => TeamRemoteDBImpl(dio: sl()));
  sl.registerFactory(() => LocRemoteDBImpl(dio: sl()));
  sl.registerFactory(() => RemoteReportsImpl(dio: sl()));
  sl.registerFactory(() => NotiRemoteEmrDBImpl(dio: sl()));
  sl.registerFactory(() => LeaveRemoteDBImpl(dio: sl()));
  sl.registerFactory(() => LeaveRemoteDBEmpImpl(dio: sl()));

  //! External
  final sharedPred = await SharedPreferences.getInstance();
  sl.registerFactory(() => sharedPred);
  sl.registerFactory(() => Connectivity());
  sl.registerFactory(() => Dio(BaseOptions(baseUrl: AppConst.baseurl)));
  sl.registerLazySingleton<AppRouter>(() => AppRouter());
  final box = await ObjectBox.create();
  sl.registerFactory(() => box);

  //! OThers
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );

  for (final image in Assets.icons.values) {
    final loader = SvgAssetLoader(image.path);
    await svg.cache.putIfAbsent(
      loader.cacheKey(null),
      () => loader.loadBytes(null),
    );
  }
}

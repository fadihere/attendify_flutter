// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:io';

// import 'package:dartz/dartz.dart';

// import '../../../../../../core/error/exceptions.dart';
// import '../../../../../../core/error/failures.dart';
// import '../../../../../../core/network/network_info.dart';
// import '../../../auth/data/models/user_emp_model.dart';
// import '../datasources/settings_remote_datasource.dart';

// abstract class AuthRepoEmp {
//   Future<Either<Failure, Map<String, dynamic>>> changePhone(
//     UserEmpModel user,
//     String phoneNo,
//   );
//   // Future<Either<Failure,>>
// }

// class AuthRepoEmpImpl implements AuthRepoEmp {
//   final SettingRemoteDBEmpImpl settingsRemote;
//   final NetworkInfoImpl networkInfo;

//   AuthRepoEmpImpl({
//     required this.settingsRemote,
//     required this.networkInfo,
//   });


// }

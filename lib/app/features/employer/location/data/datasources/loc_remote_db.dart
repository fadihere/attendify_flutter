import 'dart:developer';

import 'package:attendify_lite/app/features/employer/location/data/models/loc_emr_model.dart';
import 'package:attendify_lite/app/features/employer/place_picker/entities/location_result.dart';
import 'package:dio/dio.dart';

import '../../../team/data/models/team_model.dart';

abstract class LocRemoteDB {
  Future<List<LocEmrModel>> fetchAllLocationsAPI({required String employerID});
  Future<bool> deleteLocationAPI({required int locationID});
  Future<LocEmrModel> saveLocationAPI({
    required String employerID,
    required String locationName,
    required LocationResult locationResult,
    required double radius,
  });

  Future<int> getMaxLocationID();
  Future<bool> updateEmployeeLocation(TeamModel team);
}

class LocRemoteDBImpl extends LocRemoteDB {
  final Dio dio;
  LocRemoteDBImpl({required this.dio});
  @override
  Future<List<LocEmrModel>> fetchAllLocationsAPI(
      {required String employerID}) async {
    final response = await dio.get('/GetAllLocationsByEmployerId/$employerID/');
    List<LocEmrModel> loc = [];
    if (response.statusCode == 200) {
      for (int i = 0; i < response.data.length; i++) {
        loc.add(LocEmrModel.fromMap(response.data[i]));
      }
      return loc;
    }
    throw 'Unknown Error Occured';
  }

  @override
  Future<bool> deleteLocationAPI({required int locationID}) async {
    final response = await dio.delete(
      'location/delete/$locationID',
    );
    if (response.statusCode == 200) {
      return true;
    }
    throw 'Unknown Error Occured';
  }

  @override
  Future<LocEmrModel> saveLocationAPI({
    required String employerID,
    required LocationResult locationResult,
    required double radius,
    required String locationName,
  }) async {
    final locID = await getMaxLocationID();
    final response = await dio.post('location/',
        data: {
          "department_id": '',
          'employer_id': employerID,
          'location_id': locID + 1,
          'location_name': locationName,
          'longitude': locationResult.latLng?.longitude.toString(),
          'latitude': locationResult.latLng?.latitude.toString(),
          'allowed_radius': radius.toString(),
          'is_active': true,
          'is_deleted': false,
          'created_by': employerID,
        },
        options: Options(receiveTimeout: const Duration(seconds: 3)));

    if (response.statusCode == 201) {
      return LocEmrModel.fromMap(response.data);
    }

    throw 'Unknown Error Occured';
  }

  @override
  Future<int> getMaxLocationID() async {
    final response = await dio.get(
      'GetMaxLocationId/',
    );
    if (response.statusCode == 200) {
      return response.data;
    }
    throw 'Unknown Error Occured';
  }

  @override
  Future<bool> updateEmployeeLocation(TeamModel team) async {
    log(team.employeeId);
    final url = 'employee/update/${team.employeeId}/';
    final data = FormData.fromMap({'location_id': team.locationId});
    final res = await dio.patch(url, data: data);
    if (res.statusCode == 200) return true;
    throw 'Something went wrong';
  }
}

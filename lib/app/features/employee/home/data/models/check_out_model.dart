import 'dart:convert';

class CheckOutModel {
  final String employerId;
  final String employeesId;
  final String employeeId;
  final DateTime recordedTimeOut;
  final DateTime shiftTimeOut;
  final int outLocationId;
  final String outLongitude;
  final String outLatitude;

  CheckOutModel({
    required this.employerId,
    required this.employeesId,
    required this.employeeId,
    required this.shiftTimeOut,
    required this.recordedTimeOut,
    required this.outLocationId,
    required this.outLongitude,
    required this.outLatitude,
  });

  factory CheckOutModel.fromRawJson(String str) =>
      CheckOutModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CheckOutModel.fromJson(Map<String, dynamic> json) => CheckOutModel(
        employerId: json["employer_id"],
        employeeId: json["employee_id"],
        employeesId: json["employees_id"],
        recordedTimeOut: DateTime.parse(json["recorded_time_out"]),
        shiftTimeOut: DateTime.parse(json["shift_time_out"]),
        outLocationId: json["out_location_id"],
        outLongitude: json["out_longitude"],
        outLatitude: json["out_latitude"],
      );

  Map<String, dynamic> toJson() => {
        "employer_id": employerId,
        "employee_id": employeeId,
        "employees_id": employeesId,
        "recorded_time_out": recordedTimeOut.toString(),
        "shift_time_out": shiftTimeOut.toString(),
        "out_location_id": outLocationId,
        "out_longitude": outLongitude,
        "out_latitude": outLatitude,
      };
}

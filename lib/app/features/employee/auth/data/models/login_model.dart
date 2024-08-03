import 'dart:convert';

class LoginModel {
  final String response;
  final int? count;

  LoginModel({
    required this.response,
    this.count,
  });

  LoginModel copyWith({
    String? response,
    int? count,
  }) =>
      LoginModel(
        response: response ?? this.response,
        count: count ?? this.count,
      );

  factory LoginModel.fromJson(String str) =>
      LoginModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginModel.fromMap(Map<String, dynamic> json) => LoginModel(
        response: json["response"],
        count: json["count"],
      );

  Map<String, dynamic> toMap() => {
        "response": response,
        "count": count,
      };
}

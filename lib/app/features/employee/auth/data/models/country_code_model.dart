import 'dart:convert';

class CountryCodeModel {
  final String status;
  final String country;
  final String countryCode;
  final String region;
  final String regionName;
  final String city;
  final String zip;
  final double lat;
  final double lon;
  final String timezone;
  final String isp;
  final String org;
  final String countryCodeModelAs;
  final String query;

  CountryCodeModel({
    required this.status,
    required this.country,
    required this.countryCode,
    required this.region,
    required this.regionName,
    required this.city,
    required this.zip,
    required this.lat,
    required this.lon,
    required this.timezone,
    required this.isp,
    required this.org,
    required this.countryCodeModelAs,
    required this.query,
  });

  factory CountryCodeModel.fromJson(String str) =>
      CountryCodeModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CountryCodeModel.fromMap(Map<String, dynamic> json) =>
      CountryCodeModel(
        status: json["status"],
        country: json["country"],
        countryCode: json["countryCode"],
        region: json["region"],
        regionName: json["regionName"],
        city: json["city"],
        zip: json["zip"],
        lat: json["lat"],
        lon: json["lon"],
        timezone: json["timezone"],
        isp: json["isp"],
        org: json["org"],
        countryCodeModelAs: json["as"],
        query: json["query"],
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "country": country,
        "countryCode": countryCode,
        "region": region,
        "regionName": regionName,
        "city": city,
        "zip": zip,
        "lat": lat,
        "lon": lon,
        "timezone": timezone,
        "isp": isp,
        "org": org,
        "as": countryCodeModelAs,
        "query": query,
      };
}

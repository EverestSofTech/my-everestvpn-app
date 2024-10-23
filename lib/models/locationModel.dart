import 'dart:convert';

class LocationModel {
  dynamic success;
  dynamic ip;
  dynamic type;
  Country country;
  dynamic region;
  dynamic city;
  Location location;
  dynamic timeZone;
  Asn asn;

  LocationModel({
    required this.success,
    required this.ip,
    required this.type,
    required this.country,
    required this.region,
    required this.city,
    required this.location,
    required this.timeZone,
    required this.asn,
  });

  factory LocationModel.fromRawJson(String str) =>
      LocationModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        success: json["success"],
        ip: json["ip"],
        type: json["type"],
        country: Country.fromJson(json["country"]),
        region: json["region"],
        city: json["city"] ?? '',
        location: Location.fromJson(json["location"]),
        timeZone: json["timeZone"],
        asn: Asn.fromJson(json["asn"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "ip": ip,
        "type": type,
        "country": country.toJson(),
        "region": region,
        "city": city,
        "location": location.toJson(),
        "timeZone": timeZone,
        "asn": asn.toJson(),
      };
}

class Asn {
  dynamic number;
  dynamic name;
  dynamic network;

  Asn({
    required this.number,
    required this.name,
    required this.network,
  });

  factory Asn.fromRawJson(String str) => Asn.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Asn.fromJson(Map<String, dynamic> json) => Asn(
        number: json["number"],
        name: json["name"],
        network: json["network"],
      );

  Map<String, dynamic> toJson() => {
        "number": number,
        "name": name,
        "network": network,
      };
}

class Country {
  dynamic code;
  dynamic name;

  Country({
    required this.code,
    required this.name,
  });

  factory Country.fromRawJson(String str) => Country.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        code: json["code"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
      };
}

class Location {
  dynamic lat;
  dynamic lon;

  Location({
    required this.lat,
    required this.lon,
  });

  factory Location.fromRawJson(String str) =>
      Location.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json["lat"]?.toDouble(),
        lon: json["lon"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lon": lon,
      };
}

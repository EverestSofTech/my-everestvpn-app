import 'dart:convert';

class ServerModel {
  bool status;
  List<ServerModelServer> servers;

  ServerModel({
    required this.status,
    required this.servers,
  });

  factory ServerModel.fromRawJson(String str) =>
      ServerModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ServerModel.fromJson(Map<String, dynamic> json) => ServerModel(
        status: json["status"],
        servers: List<ServerModelServer>.from(
            json["servers"].map((x) => ServerModelServer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "servers": List<dynamic>.from(servers.map((x) => x.toJson())),
      };
}

class ServerModelServer {
  String type;
  bool isFree;
  String serverName;
  String stateName;
  String flagUrl;
  String latitude;
  String longitude;
  String? address;
  String? password;
  String? allowedIp;
  String? dns;
  String? endPoints;
  String? parsePreSharedKey;
  String? privateKey;
  String? publicKey;
  String? serverCount;
  List<ServerServer> servers;
  String? ovpnConfiguration;
  String? vpnUserName;
  String? vpnPassword;

  ServerModelServer({
    required this.type,
    required this.isFree,
    required this.serverName,
    required this.latitude,
    required this.longitude,
    required this.stateName,
    required this.flagUrl,
    this.address,
    this.password,
    this.allowedIp,
    this.dns,
    this.endPoints,
    this.parsePreSharedKey,
    this.privateKey,
    this.publicKey,
    required this.serverCount,
    required this.servers,
    this.ovpnConfiguration,
    this.vpnUserName,
    this.vpnPassword,
  });

  factory ServerModelServer.fromRawJson(String str) =>
      ServerModelServer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ServerModelServer.fromJson(Map<String, dynamic> json) =>
      ServerModelServer(
        type: json["type"],
        isFree: json["isFree"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        serverName: json["serverName"],
        stateName: json["stateName"],
        flagUrl: json["flag_url"],
        address: json["address"],
        password: json["password"],
        allowedIp: json["allowedIP"],
        dns: json["dns"],
        endPoints: json["endPoints"],
        parsePreSharedKey: json["parsePreSharedKey"],
        privateKey: json["privateKey"],
        publicKey: json["publicKey"],
        serverCount: json["serverCount"],
        servers: List<ServerServer>.from(
            json["servers"].map((x) => ServerServer.fromJson(x))),
        ovpnConfiguration: json["ovpnConfiguration"],
        vpnUserName: json["vpnUserName"],
        vpnPassword: json["vpnPassword"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "isFree": isFree,
        "serverName": serverName,
        "latitude": latitude,
        "longitude": longitude,
        "stateName": stateName,
        "flag_url": flagUrl,
        "address": address,
        "allowedIP": allowedIp,
        "dns": dns,
        "endPoints": endPoints,
        "parsePreSharedKey": parsePreSharedKey,
        "privateKey": privateKey,
        "publicKey": publicKey,
        "serverCount": serverCount,
        "servers": List<dynamic>.from(servers.map((x) => x.toJson())),
        "ovpnConfiguration": ovpnConfiguration,
        "vpnUserName": vpnUserName,
        "vpnPassword": vpnPassword,
      };
}

class ServerServer {
  String serverName;
  String stateName;
  String latitude;
  String longitude;
  String country;
  String flagUrl;
  String? address;
  String? password;
  String? ovpnConfiguration;
  String? vpnUserName;
  String? vpnPassword;

  ServerServer({
    required this.serverName,
    required this.stateName,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.flagUrl,
    required this.address,
    required this.password,
    this.ovpnConfiguration,
    this.vpnPassword,
    this.vpnUserName,
  });

  factory ServerServer.fromRawJson(String str) =>
      ServerServer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ServerServer.fromJson(Map<String, dynamic> json) => ServerServer(
        serverName: json["serverName"],
        stateName: json["stateName"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        ovpnConfiguration: json['ovpnConfiguration'],
        vpnUserName: json['vpnUserName'],
        vpnPassword: json['vpnPassword'],
        country: json["country"],
        flagUrl: json["flag_url"],
        address: json["panel_address"],
        password: json["wgpassword"],
      );

  Map<String, dynamic> toJson() => {
        "serverName": serverName,
        "stateName": stateName,
        "country": country,
        "latitude": latitude,
        "longitude": longitude,
        "ovpnConfiguration": ovpnConfiguration,
        "vpnUserName": vpnUserName,
        "vpnPassword": vpnPassword,
        "flag_url": flagUrl,
        "address": address,
        "password": password,
      };
}

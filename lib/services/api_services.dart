import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:everestvpn/utils/constants.dart';

class ApiServices {
  getAllServers() async {
    try {
      final response = await get(Uri.parse(AppUrls.get_free_wireguard));
      var wireFree = jsonDecode(response.body);
      final response2 = await get(Uri.parse(AppUrls.get_pro_wireguard));
      var wirePro = jsonDecode(response2.body);
      final response3 = await get(Uri.parse(AppUrls.get_free_ovpn));
      var ovpnFree = jsonDecode(response3.body);
      final response4 = await get(Uri.parse(AppUrls.get_pro_ovpn));
      var ovpnPro = jsonDecode(response4.body);

      var allServers = {
        "status": true,
        "freeWire": wireFree,
        "proWire": wirePro,
        "ovpnFree": ovpnFree,
        "ovpnPro": ovpnPro,
      };
      // log(allServers.toString());
      // Parse the JSON data
      Map<String, dynamic> data = json.decode(jsonEncode(allServers));
      log(data.toString());

      // Combine the servers into one list
      List<Map<String, dynamic>> servers = [];

      // Add WireGuard servers (freeWire and proWire)
      servers.addAll(data['freeWire'].map<Map<String, dynamic>>((server) {
        return {
          "type": "wireguard",
          "isFree": true,
          "serverName": server['serverName'],
          "stateName": server['stateName'],
          "flag_url": server['flag_url'],
          "address": server['panel_address'],
          "password": server['password'],
          "latitude": server['latitude'],
          "longitude": server['longitude'],
          "servers": server['servers'],
        };
      }).toList());

      servers.addAll(data['proWire'].map<Map<String, dynamic>>((server) {
        return {
          "type": "wireguard",
          "isFree": false,
          "serverName": server['serverName'],
          "stateName": server['stateName'],
          "flag_url": server['flag_url'],
          "address": server['panel_address'],
          "password": server['password'],
          "latitude": server['latitude'],
          "longitude": server['longitude'],
          "serverCount": server['serverCount'],
          "servers": server['servers'],
        };
      }).toList());

      // Add OpenVPN servers (ovpnFree and ovpnPro)
      servers.addAll(data['ovpnFree'].map<Map<String, dynamic>>((server) {
        return {
          "type": "ovpn",
          "isFree": true,
          "serverName": server['serverName'],
          "stateName": server['stateName'],
          "flag_url": server['flag_url'],
          "ovpnConfiguration": server['ovpnConfiguration'],
          "vpnUserName": server['vpnUserName'],
          "vpnPassword": server['vpnPassword'],
          "latitude": server['latitude'],
          "longitude": server['longitude'],
          "serverCount": server['serverCount'],
          "servers": server['servers'],
        };
      }).toList());

      servers.addAll(data['ovpnPro'].map<Map<String, dynamic>>((server) {
        return {
          "type": "ovpn",
          "isFree": false,
          "serverName": server['serverName'],
          "stateName": server['stateName'],
          "flag_url": server['flag_url'],
          "ovpnConfiguration": server['ovpnConfiguration'],
          "vpnUserName": server['vpnUserName'],
          "vpnPassword": server['vpnPassword'],
          "latitude": server['latitude'],
          "longitude": server['longitude'],
          "serverCount": server['serverCount'],
          "servers": server['servers'],
        };
      }).toList());

      // Print out the unified list
      var finalServers = {"status": true, "servers": servers};
      return finalServers;
    } catch (e) {
      return {"status": false, "servers": []};
    }
  }

  Future<String> userApi({
    String body = '',
    String url = '',
  }) async {
    // Convert the JSON object to a Base64 string
    String encodedData = base64Encode(utf8.encode(body));

    // Prepare the POST request
    var response = await post(
      Uri.parse(url),
      body: {"data": encodedData},
    );

    // Check if the request was successful
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return response.body;
    }
  }
}

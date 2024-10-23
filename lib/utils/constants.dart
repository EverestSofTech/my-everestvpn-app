class AppConstants {
  static const String appName = "Everest VPN";
  static const String pkgName = "com.everestvpn.vpn";
  static const String bundleIdentifierOVPN = "$pkgName.OVPNExtension";
  static const String bundleIdentifierWG = "$pkgName.WGExtension";
}

class AppUrls {
  static const String base_url =
      'https://everestvpn.appapistec.xyz/includes/api.php?';
  static const String base_url2 = 'https://everestvpn.appapistec.xyz/api.php?';
  static const String get_free_wireguard = base_url + 'frWillServerWire';
  static const String get_pro_wireguard = base_url + 'prWillServerWire';
  static const String get_free_ovpn = base_url + 'frWillServer';
  static const String get_pro_ovpn = base_url + 'prWillServer';
  static const String get_notifications = base_url + 'notification';
}

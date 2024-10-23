enum Protocol {
  openVPN('Open VPN'),
  wireguard('Wireguard'),
  automatic('Automatic'),
  ;

  final String code;

  const Protocol(this.code);
}

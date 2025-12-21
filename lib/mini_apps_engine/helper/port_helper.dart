import 'dart:math';

class PortHelper {
  static bool isPortUnsafe(int port) => unsafePorts.contains(port);

  static int generateRandomPort(int oldPort, String serviceName, String serviceKey) {
    if (serviceKey == "islamicservice") return 1245;

    int newPort = 10000 + Random().nextInt(55536);

    return newPort != oldPort && !PortHelper.isPortUnsafe(newPort)
        ? newPort
        : generateRandomPort(newPort, serviceName, serviceKey);
  }
}

// Add this at the top of your file or in a constants file
const List<int> unsafePorts = [
  1, // tcpmux
  7, // echo
  9, // discard
  11, // systat
  13, // daytime
  15, // netstat
  17, // qotd
  19, // chargen
  20, // ftp data
  21, // ftp control
  22, // ssh
  23, // telnet
  25, // smtp
  37, // time
  42, // name
  43, // nicname
  53, // domain
  77, // priv-rjs
  79, // finger
  87, // ttylink
  95, // supdup
  101, // hostriame
  102, // iso-tsap
  103, // gppitnp
  104, // acr-nema
  109, // pop2
  110, // pop3
  111, // sunrpc
  113, // auth
  115, // sftp
  117, // uucp-path
  119, // nntp
  123, // ntp
  135, // loc-srv /epmap
  139, // netbios
  143, // imap2
  179, // bgp
  389, // ldap
  465, // smtp+ssl
  512, // print / exec
  513, // login
  514, // shell
  515, // printer
  526, // tempo
  530, // courier
  531, // chat
  532, // netnews
  540, // uucp
  556, // remotefs
  563, // nntp+ssl
  587, // smtp (rfc6409)
  601, // syslog-conn
  636, // ldap+ssl
  993, // ldap+ssl
  995, // pop3+ssl
  2049, // nfs
  3659, // apple-sasl
  4045, // lockd
  5060, // sip
  5061, // sips
  6000, // x11
  6665, // irc (alternate)
  6666, // irc (alternate)
  6667, // irc (default)
  6668, // irc (alternate)
  6669, // irc (alternate)
  6697, // irc+tls
];

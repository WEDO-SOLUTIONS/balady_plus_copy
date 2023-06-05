import '../../../dependency_injection/dependency_injection_exports.dart'
    show sl;
import '../../utils_exports.dart' show EnvType;

enum ApiGET {
  services,
  requests,
  bills(prefix: "newBill/"),
  profile(suffix: "/addProfile"),
  lookups,
  ;

  const ApiGET({this.prefix, this.suffix});
  final String? prefix;
  final String? suffix;

  String get url => _domain + (prefix ?? '') + name + (suffix ?? '');
  String get _domain => sl<EnvType>().domain;
}

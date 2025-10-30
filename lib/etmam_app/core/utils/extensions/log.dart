import 'dart:developer' as devtools show log;

/// use it insead of print() or debugPrint()
extension Log<T> on T {
  void log() => devtools.log(toString());

  void successLog() => devtools.log("✅: ${toString()}");
  void warningLog() => devtools.log("🟡: ${toString()}");
  void errorLog() => devtools.log("🛑: ${toString()}");
  void actionLog() => devtools.log("🔵: ${toString()}");
}

import '../../dependency_injection/dependency_injection_exports.dart' show sl;
import '../utils_exports.dart' show EnvType;

class RemoteConfig {
  //! First
  String get gis => _RemoteConfig.gis[env]!;
  List<String> get munciplities => _RemoteConfig.munciplities[env]!;

  //! Second  I
  String get gis2 {
    switch (env) {
      case EnvType.dev:
        return _RCDev.gis;
      case EnvType.stg:
        return _RCStg.gis;
      case EnvType.prod:
        return _RCProd.gis;
    }
  }

  //! Second  II
  String get gis3 => {
        EnvType.dev: _RCDev.gis,
        EnvType.stg: _RCStg.gis,
        EnvType.prod: _RCProd.gis,
      }[env]!;
  List<String> get munciplities2 => {
        EnvType.dev: _RCDev.munciplities,
        EnvType.stg: _RCStg.munciplities,
        EnvType.prod: _RCProd.munciplities,
      }[env]!;

  EnvType get env => sl<EnvType>();
}

//! First solution
class _RemoteConfig {
  static final gis = _initValues<String>(
    devVal: "htttps:klfdflkd",
    stgVal: "htttps:klfdflkd",
    prodVal: "htttps:klfdflkd",
  );
  static final munciplities = {
    EnvType.dev: [""],
    EnvType.stg: [""],
    EnvType.prod: [""]
  };

  static Map<EnvType, T> _initValues<T>({
    dynamic devVal,
    dynamic stgVal,
    dynamic prodVal,
  }) =>
      {
        EnvType.dev: devVal,
        EnvType.stg: stgVal,
        EnvType.prod: prodVal,
      };
}

//! Second solution
class _RCDev {
  static const String gis = "";
  static const List<String> munciplities = [];
}

class _RCStg {
  static const String gis = "";
  static const List<String> munciplities = [];
}

class _RCProd {
  static const String gis = "";
  static const List<String> munciplities = [];
}

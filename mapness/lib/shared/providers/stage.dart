import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stage.g.dart';

enum Stage {
  urbiDev,
  urbiPreProd,
  momrahStaging,
  momrahProd,
}

extension StageConfig on Stage {
  String get publicApi => switch (this) {
        Stage.urbiDev =>
          "https://momrah-balady-dev.public-poc.urbi.ae/api/1.0/",
        Stage.urbiPreProd =>
          "https://momrah-balady.public-poc.urbi.ae/api/1.0/",
        Stage.momrahStaging =>
          "https://apiservicesstg.balady.gov.sa/v1/urbi-services/",
        Stage.momrahProd =>
          "https://apiservices.balady.gov.sa/v1/urbi-services/"
      };
}

@riverpod
class _Stage extends _$Stage {
  void update(Stage stage) {
    state = stage;
  }

  @override
  Stage build() {
    return Stage.urbiPreProd;
  }
}

final stageProvider = _stageProvider;

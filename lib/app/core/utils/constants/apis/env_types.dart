import 'package:dgis_map/library.dart';
import 'package:mapness/shared/config/environment_config.dart';

enum EnvType {
  dev(domain: "https://apiservicesstg.balady.gov.sa/"),
  stg(domain: "https://apiservicesstg.balady.gov.sa/"),
  pre(domain: "https://apiservicespp.balady.gov.sa/"),
  prod(domain: "https://apiservices.balady.gov.sa/"),
  urbiPre(domain: "https://sa1.ops.2gis.dev/"),
  ;

  const EnvType({required this.domain});

  final String domain;

  bool get isDev => this == EnvType.dev;

  bool get isStg => this == EnvType.stg;

  bool get isPre => this == EnvType.pre;

  bool get isProd => this == EnvType.prod;

  bool get isUrbiPre => this == EnvType.urbiPre;
}

extension EnvTypeExt on EnvType {
  String vendorConfigKey() => switch (this) {
        EnvType.stg => 'stage_vendor_config',
        EnvType.pre || EnvType.prod => 'prod_vendor_config',
        EnvType.urbiPre || EnvType.dev => 'pre_vendor_config',
      };

  VendorConfigMessage toVendorConfigMessage() => switch (this) {
        EnvType.stg => VendorConfigMessage.momrahStg,
        EnvType.pre || EnvType.prod => VendorConfigMessage.momrahProd,
        EnvType.urbiPre || EnvType.dev => VendorConfigMessage.urbiPreProd,
      };

  String vendorConfigPath() => switch (this) {
        EnvType.stg => 'momrah-staging-vendor-config.jsonx',
        EnvType.pre || EnvType.prod => 'momrah-prod-vendor-config.jsonx',
        EnvType.urbiPre || EnvType.dev => 'urbi-pre-prod-vendor-config.jsonx',
      };

  String appConfigKey() => switch (this) {
        EnvType.dev => 'urbiDev',
        EnvType.stg => 'momrahStaging',
        EnvType.pre => 'urbiPreprod',
        EnvType.prod => 'momrahProd',
        EnvType.urbiPre => 'urbiPreprod',
      };

  EnvironmentConfig getLocalEnvConfig() => switch (this) {
        EnvType.dev => EnvironmentConfig.urbiDev(),
        EnvType.prod => EnvironmentConfig.momrahProd(),
        EnvType.stg => EnvironmentConfig.momrahStaging(),
        EnvType.pre || EnvType.urbiPre => EnvironmentConfig.urbiPreProd(),
      };
}

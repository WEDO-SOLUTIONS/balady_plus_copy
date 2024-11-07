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

  String appConfigKey() => switch (this) {
        EnvType.dev => 'urbiDev',
        EnvType.stg => 'momrahStaging',
        EnvType.pre => 'urbiPreprod',
        EnvType.prod => 'momrahProd',
        EnvType.urbiPre => 'urbiPreprod',
      };
}

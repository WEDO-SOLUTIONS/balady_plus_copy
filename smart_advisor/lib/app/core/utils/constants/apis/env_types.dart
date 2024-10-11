enum EnvType {
  dev(domain: "https://apiservicesstg.balady.gov.sa/"),
  stg(domain: "http://test.test/api/"),
  prod(domain: "http://test.test/api/"),
  ;

  const EnvType({required this.domain});

  final String domain;

  bool get isDev => this == EnvType.dev;

  bool get isStg => this == EnvType.stg;

  bool get isProd => this == EnvType.prod;
}

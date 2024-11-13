enum EnvType {
  dev(domain: "https://apiservicesstg.balady.gov.sa/"),
  stg(domain: "https://apiservicesstg.balady.gov.sa/"),
  prod(domain: "https://apiservices.balady.gov.sa/"),
  ;

  const EnvType({required this.domain});

  final String domain;

  bool get isDev => this == EnvType.dev;

  bool get isStg => this == EnvType.stg;

  bool get isProd => this == EnvType.prod;
}

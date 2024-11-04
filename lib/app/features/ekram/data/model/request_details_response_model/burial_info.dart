class BurialInfo {
  String? permitNumber;
  String? burialDate;
  String? gregorianBurialDate;
  int? prayId;
  String? prayName;
  String? ghuslMethod;
  int? cityId;
  String? cityName;
  String? burialDestination;
  String? burialDestinationName;

  BurialInfo({
    this.permitNumber,
    this.burialDate,
    this.gregorianBurialDate,
    this.prayId,
    this.prayName,
    this.ghuslMethod,
    this.cityId,
    this.cityName,
    this.burialDestination,
    this.burialDestinationName,
  });

  factory BurialInfo.fromJson(Map<String, dynamic> json) => BurialInfo(
        permitNumber: json['permitNumber'] as String?,
        burialDate: json['burialDate'] as String?,
        gregorianBurialDate: json['gregorianBurialDate'] as String?,
        prayId: json['prayId'] as int?,
        prayName: json['prayName'] as String?,
        ghuslMethod: json['ghuslMethod'] as String?,
        cityId: json['cityId'] as int?,
        cityName: json['cityName'] as String?,
        burialDestination: json['burialDestination'] as String?,
        burialDestinationName: json['burialDestinationName'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'permitNumber': permitNumber,
        'burialDate': burialDate,
        'gregorianBurialDate': gregorianBurialDate,
        'prayId': prayId,
        'prayName': prayName,
        'ghuslMethod': ghuslMethod,
        'cityId': cityId,
        'cityName': cityName,
        'burialDestination': burialDestination,
        'burialDestinationName': burialDestinationName,
      };
}

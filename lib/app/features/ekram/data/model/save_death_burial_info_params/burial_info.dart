class BurialInfo {
  String? permitNumber;
  String? burialDate;
  String? gregorianBurialDate;
  int? prayId;
  String? ghuslMethod;
  String? burialDestination;

  BurialInfo({
    this.permitNumber,
    this.burialDate,
    this.gregorianBurialDate,
    this.prayId,
    this.ghuslMethod,
    this.burialDestination,
  });

  Map<String, dynamic> toJson() => {
        'permitNumber': permitNumber,
        'burialDate': burialDate,
        'gregorianBurialDate': gregorianBurialDate,
        'prayId': prayId,
        'ghuslMethod': ghuslMethod,
        'burialDestination': burialDestination,
      };
}

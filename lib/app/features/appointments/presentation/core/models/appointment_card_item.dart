class AppointmentCardItem {
  int? id;
  String? municipalityName;
  String? subMunicipalityName;
  String? visitDate;
  String? visitTime;
  int? statusId;
  String? statusName;
  String? mainClassName;

  AppointmentCardItem(
      {this.id,
      this.mainClassName,
      this.municipalityName,
      this.statusId,
      this.statusName,
      this.subMunicipalityName,
      this.visitDate,
      this.visitTime});
}

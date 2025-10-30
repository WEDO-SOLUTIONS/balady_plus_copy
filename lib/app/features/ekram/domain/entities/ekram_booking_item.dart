class EkramBookingItem {
  String? orderNo;
  String? status;
  String? deceasedName;
  String? cemeteryName;
  String? burialDate;
  String? burialTime;

  EkramBookingItem({
    this.orderNo,
    this.status,
    this.deceasedName,
    this.cemeteryName,
    this.burialDate,
    this.burialTime,
  });
}

List<EkramBookingItem> getDummyEkramBookingList = [
  EkramBookingItem(
      orderNo: "12932432",
      status: "قيد التنفيذ",
      deceasedName: "محمد الفيصل",
      cemeteryName: "مقبرة الدمام",
      burialDate: "2021 / 1 / 5",
      burialTime: "صلاة المغرب"),
  EkramBookingItem(
      orderNo: "12932432",
      status: "قيد التنفيذ",
      deceasedName: "محمد الفيصل",
      cemeteryName: "مقبرة الدمام",
      burialDate: "2021 / 1 / 5",
      burialTime: "صلاة المغرب"),
  EkramBookingItem(
      orderNo: "12932432",
      status: "قيد التنفيذ",
      deceasedName: "محمد الفيصل",
      cemeteryName: "مقبرة الدمام",
      burialDate: "2021 / 1 / 5",
      burialTime: "صلاة المغرب")
];

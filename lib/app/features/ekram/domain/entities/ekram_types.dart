class EkramTypes {
  String? icon;
  String? title;
  String? desc;
  String? type;
  //Function? onClick;

  EkramTypes({this.icon, this.title, this.type, this.desc});

  static List<EkramTypes> getEkramTypes = [
    /*  EkramTypes(
      icon: "assets/icons/ekram_booking.svg",
      title: "cemetery_booking_request",
      desc: "cemetery_booking_request_desc",
      type: "cemetery",
      /* onClick: () {
         print("soon");
        }*/
    ),*/
    EkramTypes(
      icon: "assets/icons/ekram_transportation.svg",
      title: "request_transporting_deceased",
      desc: "",
      type: "transport",
      /* onClick: () {

        }*/
    )
  ];
}

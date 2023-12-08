class DCTypes {
  String? icon;
  String? title;
  String? desc;
  String? type;
  //Function? onClick;

  DCTypes({this.icon, this.title, this.type, this.desc});

  static List<DCTypes> getRetriveTypes = [
    DCTypes(
      icon: "assets/icons/svg/dc/dcSelf.svg",
      title: "dc_type_self",
      desc: "",
      type: "OnBehalfOfMyself",
      /* onClick: () {
        }*/
    ),
    DCTypes(
      icon: "assets/icons/svg/dc/dcAgent.svg",
      title: "dc_type_agent",
      desc: "",
      type: "Agent",
    ),
    DCTypes(
      icon: "assets/icons/svg/dc/dcDead.svg",
      title: "dc_type_owner",
      desc: "",
      type: "Owner/ManagerOfTheFacility",
    ),
    DCTypes(
      icon: "assets/icons/svg/dc/menu-board.svg",
      title: "dc_type_dead",
      desc: "",
      type: "OnBehalfOfDeadPerson",
    )
  ];
}

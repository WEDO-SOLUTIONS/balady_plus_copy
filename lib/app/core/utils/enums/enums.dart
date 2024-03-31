// button icon position
enum BUTTON_ICON_POSITION { left, right }

enum APP_SUPPORTED_LANGUAGES { ar, en }

// font-weight
enum FONT_WEIGHT { regular, medium, bold, black }

// pop-up message type
enum POP_UP_MESSAGE_TYPE { success, error, warning, confirm, none }

// material icon direction
enum MATERIAL_ICON_DIRECTION { up, down, left, right }

// appointment types
enum APPOINTMENT_TYPE { newAppointment, reviewAppointment }

// button icon position

// facility status
enum FACILITY_STATUS { open, close, cancel }

// text field border
enum BORDER_TYPE { none, outline, underline }

// page type for success screen
enum PAGE_TYPE {
  ratingScreen,
  facilityIncidentScreen,
  incidentsScreen,
  licenseScreen,
  inquiry,
  msr,
  contactUs,
  deleteRequestScreen,
  appointmentScreen,
  updateAppointment,

  coObserver,
  qrDialog,
  qrDetailsScreen,
  cancelAppointment,
  confirmAppointment,
  visitScreen,
  daem,
  newVD,
  objction,
  dc,
  vhr,
  emtethal,
  deleteEmtethal,
  renewCommercial,
  other,
  ekramCemetry
}

enum RequestsType {
  INC(title: "inc_title", type: "inc"),
  VHR(title: "vhr_title", type: "vhr"),
  REQ(title: "req_title", type: "req"),
  INQ(title: "inq_title", type: "inq"),
  DC(title: "dc_title", type: "dc"),
  TSR(title: "tsr_title", type: "tsr"),
  MUN(title: "mun_title", type: "mun"),
  ;

  const RequestsType({
    required this.type,
    required this.title,
  });

  final String type;
  final String title;
}

enum ATHKAR_CATAGORIES { morning, sleep, evening }

enum CRSubmitterType { owner, rental }

enum CRContractType {
  deed(name: "DEED"),
  invest(name: "INVEST"),
  ejar(name: "EJAR");

  final String name;

  const CRContractType({required this.name});
}

enum CRContractOption {
  attach(name: "ATTACH"),
  service(name: "SERVICE");

  final String name;

  const CRContractOption({required this.name});
}

enum CRRenewCleanOption {
  optional(name: "OPTIONAL"),
  cleanContract(name: "CLEAN_CONTRACT"),
  baladiaSadad(name: "BALADIA_SADAD");

  final String name;

  const CRRenewCleanOption({required this.name});
}

enum CRRenewCleanContract {
  attach(name: "ATTACH"),
  service(name: "SERVICE"),
  attachService(name: "ATTACH,SERVICE");

  final String name;

  const CRRenewCleanContract({required this.name});
}

enum CRContractCleanRenewOptions {
  service(name: "SERVICE"),
  attach(name: "ATTACH"),
  payAll(name: "payAll");

  final String name;

  const CRContractCleanRenewOptions({required this.name});
}

enum UserProfileType { Delegator, Agent }

enum ServiceCardsTypes { desc, req, flow, authorInfo, others, conditions }

enum QRSiteLocationType {
  INSIDE_BUILDING(name: "INSIDE_BUILDING"),
  ON_STREET(name: "ON_STREET");

  final String name;
  const QRSiteLocationType({required this.name});
}

enum QRWorkTimes { SHIFTED, OPEN_24HOUR, CLOSED }

enum EkramType { transport, cemetry }

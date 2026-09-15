// button icon position
enum ButtonIconPosition { left, right }

enum AppSupportedLanguages { ar, en }

// pop-up message type
enum PopUpMessageType { success, error, warning, confirm, none }

// material icon direction
enum MaterialIconDirection { up, down, left, right }

// appointment types
enum AppointmentType { newAppointment, reviewAppointment }

// button icon position

// facility status
enum FacilityStatus { open, close, cancel }

// text field border

// page type for success screen
enum PageType {
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
  ekramCemetry,
}

enum RequestsType {
  inc(title: "inc_title", type: "inc"),
  vhr(title: "vhr_title", type: "vhr"),
  req(title: "req_title", type: "req"),
  inq(title: "inq_title", type: "inq"),
  dc(title: "dc_title", type: "dc"),
  tsr(title: "tsr_title", type: "tsr"),
  mun(title: "mun_title", type: "mun");

  const RequestsType({required this.type, required this.title});

  final String type;
  final String title;
}

enum AthkarCatagories { morning, sleep, evening }

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

enum UserProfileType { delegator, agent }

enum ServiceCardsTypes { desc, req, flow, authorInfo, others, conditions }

enum QRSiteLocationType {
  insIdEBuilding(name: "INSIDE_BUILDING"),
  onStreet(name: "ON_STREET");

  final String name;
  const QRSiteLocationType({required this.name});
}

enum QRWorkTimes { shifted, open24hour, closed }

enum EkramType { transport, cemetry }

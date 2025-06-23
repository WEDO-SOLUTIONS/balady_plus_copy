// This File To Map Screen by (requestTypeId, requestMainTypeId)
// ____________________________
// Request  الطلبات:
//  if requestMainTypeId      == 1300 -> My_Requests_HealthCertificate_Details_Page
//  if mainTypeId             == 1130 -> 				    My_Requests_Compliance_Details_Page
//  if requestTypeId          == 1008 || 1005 || 1004  -> My_Requests_Commercial_Details_Page
// ____________________________
// license  الرخص:
//  if requestMainTypeId == 1300 -> My_Licenses_HealthCertificate_Details_Page
//  if requestMainTypeId == 1003 -> My_Licenses_Commercial_Details_Page
// ____________________________
// invoice  الفواتير:
// screenName: “My_Invoices_Details_Page”
// ____________________________
// Appointment   الموعيد : Naver Open WebView
// screenName: “Appointment_Booking_Details_Page”
// ____________________________
// objection   اعتراضات :   Naver Open WebView
// screenName: “/ObjectionsDetailsPage”
// ____________________________
// Violations المخالفات : Naver Open WebView
// screenName: “My_Violations_View_Details_Page”
// ____________________________

//(invoice,appointment,objection,Violations) depaneds on type name,
// although license depends on maintype.id service,
// and for requests it depends on
// string -> tag and return screen name  and some time send intgear -> id

import 'constants/route_names.dart';

//
String getScreenName(String tag, {int? typeId}) {
  switch (tag) {
    ////// This depand on mainTypeId or requestMainTypeId
    case 'request':
      switch (typeId) {
        case 1301 || 1302 || 1303 || 1308 || 1300:
          return RouteName.healthRequestDetailsScreen;
        case 1130:
          return RouteName.complianceDetailsPage;
        case 1008 || 1005 || 1004:
          return RouteName.requestCommercialLicenseDetails;
        case 1006:
          return RouteName.requestOwnershipTransferDetailsPage;
        case 1042 || 1043:
          return RouteName.posterReqeuestDetailsPage;
        case 1028:
          return RouteName.permitsRequestDetailsPage;
        case 1026:
          return RouteName.permitsTobaccoRequestDetailsPage;

        case 50001:
          return RouteName.objectionsDetailsPage;

        case 1801:
            return RouteName.IntialApprovalRequestDetailsPage;

      }
    case 'license':
      switch (typeId) {
        case 1300:
          return RouteName.healthLicenseDetailsScreen;
        case 1003:
          return RouteName.commercialLicenseDetails;
      }
    //////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////
    case 'invoice':
      return RouteName.invoiceDetails;
    case 'appmt':
      return RouteName.appointmentDetailsRoute;
    case 'objection':
      return RouteName.objectionsDetailsPage;
    case 'violation':
      return RouteName.violationDetailsPage;
    //////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////
  }
  // need Add Screen To When not find screen
  return RouteName.inappWebview;
}

// Screen Tage
enum ScreenTage {
  request,
  license,
  invoice,
  appmt,
  objection,
  violation,
}

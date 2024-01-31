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

// depaned on This get Screen by type (invoice,Appointment,objection,Violations)
// and some time dpaind on mainTypeId or requestMainTypeId to selotion
// string -> tag and return screen name  and some time send intgear -> id

import 'constants/route_names.dart';

//
String getScreenName(String tag, {int? typeId}) {
  switch (tag) {
    ////// This depand on mainTypeId or requestMainTypeId
    case 'Request':
      switch (typeId) {
        case 1300:
          return RouteName.healthRequestDetailsScreen;
        case 1130:
          return RouteName.complianceDetailsPage;
        case 1008 || 1005 || 1004:
          return RouteName.requestCommercialLicenseDetails;
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
    case 'appointment':
      return RouteName.appointmentDetailsRoute;
    case 'objection':
      return RouteName.objectionsDetailsPage;
    case 'violations':
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
  appointment,
  objection,
  violations,
}

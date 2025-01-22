// import 'package:balady_plus/app/core/utils/constants/route_names.dart';
// import 'package:balady_plus/app/features/classification_certificate/core/classification_certificate_routes/classification_certificate_route_names.dart';

// Map<String, dynamic> servicesConfig = {
//   "islamic_services": [
//     {
//       "id": 101,
//       "icon": "holy_quran",
//       "3d_icon": null,
//       "order": 1,
//       "isNew": false,
//       "requireLogin": false,
//       "isImportant": false,
//       "action": {"type": "page", "value": RouteName.menuQuranPage},
//       "ar": {"title": "holy_quran", "description": null, "tag": null},
//       "en": {"title": "holy_quran", "description": null, "tag": null}
//     },
//     {
//       "id": 102,
//       "icon": "prayer_times",
//       "3d_icon": null,
//       "order": 2,
//       "isNew": false,
//       "requireLogin": false,
//       "isImportant": false,
//       "action": {"type": "page", "value": RouteName.prayerTimes},
//       "ar": {"title": "prayerTimes", "description": null},
//       "en": {"title": "prayerTimes", "description": null}
//     },
//     {
//       "id": 103,
//       "icon": "Jood",
//       "3d_icon": null,
//       "order": 0,
//       "isNew": false,
//       "isImportant": false,
//       "requireLogin": false,
//       "action": {
//         "type": "page",
//         "value": RouteName.jodDonationPage,
//       },
//       "ar": {"title": "jod", "description": null, "tag": null},
//       "en": {"title": "jod", "description": null, "tag": null}
//     },
//     {
//       "id": 104,
//       "icon": "calendar-2",
//       "3d_icon": null,
//       "order": 5,
//       "requireLogin": false,
//       "isNew": false,
//       "isImportant": false,
//       "action": {"type": "page", "value": RouteName.calendarMainPage},
//       "ar": {"title": "saudi_calendar", "description": null, "tag": null},
//       "en": {"title": "saudi_calendar", "description": null, "tag": null}
//     },
//     {
//       "id": 105,
//       "icon": "azkar",
//       "3d_icon": null,
//       "order": 3,
//       "requireLogin": false,
//       "isNew": false,
//       "isImportant": false,
//       "action": {"type": "page", "value": RouteName.mainAthkarPage},
//       "ar": {"title": "azkar", "description": null, "tag": null},
//       "en": {"title": "azkar", "description": null, "tag": null}
//     },
//     {
//       "id": 106,
//       "icon": "ticket-2",
//       "3d_icon": null,
//       "order": 4,
//       "requireLogin": false,
//       "isNew": false,
//       "isImportant": false,
//       "action": {"type": "page", "value": RouteName.eventsMainPage},
//       "ar": {"title": "events", "description": null, "tag": null},
//       "en": {"title": "events", "description": null, "tag": null}
//     },
//     {
//       "id": 107,
//       "icon": "zamzam_points",
//       "3d_icon": null,
//       "order": 4,
//       "requireLogin": false,
//       "isNew": false,
//       "isImportant": false,
//       "action": {"type": "page", "value": RouteName.ZmZmPointsPage},
//       "ar": {"title": "zamzam_points", "description": null, "tag": null},
//       "en": {"title": "zamzam_points", "description": null, "tag": null}
//     },
//
//     /*  {
//       "id": 5,
//       "icon": "bousalah",
//       "3d_icon": null,
//       "order": 4,
//       "isNew": false,
//       "isImportant": false,
//       "action": {"type": "page", "value": RouteName.qiblahCompass},
//       "ar": {"title": "qiblahCompass", "description": null, "tag": null},
//       "en": {"title": "qiblahCompass", "description": null, "tag": null}
//     },
//
//
//     {
//       "id": 5,
//       "icon": "weather",
//       "3d_icon": null,
//       "order": 4,
//       "isNew": false,
//       "isImportant": false,
//       "action": {"type": "page", "value": RouteName.weatherMainPage},
//       "ar": {"title": "weather", "description": null, "tag": null},
//       "en": {"title": "weather", "description": null, "tag": null}
//     },*/
//   ],
//   "municipal_services": [
//     {
//       "id": 206,
//       "icon": "submit_compliance",
//       "3d_icon": null,
//       "order": 4,
//       "isNew": false,
//       "isImportant": false,
//       "requireLogin": true,
//       "action": {"type": "page", "value": RouteName.createCompliancePage},
//       "ar": {
//         "title": "compliance_certificate",
//         "description": null,
//         "tag": null
//       },
//       "en": {
//         "title": "compliance_certificate",
//         "description": null,
//         "tag": null
//       }
//     },
//     {
//       "id": 201,
//       "icon": "send_image",
//       "3d_icon": null,
//       "order": 1,
//       "isNew": false,
//       "isImportant": false,
//       "requireLogin": false,
//       "action": {"type": "dialog", "value": ""},
//       "ar": {
//         "title": "sendImage",
//         "description":
//             "حسّن المشهد الحضري في مدينتك، وبلّغ عن مظاهر التشوه البصري",
//         "tag": null,
//         "warning": ""
//       },
//       "en": {
//         "title": "sendImage",
//         "description":
//             "Improve the civil scene of your city and report visual pollution",
//         "tag": null,
//         "warning": ""
//       },
//     },
//     {
//       "id": 202,
//       "icon": "objections",
//       "3d_icon": null,
//       "order": 6,
//       "isNew": false,
//       "requireLogin": true,
//       "isImportant": false,
//       "action": {"type": "page", "value": RouteName.objectableTransactions},
//       "ar": {"title": "submit_objections", "description": null, "tag": null},
//       "en": {"title": "submit_objections", "description": null, "tag": null}
//     },
//     {
//       "id": 203,
//       "icon": "request_service",
//       "3d_icon": null,
//       "order": 5,
//       "isNew": false,
//       "requireLogin": true,
//       "isImportant": false,
//       "action": {"type": "dialog", "value": RouteName.newMSRMapPage},
//       "ar": {"title": "request_service", "description": null, "tag": null},
//       "en": {"title": "request_service", "description": null, "tag": null}
//     },
//     {
//       "id": 204,
//       "icon": "schedule_date",
//       "3d_icon": null,
//       "order": 4,
//       "isNew": false,
//       "isImportant": false,
//       "requireLogin": true,
//       "action": {"type": "dialog", "value": ""},
//       "ar": {"title": "schedule_date", "description": null, "tag": null},
//       "en": {"title": "schedule_date", "description": null, "tag": null}
//     },
//     {
//       "id": 211,
//       "icon": "balady_business",
//       "3d_icon": null,
//       "order": 1,
//       "isNew": false,
//       "isImportant": false,
//       "requireLogin": true,
//       "action": {"type": "page", "value": RouteName.etmamMainPage},
//       "ar": {"title": "balady_works", "description": null, "tag": null},
//       "en": {"title": "balady_works", "description": null, "tag": null}
//     },
//     {
//       "id": 205,
//       "icon": "cities_services",
//       "3d_icon": null,
//       "order": 4,
//       "isNew": false,
//       "isImportant": false,
//       "requireLogin": true,
//       "action": {"type": "page", "value": ""},
//       "ar": {
//         "title": "service_provide_services",
//         "description": null,
//         "tag": null
//       },
//       "en": {
//         "title": "service_provide_services",
//         "description": null,
//         "tag": null
//       }
//     },
//     {
//       "id": 208,
//       "icon": "damaged_cars",
//       "3d_icon": null,
//       "order": 9,
//       "isNew": false,
//       "isImportant": false,
//       "requireLogin": true,
//       "action": {"type": "dialog", "value": RouteName.DCCameraPage},
//       "ar": {"title": "ruined_car_request", "description": null, "tag": null},
//       "en": {"title": "ruined_car_request", "description": null, "tag": null}
//     },
//     {
//       "id": 209,
//       "icon": "retrieve_car",
//       "3d_icon": null,
//       "order": 9,
//       "isNew": true,
//       "isImportant": false,
//       "requireLogin": true,
//       "action": {"type": "page", "value": RouteName.DCVeichlePage},
//       "ar": {"title": "dc_retreive_car", "description": "", "tag": ""},
//       "en": {"title": "dc_retreive_car", "description": null, "tag": null}
//     },
//     {
//       "id": 212,
//       "icon": "municipal_health",
//       "3d_icon": null,
//       "order": 3,
//       "isNew": false,
//       "isImportant": false,
//       "requireLogin": true,
//       "action": {"type": "page", "value": RouteName.newHealthCertificatePage},
//       "ar": {"title": "municipal_health", "description": null, "tag": null},
//       "en": {"title": "municipal_health", "description": null, "tag": null}
//     },
//     {
//       "id": 221,
//       "icon": "ekram_inq_grave_dead",
//       "3d_icon": null,
//       "order": 4,
//       "isNew": false,
//       "isImportant": false,
//       "requireLogin": true,
//       "action": {"type": "dialog", "value": ""},
//       "ar": {"title": "ekram_services", "description": null, "tag": null},
//       "en": {"title": "ekram_services", "description": null, "tag": null}
//     },
//
//     {
//       "id": 207,
//       "icon": "self_rating",
//       "3d_icon": null,
//       "order": 4,
//       "isNew": false,
//       "isImportant": false,
//       "requireLogin": false,
//       "action": {"type": "page", "value": RouteName.selfRatingMainPage},
//       "ar": {"title": "review-building", "description": null, "tag": null},
//       "en": {"title": "review-building", "description": null, "tag": null}
//     },
//     {
//       "id": 219,
//       "icon": "municpal_construction",
//       "3d_icon": null,
//       "order": 2,
//       "isNew": false,
//       "isImportant": false,
//       "requireLogin": true,
//       "action": {
//         "type": "dialog",
//         "value": "${RemoteConfig.webSiteUrl}/ar/products/10470"
//       },
//       "ar": {
//         "title": "municpal_construction",
//         "description": null,
//         "tag": null
//       },
//       "en": {"title": "municpal_construction", "description": null, "tag": null}
//     },
//     {
//       "id": 220,
//       "icon": "municipal_shop",
//       "3d_icon": null,
//       "order": 4,
//       "isNew": false,
//       "isImportant": false,
//       "requireLogin": true,
//       "action": {
//         "type": "dialog",
//         "value": "${RemoteConfig.webSiteUrl}/ar/products/10574"
//       },
//       "ar": {"title": "municipal_shop", "description": null, "tag": null},
//       "en": {"title": "municipal_shop", "description": null, "tag": null}
//     },    {
//       "id": 222,
//       "icon": "note",
//       "3d_icon": null,
//       "order": 4,
//       "isNew": true,
//       "isImportant": false,
//       "requireLogin": false,
//       "action": {
//         "type": "page",
//         "value": ClassificationCertificateRouteName
//             .classificationCertificateVerifyOverviewScreen,
//       },
//       "ar": {
//         "title": "classification_certificate_verify",
//         "description": null,
//         "tag": null
//       },
//       "en": {
//         "title": "classification_certificate_verify",
//         "description": null,
//         "tag": null
//       }
//     },
//     {
//       "id": 11124,
//       "icon": "construction_license_query",
//       "3d_icon": null,
//       "order": 6,
//       "isNew": false,
//       "requireLogin": false,
//       "isImportant": false,
//       "action": {
//         "type": "page",
//         "value": RouteName.constructionLicenseOverView
//       },
//       "ar": {
//         "title": "inquiry_construction_license",
//         "description": null,
//         "tag": null
//       },
//       "en": {
//         "title": "inquiry_construction_license",
//         "description": null,
//         "tag": null
//       }
//     },
//     {
//       "id": 11428,
//       "icon": "license_query",
//       "3d_icon": null,
//       "order": 6,
//       "isNew": false,
//       "requireLogin": false,
//       "isImportant": false,
//       "action": {
//         "type": "page",
//         "value": RouteName.surveyReportInqueryOverView
//       },
//       "ar": {
//         "title": "survey_report_inquery",
//         "description": null,
//         "tag": null
//       },
//       "en": {"title": "survey_report_inquery", "description": null, "tag": null}
//     },
//     {
//       "id": 11134,
//       "icon": "commercial_license_query",
//       "3d_icon": null,
//       "order": 6,
//       "isNew": false,
//       "requireLogin": true,
//       "isImportant": false,
//       "action": {"type": "page", "value": RouteName.commercialLicenseOverView},
//       "ar": {
//         "title": "CommerciallicenseQuery",
//         "description": null,
//         "tag": null
//       },
//       "en": {
//         "title": "CommerciallicenseQuery",
//         "description": null,
//         "tag": null
//       }
//     },
//     {
//       "id": 210,
//       "icon": "general_inquiries",
//       "3d_icon": "assets/images/home_icon_1.png",
//       "order": 2,
//       "isNew": false,
//       "isImportant": true,
//       "requireLogin": true,
//       "action": {"type": "dialog", "value": "/general-inquiries"},
//       "ar": {
//         "title": "general_requests",
//         "description": "ارسل استفسارك عن كل خدمه",
//         "tag": "الخدمات"
//       },
//       "en": {
//         "title": "general_requests",
//         "description": "Send your inquiry about any service",
//         "tag": "Services"
//       }
//     },
//   ],
//   "business_license_services": [
//     {
//       "id": 301,
//       "icon": "issue-commercial",
//       "3d_icon": null,
//       "order": 5,
//       "isNew": false,
//       "isImportant": false,
//       "requireLogin": true,
//       "action": {
//         "type": "page",
//         "value": RouteName.commercialLicenseServicePage
//       },
//       "ar": {
//         "title": "issue_commerical_license",
//         "description": null,
//         "tag": null
//       },
//       "en": {
//         "title": "issue_commerical_license",
//         "description": null,
//         "tag": null
//       }
//     },
//     {
//       "id": 302,
//       "icon": "posters_permits",
//       "3d_icon": null,
//       "order": 5,
//       "isNew": false,
//       "requireLogin": true,
//       "isImportant": false,
//       "action": {"type": "page", "value": ""},
//       "ar": {"title": "multiple_permits", "description": null, "tag": null},
//       "en": {"title": "multiple_permits", "description": null, "tag": null}
//     },
//     {
//       "id": 303,
//       "icon": "toppaco_services",
//       "3d_icon": null,
//       "order": 0,
//       "isNew": false,
//       "isImportant": false,
//       "requireLogin": true,
//       "action": {
//         "type": "page",
//         "value": RouteName.tobaccoServicesList,
//       },
//       "ar": {"title": "tobaccoServices", "description": null, "tag": null},
//       "en": {"title": "tobaccoServices", "description": null, "tag": null}
//     },
//     /*  {
//       "id": 304,
//       "icon": "municipal_health",
//       "3d_icon": null,
//       "order": 3,
//       "isNew": false,
//       "isImportant": false,
//       "requireLogin": true,
//       "action": {"type": "page", "value": RouteName.newHealthCertificatePage},
//       "ar": {"title": "municipal_health", "description": null, "tag": null},
//       "en": {"title": "municipal_health", "description": null, "tag": null}
//     },*/
//     /*{
//       "id": 305,
//       "icon": "municpal_housing",
//       "3d_icon": null,
//       "order": 5,
//       "isNew": false,
//       "isImportant": false,
//       "requireLogin": true,
//       "action": {
//         "type": "dialog",
//         "value": "${RemoteConfig.webSiteUrl}/ar/products/10543"
//       },
//       "ar": {"title": "municpal_housing", "description": null, "tag": null},
//       "en": {"title": "municpal_housing", "description": null, "tag": null}
//     },*/
//     {
//       "id": 306,
//       "icon": "municipal_ewaa",
//       "3d_icon": null,
//       "order": 6,
//       "isNew": false,
//       "isImportant": false,
//       "requireLogin": true,
//       "action": {"type": "dialog", "value": RemoteConfig.ewaaUrl},
//       "ar": {"title": "municipal_ewaa", "description": null, "tag": null},
//       "en": {"title": "municipal_ewaa", "description": null, "tag": null}
//     },
//     {
//       "id": 307,
//       "icon": "submit_compliance",
//       "3d_icon": null,
//       "order": 4,
//       "isNew": false,
//       "isImportant": false,
//       "requireLogin": true,
//       "action": {"type": "page", "value": RouteName.createCompliancePage},
//       "ar": {
//         "title": "compliance_certificate",
//         "description": null,
//         "tag": null
//       },
//       "en": {
//         "title": "compliance_certificate",
//         "description": null,
//         "tag": null
//       }
//     },
//     {
//       "id": 308,
//       "icon": "self_rating",
//       "3d_icon": null,
//       "order": 4,
//       "isNew": false,
//       "isImportant": false,
//       "requireLogin": false,
//       "action": {"type": "page", "value": RouteName.selfRatingMainPage},
//       "ar": {"title": "review-building", "description": null, "tag": null},
//       "en": {"title": "review-building", "description": null, "tag": null}
//     },
//     {
//       "id": 309,
//       "icon": "municipal_commercial",
//       "3d_icon": null,
//       "order": 1,
//       "isNew": false,
//       "isImportant": false,
//       "requireLogin": true,
//       "action": {
//         "type": "dialog",
//         "value": "${RemoteConfig.webSiteUrl}/ar/products/10920"
//       },
//       "ar": {"title": "municipal_commercial", "description": null, "tag": null},
//       "en": {"title": "municipal_commercial", "description": null, "tag": null}
//     },
//     {
//       "id": 311,
//       "icon": "objections",
//       "3d_icon": null,
//       "order": 6,
//       "isNew": false,
//       "isImportant": false,
//       "requireLogin": true,
//       "action": {"type": "page", "value": RouteName.objectableTransactions},
//       "ar": {"title": "submit_objections", "description": null, "tag": null},
//       "en": {"title": "submit_objections", "description": null, "tag": null}
//     },
//     /*{
//       "id": 312,
//       "icon": "schedule_date",
//       "3d_icon": null,
//       "order": 4,
//       "isNew": false,
//       "isImportant": false,
//       "requireLogin": true,
//       "action": {"type": "dialog", "value": ""},
//       "ar": {"title": "schedule_date", "description": null, "tag": null},
//       "en": {"title": "schedule_date", "description": null, "tag": null}
//     },*/
//     {
//       "id": 313,
//       "icon": "general_inquiries",
//       "3d_icon": "assets/images/home_icon_1.png",
//       "order": 2,
//       "isNew": false,
//       "isImportant": true,
//       "requireLogin": true,
//       "action": {"type": "dialog", "value": "/general-inquiries"},
//       "ar": {
//         "title": "general_requests",
//         "description": "ارسل استفسارك عن كل خدمه",
//         "tag": "الخدمات"
//       },
//       "en": {
//         "title": "general_requests",
//         "description": "Send your inquiry about any service",
//         "tag": "Services"
//       }
//     },
//     {
//       "id": 314,
//       "icon": "balady_business",
//       "3d_icon": null,
//       "order": 1,
//       "isNew": false,
//       "isImportant": false,
//       "requireLogin": true,
//       "action": {"type": "page", "value": RouteName.etmamMainPage},
//       "ar": {"title": "balady_works", "description": null, "tag": null},
//       "en": {"title": "balady_works", "description": null, "tag": null}
//     },
//     {
//       "id": 315,
//       "icon": "municpal_construction",
//       "3d_icon": null,
//       "order": 2,
//       "isNew": false,
//       "isImportant": false,
//       "requireLogin": true,
//       "action": {
//         "type": "page",
//         "value": "${RemoteConfig.webSiteUrl}/ar/products/10470"
//       },
//       "ar": {
//         "title": "municpal_construction",
//         "description": null,
//         "tag": null
//       },
//       "en": {"title": "municpal_construction", "description": null, "tag": null}
//     },
//     {
//       "id": 222,
//       "icon": "note",
//       "3d_icon": null,
//       "order": 4,
//       "isNew": true,
//       "isImportant": false,
//       "requireLogin": false,
//       "action": {
//         "type": "page",
//         "value": ClassificationCertificateRouteName
//             .classificationCertificateVerifyOverviewScreen,
//       },
//       "ar": {
//         "title": "classification_certificate_verify",
//         "description": null,
//         "tag": null
//       },
//       "en": {
//         "title": "classification_certificate_verify",
//         "description": null,
//         "tag": null
//       }
//     },
//   ],
//   "help_services": [
//     {
//       "id": 408,
//       "icon": "smart_advisor",
//       "3d_icon": null,
//       "order": 13,
//       "isNew": false,
//       "isImportant": false,
//       "requireLogin": false,
//       "action": {"type": "page", "value": ""},
//       "ar": {"title": "smart_advisor", "description": null, "tag": null},
//       "en": {"title": "smart_advisor", "description": null, "tag": null}
//     },
//
//     {
//       "id": 401,
//       "icon": "municipal_advisor",
//       "3d_icon": null,
//       "order": 13,
//       "isNew": false,
//       "isImportant": false,
//       "requireLogin": true,
//       "action": {"type": "page", "value": RouteName.municipalAdvisor},
//       "ar": {"title": "municipal_advisor", "description": null, "tag": null},
//       "en": {"title": "municipal_advisor", "description": null, "tag": null}
//     },
//
//     // fawzi comment to remove gpt icon
//     // {
//     //   "id": 407,
//     //   "icon": "municipal_advisor",
//     //   "3d_icon": null,
//     //   "order": 13,
//     //   "isNew": false,
//     //   "isImportant": false,
//     //   "requireLogin": true,
//     //   "beta": false,
//     //   "action": {"type": "page", "value": RouteName.chatbot},
//     //   "ar": {"title": "municipal_advisor", "description": null, "tag": null},
//     //   "en": {"title": "municipal_advisor", "description": null, "tag": null}
//     // },
//     {
//       "id": 499,
//       "icon": "calender",
//       "3d_icon": null,
//       "order": 13,
//       "isNew": false,
//       "isImportant": false,
//       "requireLogin": true,
//       "action": {"type": "page", "value": RouteName.baladyCalendarPage},
//       "ar": {"title": "balady_calendar", "description": null, "tag": null},
//       "en": {"title": "balady_calendar", "description": null, "tag": null}
//     },
//     {
//       "id": 402,
//       "icon": "violation-guide",
//       "3d_icon": null,
//       "order": 5,
//       "isNew": false,
//       "isImportant": false,
//       "requireLogin": false,
//       "action": {"type": "page", "value": RouteName.violationGuideMainPage},
//       "ar": {
//         "title": "violation_select_guide_title_page",
//         "description": null,
//         "tag": null
//       },
//       "en": {
//         "title": "violation_select_guide_title_page",
//         "description": null,
//         "tag": null
//       }
//     },
//     {
//       "id": 403,
//       "icon": "fee_calculator",
//       "3d_icon": null,
//       "order": 12,
//       "isNew": false,
//       "isImportant": false,
//       "requireLogin": false,
//       "action": {"type": "page", "value": RouteName.calculatorMapRoute},
//       "ar": {"title": "fee_calculator", "description": null, "tag": null},
//       "en": {"title": "fee_calculator", "description": null, "tag": null}
//     },
//     {
//       "id": 404,
//       "icon": "your_opnion_matter",
//       "3d_icon": null,
//       "order": 10,
//       "isNew": true,
//       "isImportant": false,
//       "requireLogin": false,
//       "action": {"type": "page", "value": RouteName.qrScreenRoute},
//       "ar": {
//         "title": "homeAppsYourOpinionWord",
//         "description": "يمكنك الآن حجز موعد عبر التطبيق !",
//         "tag": null
//       },
//       "en": {
//         "title": "homeAppsYourOpinionWord",
//         "description": "You can now book an appointment through the app!",
//         "tag": null
//       }
//     },
//     {
//       "id": 405,
//       "icon": "transaction_inquery",
//       "3d_icon": null,
//       "order": 8,
//       "isNew": true,
//       "isImportant": false,
//       "requireLogin": true,
//       "action": {
//         "type": "page",
//         "value": RouteName.newTransactionInquiryScreen
//       },
//       "ar": {
//         "title": "transaction_inquery",
//         "description": "يمكنك الآن حجز موعد عبر التطبيق !",
//         "tag": null
//       },
//       "en": {
//         "title": "transaction_inquery",
//         "description": "You can now book an appointment through the app!",
//         "tag": null
//       }
//     },
//     {
//       "id": 406,
//       "icon": "supporter",
//       "3d_icon": null,
//       "order": 3,
//       "isNew": false,
//       "isImportant": true,
//       "requireLogin": true,
//       "action": {"type": "dialog", "value": "/supporter"},
//       "ar": {"title": "supporter", "description": null, "tag": null},
//       "en": {"title": "supporter", "description": null, "tag": null}
//     },
//     /*{
//       "id": 7,
//       "icon": "municpal_toppaco",
//       "3d_icon": null,
//       "order": 6,
//       "isNew": false,
//       "isImportant": false,
//       "action": {
//         "type": "page",
//         "value": RemoteConfig.baladyBaseUrl + "/Eservices/Tobacco"
//       },
//       "ar": {
//         "title": "municpal_toppaco".tr(),
//         "description": null,
//         "tag": null
//       },
//       "en": {"title": "Objections", "description": null, "tag": null}
//     },
//     {
//       "id": 8,
//       "icon": "municpal_all",
//       "3d_icon": null,
//       "order": 1,
//       "isNew": false,
//       "isImportant": false,
//       "action": {"type": "page", "value": "${RemoteConfig.webSiteUrl}/ar"},
//       "ar": {
//         "title": "municpal_all",
//         "description": "",
//         "tag": null,
//       },
//       "en": {
//         "title": "municpal_all",
//         "description":
//             "Improve the civil scene of your city and report visual pollution",
//         "tag": null,
//         "warning":
//             ". Please renew the license before it expires or cancel it if you do not want to renew it in order to avoid the required delay penalty fees.\n. The license can be renewed 90 days before its expiry date."
//       },
//     },*/
//   ],
//   "ekram_services": [
//     {
//       "id": 213,
//       "icon": "ekram_benf_transport",
//       "3d_icon": null,
//       "order": 1,
//       "isNew": false,
//       "requireLogin": true,
//       "isImportant": false,
//       "action": {
//         "type": "page",
//         "value": RouteName.ekramTransportationListScreen
//       },
//       "ar": {"title": "ekram_benf_transport", "description": null, "tag": null},
//       "en": {"title": "ekram_benf_transport", "description": null, "tag": null}
//     },
//     {
//       "id": 214,
//       "icon": "ekram_inq_graves",
//       "3d_icon": null,
//       "order": 1,
//       "isNew": false,
//       "requireLogin": true,
//       "isImportant": false,
//       "action": {
//         "type": "page",
//         "value": RouteName.EkramInquiryCemetryDetailsPage
//       },
//       "ar": {
//         "title": "ekram_inquiry_burial_grave",
//         "description": null,
//         "tag": null
//       },
//       "en": {
//         "title": "ekram_inquiry_burial_grave",
//         "description": null,
//         "tag": null
//       }
//     },
//     {
//       "id": 215,
//       "icon": "ekram_inq_grave_dead",
//       "3d_icon": null,
//       "order": 1,
//       "isNew": false,
//       "requireLogin": true,
//       "isImportant": false,
//       "action": {
//         "type": "page",
//         "value": RouteName.EkramInquiryGravesDetailsPage
//       },
//       "ar": {
//         "title": "ekram_inquiry_about_grave",
//         "description": null,
//         "tag": null
//       },
//       "en": {
//         "title": "ekram_inquiry_about_grave",
//         "description": null,
//         "tag": null
//       }
//     },
//     {
//       "id": 216,
//       "icon": "ekram_orgnization",
//       "3d_icon": null,
//       "order": 1,
//       "isNew": false,
//       "requireLogin": true,
//       "isImportant": false,
//       "action": {
//         "type": "page",
//         "value": RouteName.EkramInquiryOrgnizationsDetailsPage
//       },
//       "ar": {
//         "title": "ekram_inquiry_orgnizations",
//         "description": null,
//         "tag": null
//       },
//       "en": {
//         "title": "ekram_inquiry_orgnizations",
//         "description": null,
//         "tag": null
//       }
//     },
//     {
//       "id": 217,
//       "icon": "ekram_print",
//       "3d_icon": null,
//       "order": 1,
//       "isNew": false,
//       "requireLogin": true,
//       "isImportant": false,
//       "action": {
//         "type": "page",
//         "value": RouteName.EkramInquiryPrintDetailsPage
//       },
//       "ar": {
//         "title": "ekram_print_certificate",
//         "description": null,
//         "tag": null
//       },
//       "en": {
//         "title": "ekram_print_certificate",
//         "description": null,
//         "tag": null
//       }
//     },
//     {
//       "id": 218,
//       "icon": "ekram_reserve_cemetry",
//       "3d_icon": null,
//       "order": 1,
//       "isNew": false,
//       "requireLogin": true,
//       "isImportant": false,
//       "action": {"type": "page", "value": RouteName.ekramBookingListScreen},
//       "ar": {
//         "title": "cemetery_booking_request",
//         "description": null,
//         "tag": null
//       },
//       "en": {
//         "title": "cemetery_booking_request",
//         "description": null,
//         "tag": null
//       }
//     },
//     {
//       "id": 316,
//       "icon": "ekram_employee",
//       "3d_icon": null,
//       "order": 1,
//       "isNew": false,
//       "requireLogin": true,
//       "isImportant": false,
//       "action": {
//         "type": "page",
//         "value": RouteName.driverEkramTransportationListScreen
//       },
//       "ar": {"title": "ekram_empolyee_title", "description": null, "tag": null},
//       "en": {"title": "ekram_empolyee_title", "description": null, "tag": null}
//     },
//   ]
// };

Map<String, dynamic> newServicesConfig = {
  "mostUsedService": {
    "title": "Hi! How can I help you? ",
    "label": "I am your smart assistant ",
    "color": "00B8B2",
    "service": {
      "id": 408,
      "title": "المستشار الذكي",
      "label": "المستشار الذكي",
      "icon": "smart_advisor",
      "image": "smart_advisor",
      "order": 1,
      "isNew": false,
      "requireLogin": false,
      "levelLogin": "guest",
      "actionType": "page",
      "actionValue": "smart_advisor",
      "listOfServices": [],
      "serviceId": null
    }
  },
  "mostUsedServices": [
    {
      "id": 206,
      "title": "إصدار شهادة امتثال المباني",
      "label": "يمكن اصدار شادة امتثال المباني",
      "icon": "submit_compliance",
      "image": "ekram_inq_grave_dead",
      "order": 4,
      "isNew": false,
      "requireLogin": true,
      "levelLogin": "sso",
      "actionType": "page",
      "actionValue": "Compliance_Certificate_Service_Card_Page",
      "listOfServices": [],
      "serviceId": 11429
    },
    {
      "id": 301,
      "title": "إصدار رخصة تجارية",
      "label": "إصدار رخصة تجارية",
      "icon": "issue-commercial",
      "image": "issue-commercial",
      "order": 1,
      "isNew": false,
      "requireLogin": true,
      "levelLogin": "sso",
      "actionType": "page",
      "actionValue": "CommercialLicense_Service_Card_Page",
      "listOfServices": [],
      "serviceId": 11010
    }
  ],
  /////////////////////////////////////////////////////////////////////////////
  "servicesCategories": [
    {
      "title": "خدمات يومية",
      "icon": "",
      "listOfServices": [
        {
          "id": 101,
          "title": "القرآن الكريم",
          "label": "holy_quran",
          "icon": "holy_quran",
          "image": "",
          "order": 1,
          "isNew": false,
          "requireLogin": false,
          "levelLogin": "guest",
          "actionType": "page",
          "actionValue": "Quran_Show_All_Surahs_Page",
          "listOfServices": [],
          "serviceId": null,
          "eventName": "",
          "requireSelectedDelegator": false
        },
        {
          "id": 102,
          "title": "أوقات الصلاة",
          "label": "prayerTimes",
          "icon": "prayer_times",
          "image": "",
          "order": 2,
          "isNew": false,
          "requireLogin": false,
          "levelLogin": "guest",
          "actionType": "page",
          "actionValue": "Prayer_Times_Page",
          "listOfServices": [],
          "serviceId": null,
          "eventName": "",
          "requireSelectedDelegator": false
        },
        {
          "id": 103,
          "title": "تبرع مع جود الإسكان",
          "label": "jod",
          "icon": "Jood",
          "image": "",
          "order": 0,
          "isNew": false,
          "requireLogin": false,
          "levelLogin": "guest",
          "actionType": "page",
          "actionValue": "JodDonationPage",
          "listOfServices": [],
          "serviceId": null,
          "eventName": "",
          "requireSelectedDelegator": false
        },
        {
          "id": 104,
          "title": "تقويم المملكة",
          "label": "saudi_calendar",
          "icon": "calendar-2",
          "image": "",
          "order": 5,
          "isNew": false,
          "requireLogin": false,
          "levelLogin": "guest",
          "actionType": "page",
          "actionValue": "kingdomCalendar_Page",
          "listOfServices": [],
          "serviceId": null,
          "eventName": "",
          "requireSelectedDelegator": false
        },
        {
          "id": 105,
          "title": "الأذكار",
          "label": "azkar",
          "icon": "azkar",
          "image": "",
          "order": 3,
          "isNew": false,
          "requireLogin": false,
          "levelLogin": "guest",
          "actionType": "page",
          "actionValue": "Athkar_Page",
          "listOfServices": [],
          "serviceId": null,
          "eventName": "",
          "requireSelectedDelegator": false
        },
        {
          "id": 106,
          "title": "تقويم الفعاليات",
          "label": "events",
          "icon": "ticket-2",
          "image": "",
          "order": 4,
          "isNew": false,
          "requireLogin": false,
          "levelLogin": "guest",
          "actionType": "page",
          "actionValue": "Events_page",
          "listOfServices": [],
          "serviceId": null,
          "eventName": "",
          "requireSelectedDelegator": false
        },
        {
          "id": 107,
          "title": "نقاط توزيع ماء زمزم",
          "label": "zamzam_points",
          "icon": "zamzam_points",
          "image": "",
          "order": 4,
          "isNew": false,
          "requireLogin": false,
          "levelLogin": "guest",
          "actionType": "page",
          "actionValue": "ZmZm_Page",
          "listOfServices": [],
          "serviceId": null,
          "eventName": "",
          "requireSelectedDelegator": false
        }
      ]
    },
    {
      "title": "خدمات الأفراد",
      "icon": "",
      "listOfServices": [
        {
          "id": 307,
          "title": "إصدار شهادة الامتثال",
          "label": "compliance_certificate",
          "icon": "submit_compliance",
          "image": "",
          "order": 4,
          "isNew": false,
          "requireLogin": true,
          "levelLogin": "sso",
          "actionType": "page",
          "actionValue": "Compliance_Certificate_Service_Card_Page",
          "listOfServices": [],
          "serviceId": 11429,
          "eventName": "",
          "requireSelectedDelegator": false
        },
        {
          "id": 201,
          "title": "صور وأرسل",
          "label": "sendImage",
          "icon": "send_image",
          "image": "",
          "order": 1,
          "isNew": false,
          "requireLogin": false,
          "levelLogin": "guest",
          "actionType": "page",
          "actionValue": "VDAllTypesScreen",
          "listOfServices": [],
          "serviceId": null,
          "eventName": "SnapAndSend_Open_From_Services_Event",
          "requireSelectedDelegator": false
        },
        {
          "id": 311,
          "title": "تقديم طلب اعتراض",
          "label": "submit_objections",
          "icon": "objections",
          "image": "",
          "order": 6,
          "isNew": false,
          "requireLogin": true,
          "levelLogin": "sso",
          "actionType": "page",
          "actionValue": "Objectable_Transactions_Page",
          "listOfServices": [],
          "serviceId": null,
          "eventName": "",
          "requireSelectedDelegator": false
        },
        {
          "id": 203,
          "title": "طلب خدمة بلدية",
          "label": "request_service",
          "icon": "request_service",
          "image": "",
          "order": 5,
          "isNew": false,
          "requireLogin": true,
          "levelLogin": "sso",
          "actionType": "page",
          "actionValue": "MSRTypeScreen",
          "listOfServices": [],
          "serviceId": null,
          "eventName": "",
          "requireSelectedDelegator": false
        },
        {
          "id": 204,
          "title": "حجز موعد إلكتروني",
          "label": "schedule_date",
          "icon": "schedule_date",
          "image": "",
          "order": 4,
          "isNew": false,
          "requireLogin": true,
          "levelLogin": "sso",
          "actionType": "page",
          "actionValue": "Appointment_Booking_Create_Page",
          "listOfServices": [],
          "serviceId": null,
          "eventName": "",
          "requireSelectedDelegator": false
        },
        {
          "id": 314,
          "title": "خدمات الترخيص والمخططات",
          "label": "balady_works",
          "icon": "balady_business",
          "image": "",
          "order": 1,
          "isNew": false,
          "requireLogin": true,
          "levelLogin": "sso",
          "actionType": "page",
          "actionValue": "/etmamMainPage",
          "listOfServices": [],
          "serviceId": null,
          "eventName": "",
          "requireSelectedDelegator": false
        },
        {
          "id": 205,
          "title": "خدمات المدن",
          "label": "service_provide_services",
          "icon": "cities_services",
          "image": "",
          "order": 4,
          "isNew": false,
          "requireLogin": true,
          "levelLogin": "sso",
          "actionType": "page",
          "actionValue": "/CityServicesEtmamMainPage",
          "listOfServices": [],
          "serviceId": null,
          "eventName": "",
          "requireSelectedDelegator": false
        },
        {
          "id": 208,
          "title": "بلاغ عن سيارة تالفة",
          "label": "ruined_car_request",
          "icon": "damaged_cars",
          "image": "",
          "order": 9,
          "isNew": false,
          "requireLogin": true,
          "levelLogin": "sso",
          "actionType": "page",
          "actionValue": "Report_Write-Off_Vehicle_Camera_Page",
          "listOfServices": [],
          "serviceId": null,
          "eventName": "",
          "requireSelectedDelegator": false
        },
        {
          "id": 209,
          "title": "استعادة مركبة مسحوبة",
          "label": "dc_retreive_car",
          "icon": "retrieve_car",
          "image": "",
          "order": 9,
          "isNew": true,
          "requireLogin": true,
          "levelLogin": "sso",
          "actionType": "page",
          "actionValue": "Retrieve_Impounded_Vehicle_Show_My_Vehicles_Page",
          "listOfServices": [],
          "serviceId": null,
          "eventName": "",
          "requireSelectedDelegator": false
        },
        {
          "id": 212,
          "title": "إصدار شهادة صحية",
          "label": "municipal_health",
          "icon": "municipal_health",
          "image": "",
          "order": 3,
          "isNew": false,
          "requireLogin": true,
          "levelLogin": "sso",
          "actionType": "page",
          "actionValue": "HealthCertificate_Create_Details_Page",
          "listOfServices": [],
          "serviceId": null,
          "eventName": "",
          "requireSelectedDelegator": false
        },
        {
          "id": 221,
          "title": "إكرام",
          "label": "ekram_services",
          "icon": "ekram_inq_grave_dead",
          "image": "",
          "order": 4,
          "isNew": false,
          "requireLogin": true,
          "levelLogin": "sso",
          "actionType": "page",
          "actionValue": "subServicesScreen",
          "listOfServices": [
            {
              "id": 213,
              "title": "طلبات نقل وتجهيز متوفى",
              "label": "ekram_benf_transport",
              "icon": "ekram_benf_transport",
              "image": "",
              "order": 1,
              "isNew": false,
              "requireLogin": true,
              "levelLogin": "sso",
              "actionType": "page",
              "actionValue":
                  "RequestsTransportingAndPreparingDeceased_List_Page",
              "listOfServices": [],
              "serviceId": null,
              "eventName": "",
              "requireSelectedDelegator": false
            },
            {
              "id": 214,
              "title": "الاستعلام عن المقابر",
              "label": "ekram_inquiry_burial_grave",
              "icon": "ekram_inq_graves",
              "image": "",
              "order": 1,
              "isNew": false,
              "requireLogin": true,
              "levelLogin": "sso",
              "actionType": "page",
              "actionValue": "Cemetery_Inquiry_Create_Details_Page",
              "listOfServices": [],
              "serviceId": null,
              "eventName": "",
              "requireSelectedDelegator": false
            },
            {
              "id": 215,
              "title": "الاستعلام عن موقع قبر متوفى",
              "label": "ekram_inquiry_about_grave",
              "icon": "ekram_inq_grave_dead",
              "image": "",
              "order": 1,
              "isNew": false,
              "requireLogin": true,
              "levelLogin": "sso",
              "actionType": "page",
              "actionValue": "Cemetery_Inquiry_Create_Results_Page",
              "listOfServices": [],
              "serviceId": null,
              "eventName": "",
              "requireSelectedDelegator": false
            },
            {
              "id": 216,
              "title": "استعلام عن مقدمي خدمات نقل وتجهيز الموتى",
              "label": "ekram_inquiry_orgnizations",
              "icon": "ekram_orgnization",
              "image": "",
              "order": 1,
              "isNew": false,
              "requireLogin": true,
              "levelLogin": "sso",
              "actionType": "page",
              "actionValue": "Funeral_Service_Inquiry_Create_Details_Page",
              "listOfServices": [],
              "serviceId": null,
              "eventName": "",
              "requireSelectedDelegator": false
            },
            {
              "id": 217,
              "title": "طباعة شهادة الدفن",
              "label": "ekram_print_certificate",
              "icon": "ekram_print",
              "image": "",
              "order": 1,
              "isNew": false,
              "requireLogin": true,
              "levelLogin": "sso",
              "actionType": "page",
              "actionValue": "Print_Burial_Certificate_Page",
              "listOfServices": [],
              "serviceId": null,
              "eventName": "",
              "requireSelectedDelegator": false
            },
            {
              "id": 218,
              "title": "اختيار وحجز مقبرة",
              "label": "cemetery_booking_request",
              "icon": "ekram_reserve_cemetry",
              "image": "",
              "order": 1,
              "isNew": false,
              "requireLogin": true,
              "levelLogin": "sso",
              "actionType": "page",
              "actionValue": "SelectAndReserveCemetery_List_Page",
              "listOfServices": [],
              "serviceId": null,
              "eventName": "",
              "requireSelectedDelegator": false
            },
            {
              "id": 316,
              "title": "سائق نقل الموتى",
              "label": "ekram_empolyee_title",
              "icon": "ekram_employee",
              "image": "",
              "order": 1,
              "isNew": false,
              "requireLogin": true,
              "levelLogin": "sso",
              "actionType": "page",
              "actionValue": "FuneralDriver_List_Page",
              "listOfServices": [],
              "serviceId": null,
              "eventName": "",
              "requireSelectedDelegator": false
            }
          ],
          "serviceId": null,
          "eventName": "",
          "requireSelectedDelegator": false
        },
        {
          "id": 308,
          "title": "قيم مبناك",
          "label": "review-building",
          "icon": "self_rating",
          "image": "",
          "order": 4,
          "isNew": false,
          "requireLogin": false,
          "levelLogin": "guest",
          "actionType": "page",
          "actionValue": "PremisesAssessment_Main_Page",
          "listOfServices": [],
          "serviceId": null,
          "eventName": "",
          "requireSelectedDelegator": false
        },
        {
          "id": 219,
          "title": "الخدمات الإنشائية",
          "label": "municpal_construction",
          "icon": "municpal_construction",
          "image": "",
          "order": 2,
          "isNew": false,
          "requireLogin": true,
          "levelLogin": "sso",
          "actionType": "openBaladyWebView",
          "actionValue": "https://balady.momra.gov.sa/ar/products/10470",
          "listOfServices": [],
          "serviceId": null,
          "eventName": "",
          "requireSelectedDelegator": false
        },
        {
          "id": 220,
          "title": "المتاجر المتنقلة",
          "label": "municipal_shop",
          "icon": "municipal_shop",
          "image": "",
          "order": 4,
          "isNew": false,
          "requireLogin": true,
          "levelLogin": "sso",
          "actionType": "openBaladyWebView",
          "actionValue": "https://balady.momra.gov.sa/ar/products/10574",
          "listOfServices": [],
          "serviceId": null,
          "eventName": "Start_Service_MobileStores",
          "requireSelectedDelegator": false
        },
        {
          "id": 222,
          "title": "التحقق من شهادة التصنيف",
          "label": "classification_certificate_verify",
          "icon": "note",
          "image": "",
          "order": 4,
          "isNew": true,
          "requireLogin": false,
          "levelLogin": "guest",
          "actionType": "page",
          "actionValue": "classification_certificate_verify_screen",
          "listOfServices": [],
          "serviceId": 11340,
          "eventName": "",
          "requireSelectedDelegator": false
        },
        {
          "id": 11124,
          "title": "الاستعلام عن رخصة إنشائية",
          "label": "inquiry_construction_license",
          "icon": "construction_license_query",
          "image": "",
          "order": 6,
          "isNew": false,
          "requireLogin": false,
          "levelLogin": "guest",
          "actionType": "page",
          "actionValue": "constructionLicenseInquery_Screen",
          "listOfServices": [],
          "serviceId": 11124,
          "eventName": "",
          "requireSelectedDelegator": false
        },
        {
          "id": 11428,
          "title": "الاستعلام عن تقرير مساحي",
          "label": "survey_report_inquery",
          "icon": "license_query",
          "image": "",
          "order": 6,
          "isNew": false,
          "requireLogin": false,
          "levelLogin": "guest",
          "actionType": "page",
          "actionValue": "SurveyReportInquery_Screen",
          "listOfServices": [],
          "serviceId": 11428,
          "eventName": "",
          "requireSelectedDelegator": false
        },
        {
          "id": 11134,
          "title": "الاستعلام عن رخصة تجارية",
          "label": "CommerciallicenseQuery",
          "icon": "commercial_license_query",
          "image": "",
          "order": 6,
          "isNew": false,
          "requireLogin": true,
          "levelLogin": "sso",
          "actionType": "page",
          "actionValue": "QueryCommercialLicense_Screen",
          "listOfServices": [],
          "serviceId": 11134,
          "eventName": "",
          "requireSelectedDelegator": false
        },
        {
          "id": 210,
          "title": "الإستفسارات العامة",
          "label": "general_requests",
          "icon": "general_inquiries",
          "image": "",
          "order": 2,
          "isNew": false,
          "requireLogin": true,
          "levelLogin": "sso",
          "actionType": "page",
          "actionValue": "GeneralInquiryTypeScreen",
          "listOfServices": [],
          "serviceId": null,
          "eventName": "",
          "requireSelectedDelegator": false
        }
      ]
    },
    {
      "title": "خدمات الأعمال",
      "icon": "",
      "listOfServices": [
        {
          "id": 301,
          "title": "إصدار رخصة تجارية",
          "label": "issue_commerical_license",
          "icon": "issue-commercial",
          "image": "",
          "order": 5,
          "isNew": false,
          "requireLogin": true,
          "levelLogin": "sso",
          "actionType": "page",
          "actionValue": "CommercialLicense_Service_Card_Page",
          "listOfServices": [],
          "serviceId": 11010,
          "eventName": "",
          "requireSelectedDelegator": true,
        },
        {
          "id": 302,
          "title": "التصاريح المتعددة",
          "label": "multiple_permits",
          "icon": "posters_permits",
          "image": "",
          "order": 5,
          "isNew": false,
          "requireLogin": true,
          "levelLogin": "sso",
          "actionType": "page",
          "actionValue": "CommercialPermitsScreen",
          "listOfServices": [],
          "serviceId": null,
          "eventName": "",
          "requireSelectedDelegator": true,
        },
        {
          "id": 303,
          "title": "الإفصاح عن التبغ",
          "label": "tobaccoServices",
          "icon": "toppaco_services",
          "image": "",
          "order": 0,
          "isNew": false,
          "requireLogin": true,
          "levelLogin": "sso",
          "actionType": "page",
          "actionValue": "/tobaccoServicesList",
          "listOfServices": [],
          "serviceId": null,
          "eventName": "",
          "requireSelectedDelegator": false
        },
        {
          "id": 306,
          "title": "منصة إيواء",
          "label": "municipal_ewaa",
          "icon": "municipal_ewaa",
          "image": "",
          "order": 6,
          "isNew": false,
          "requireLogin": true,
          "levelLogin": "sso",
          "actionType": "openBaladyWebView",
          "actionValue": "https://stgfees.momra.gov.sa/ewaa",
          "listOfServices": [],
          "serviceId": null,
          "eventName": "Start_Service_EwaaPlatform",
          "requireSelectedDelegator": false
        },
        {
          "id": 307,
          "title": "إصدار شهادة الامتثال",
          "label": "compliance_certificate",
          "icon": "submit_compliance",
          "image": "",
          "order": 4,
          "isNew": false,
          "requireLogin": true,
          "levelLogin": "sso",
          "actionType": "page",
          "actionValue": "Compliance_Certificate_Service_Card_Page",
          "listOfServices": [],
          "serviceId": 11429,
          "eventName": "",
          "requireSelectedDelegator": false
        },
        {
          "id": 308,
          "title": "قيم مبناك",
          "label": "review-building",
          "icon": "self_rating",
          "image": "",
          "order": 4,
          "isNew": false,
          "requireLogin": false,
          "levelLogin": "guest",
          "actionType": "page",
          "actionValue": "PremisesAssessment_Main_Page",
          "listOfServices": [],
          "serviceId": null,
          "eventName": "",
          "requireSelectedDelegator": false
        },
        {
          "id": 309,
          "title": "الخدمات التجارية",
          "label": "municipal_commercial",
          "icon": "municipal_commercial",
          "image": "",
          "order": 1,
          "isNew": false,
          "requireLogin": true,
          "levelLogin": "sso",
          "actionType": "openBaladyWebView",
          "actionValue": "https://balady.momra.gov.sa/ar/products/10920",
          "listOfServices": [],
          "serviceId": null,
          "eventName": "Start_Service_CommercialServices",
          "requireSelectedDelegator": false
        },
        {
          "id": 311,
          "title": "تقديم طلب اعتراض",
          "label": "submit_objections",
          "icon": "objections",
          "image": "",
          "order": 6,
          "isNew": false,
          "requireLogin": true,
          "levelLogin": "sso",
          "actionType": "page",
          "actionValue": "Objectable_Transactions_Page",
          "listOfServices": [],
          "serviceId": null,
          "eventName": "",
          "requireSelectedDelegator": false
        },
        {
          "id": 210,
          "title": "الإستفسارات العامة",
          "label": "general_requests",
          "icon": "general_inquiries",
          "image": "",
          "order": 2,
          "isNew": false,
          "requireLogin": true,
          "levelLogin": "sso",
          "actionType": "page",
          "actionValue": "GeneralInquiryTypeScreen",
          "listOfServices": [],
          "serviceId": null,
          "eventName": "",
          "requireSelectedDelegator": false
        },
        {
          "id": 314,
          "title": "خدمات الترخيص والمخططات",
          "label": "balady_works",
          "icon": "balady_business",
          "image": "",
          "order": 1,
          "isNew": false,
          "requireLogin": true,
          "levelLogin": "sso",
          "actionType": "page",
          "actionValue": "/etmamMainPage",
          "listOfServices": [],
          "serviceId": null,
          "eventName": "",
          "requireSelectedDelegator": false
        },
        {
          "id": 315,
          "title": "الخدمات الإنشائية",
          "label": "municpal_construction",
          "icon": "municpal_construction",
          "image": "",
          "order": 2,
          "isNew": false,
          "requireLogin": true,
          "levelLogin": "sso",
          "actionType": "openBaladyWebView",
          "actionValue": "https://balady.momra.gov.sa/ar/products/10470",
          "listOfServices": [],
          "serviceId": null,
          "eventName": "Start_Service_ConstructionServices",
          "requireSelectedDelegator": false
        },
        {
          "id": 222,
          "title": "التحقق من شهادة التصنيف",
          "label": "classification_certificate_verify",
          "icon": "note",
          "image": "",
          "order": 4,
          "isNew": true,
          "requireLogin": false,
          "levelLogin": "guest",
          "actionType": "page",
          "actionValue": "classification_certificate_verify_screen",
          "listOfServices": [],
          "serviceId": 11340,
          "eventName": "",
          "requireSelectedDelegator": false
        }
      ]
    },
    {
      "title": "خدمات مساعدة",
      "icon": "",
      "listOfServices": [
        {
          "id": 408,
          "title": "المستشار الذكي",
          "label": "smart_advisor",
          "icon": "smart_advisor",
          "image": "",
          "order": 13,
          "isNew": false,
          "requireLogin": false,
          "levelLogin": "guest",
          "actionType": "page",
          "actionValue": "smart_advisor",
          "listOfServices": [],
          "serviceId": null,
          "eventName": "",
          "requireSelectedDelegator": false
        },
        {
          "id": 499,
          "title": "تقويم بلدي",
          "label": "balady_calendar",
          "icon": "calender",
          "image": "",
          "order": 13,
          "isNew": false,
          "requireLogin": true,
          "levelLogin": "sso",
          "actionType": "page",
          "actionValue": "/baladyCalendarPage",
          "listOfServices": [],
          "serviceId": null,
          "eventName": "",
          "requireSelectedDelegator": false
        },
        {
          "id": 402,
          "title": "دليل المخالفات",
          "label": "violation_select_guide_title_page",
          "icon": "violation-guide",
          "image": "",
          "order": 5,
          "isNew": false,
          "requireLogin": false,
          "levelLogin": "guest",
          "actionType": "page",
          "actionValue": "ViolationGuide_Main_Page",
          "listOfServices": [],
          "serviceId": null,
          "eventName": "",
          "requireSelectedDelegator": false
        },
        {
          "id": 403,
          "title": "حاسبه الرسوم",
          "label": "fee_calculator",
          "icon": "fee_calculator",
          "image": "",
          "order": 12,
          "isNew": false,
          "requireLogin": false,
          "levelLogin": "guest",
          "actionType": "page",
          "actionValue": "CalculatorFees_Create_Map_Page",
          "listOfServices": [],
          "serviceId": null,
          "eventName": "",
          "requireSelectedDelegator": false
        },
        {
          "id": 404,
          "title": "رأيك يفرق",
          "label": "homeAppsYourOpinionWord",
          "icon": "your_opnion_matter",
          "image": "",
          "order": 10,
          "isNew": true,
          "requireLogin": false,
          "levelLogin": "guest",
          "actionType": "page",
          "actionValue": "YourFeedback_Camera_Page",
          "listOfServices": [],
          "serviceId": null,
          "eventName": "",
          "requireSelectedDelegator": false
        },
        {
          "id": 405,
          "title": "استعلام عن معاملة",
          "label": "transaction_inquery",
          "icon": "transaction_inquery",
          "image": "",
          "order": 8,
          "isNew": true,
          "requireLogin": true,
          "levelLogin": "sso",
          "actionType": "page",
          "actionValue": "RequestFollowup_Create_Details_Page",
          "listOfServices": [],
          "serviceId": null,
          "eventName": "",
          "requireSelectedDelegator": false
        },
        {
          "id": 406,
          "title": "داعم",
          "label": "supporter",
          "icon": "supporter",
          "image": "",
          "order": 3,
          "isNew": false,
          "requireLogin": true,
          "levelLogin": "sso",
          "actionType": "page",
          "actionValue": "DaemTypeScreen",
          "listOfServices": [],
          "serviceId": null,
          "eventName": "",
          "requireSelectedDelegator": false
        }
      ]
    },
  ]
};

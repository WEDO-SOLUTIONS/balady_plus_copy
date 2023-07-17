import 'package:balady_plus/app/core/utils/constants/route_names.dart';

Map<String, dynamic> servicesConfig = {
  "public_services": [
    {
      "id": 1,
      "icon": "holy_quran",
      "3d_icon": null,
      "order": 1,
      "isNew": false,
      "isImportant": false,
      "action": {"type": "page", "value": "/holy-quran"},
      "ar": {"title": "المصحف الشريف", "description": null, "tag": null},
      "en": {"title": "Holy Quran", "description": null, "tag": null}
    },
    {
      "id": 2,
      "icon": "prayer_times",
      "3d_icon": null,
      "order": 2,
      "isNew": false,
      "isImportant": false,
      "action": {"type": "page", "value": "/prayerTimes"},
      "ar": {"title": "أوقات الصلاة", "description": null},
      "en": {"title": "Prayer Times", "description": null}
    },
    {
      "id": 3,
      "icon": "azkar",
      "3d_icon": null,
      "order": 3,
      "isNew": false,
      "isImportant": false,
      "action": {"type": "page", "value": "/azkar"},
      "ar": {"title": "الأذكار", "description": null, "tag": null},
      "en": {"title": "Azkar", "description": null, "tag": null}
    },
    {
      "id": 4,
      "icon": "zamzam_points",
      "3d_icon": null,
      "order": 4,
      "isNew": false,
      "isImportant": false,
      "action": {"type": "page", "value": "/zamazem"},
      "ar": {"title": "نقاط توزيع ماء زمزم", "description": null, "tag": null},
      "en": {"title": "Zamzam Points", "description": null, "tag": null}
    },
    {
      "id": 5,
      "icon": "scanner",
      "3d_icon": null,
      "order": 5,
      "isNew": false,
      "isImportant": false,
      "action": {"type": "page", "value": "/scanner"},
      "ar": {"title": "ماسح الرمز السريع", "description": null, "tag": null},
      "en": {"title": "QR Scanner", "description": null, "tag": null}
    },
    {
      "id": 6,
      "icon": "qiblah",
      "3d_icon": null,
      "order": 6,
      "isNew": false,
      "isImportant": false,
      "action": {"type": "page", "value": "/qiblahCompass"},
      "ar": {"title": "بوصلة القبلة", "description": null, "tag": null},
      "en": {"title": "Qiblah Compass", "description": null, "tag": null}
    }
  ],
  "municipal_services": [
    {
      "id": 1,
      "icon": "send_image",
      "3d_icon": null,
      "order": 1,
      "isNew": false,
      "isImportant": false,
      "action": {"type": "cards", "value": ""},
      "ar": {
        "title": "البلاغات",
        "description": "حسن المشهد الحضاري لمدينتك وبلغ عن مظاهر التشوه البصري",
        "tag": null,
        "warning":
            ". يرجى الالتزام بتجديد الرخصة قبل انتهائها أو إلغائها في حالة عدم الرغبة في تجديدها وذلك لتجنب رسوم غرامة المشترطة على التأخير في التجديد.\n. يمكن تجديد الرخصة قبل 90 يوم من تاريخ انتهائها."
      },
      "en": {
        "title": "Send Image",
        "description":
            "Improve the civil scene of your city and report visual pollution",
        "tag": null,
        "warning":
            ". Please renew the license before it expires or cancel it if you do not want to renew it in order to avoid the required delay penalty fees.\n. The license can be renewed 90 days before its expiry date."
      },
      "cards": [
        {
          "iconName": "service_description",
          "rate": 5.4,
          "duration": 5,
          "ar": {
            "title": "وصف الخدمه",
            "description":
                "من خلال هذه الخدمة يمكنك البدء بممارسة العمل التجاري من خلال إصدار رخصة نشاط تجاري  بالإضافة إلى تصريح السلامة الصادر من المديرية العامة للدفاع المدني لجميع الأنشطة التجارية المعتمدة لدى وزارة الشؤون البلدية والقروية والإسكان."
          },
          "en": {
            "title": "Service Description",
            "description":
                "Through this service, you can start practicing business by issuing a commercial activity license in addition to the safety permit issued by the General Directorate of Civil Defense for all commercial activities approved by the Ministry of Municipal and Rural Affairs and Housing."
          }
        },
        {
          "iconName": "requirements",
          "rate": 5.4,
          "duration": 5,
          "ar": {
            "title": "المتطلبات",
            "description":
                "من خلال هذه الخدمة يمكنك البدء بممارسة العمل التجاري من خلال إصدار رخصة نشاط تجاري  بالإضافة إلى تصريح السلامة الصادر من المديرية العامة للدفاع المدني لجميع الأنشطة التجارية المعتمدة لدى وزارة الشؤون البلدية والقروية والإسكان."
          },
          "en": {
            "title": "Requirements",
            "description":
                "Through this service, you can start practicing business by issuing a commercial activity license in addition to the safety permit issued by the General Directorate of Civil Defense for all commercial activities approved by the Ministry of Municipal and Rural Affairs and Housing."
          }
        }
      ]
    },
    {
      "id": 2,
      "icon": "general_inquiries",
      "3d_icon": null,
      "order": 2,
      "isNew": false,
      "isImportant": true,
      "action": {"type": "dialog", "value": "/general-inquiries"},
      "ar": {
        "title": "الإستفسارات العامة",
        "description": "ارسل استفسارك عن كل خدمه",
        "tag": "الخدمات"
      },
      "en": {
        "title": "General Inquiries",
        "description": "Send your inquiry about any service",
        "tag": "Services"
      }
    },
    {
      "id": 3,
      "icon": "supporter",
      "3d_icon": null,
      "order": 3,
      "isNew": false,
      "isImportant": true,
      "action": {"type": "dialog", "value": "/supporter"},
      "ar": {"title": "داعم", "description": null, "tag": null},
      "en": {"title": "Supporter", "description": null, "tag": null}
    },
    {
      "id": 4,
      "icon": "schedule_date",
      "3d_icon": null,
      "order": 4,
      "isNew": false,
      "isImportant": false,
      "action": {"type": "dialog", "value": ""},
      "ar": {"title": "حجز موعد الكتروني", "description": null, "tag": null},
      "en": {"title": "Schedule Date", "description": null, "tag": null}
    },
    {
      "id": 5,
      "icon": "request_service",
      "3d_icon": null,
      "order": 5,
      "isNew": false,
      "isImportant": false,
      "action": {"type": "dialog", "value": RouteName.newMSRMapPage},
      "ar": {"title": "طلب خدمة بلدية", "description": null, "tag": null},
      "en": {"title": "Request Service", "description": null, "tag": null}
    },
    {
      "id": 6,
      "icon": "objections",
      "3d_icon": null,
      "order": 6,
      "isNew": false,
      "isImportant": false,
      "action": {"type": "page", "value": "/objectableTransactionsPage"},
      "ar": {"title": "الاعتراضات والتظلمات", "description": null, "tag": null},
      "en": {"title": "Objections", "description": null, "tag": null}
    },
    {
      "id": 7,
      "icon": "search_status",
      "3d_icon": null,
      "order": 7,
      "isNew": false,
      "isImportant": false,
      "action": {"type": "page", "value": "/search-status"},
      "ar": {"title": "الاستعلامات", "description": null, "tag": null},
      "en": {"title": "Search Status", "description": null, "tag": null}
    },
    {
      "id": 8,
      "icon": "transaction_inquery",
      "3d_icon": null,
      "order": 8,
      "isNew": true,
      "isImportant": false,
      "action": {
        "type": "page",
        "value": RouteName.newTransactionInquiryScreen
      },
      "ar": {
        "title": "استعلام عن معاملة",
        "description": "يمكنك الآن حجز موعد عبر التطبيق !",
        "tag": null
      },
      "en": {
        "title": "Transaction Inquery",
        "description": "You can now book an appointment through the app!",
        "tag": null
      }
    },
    {
      "id": 9,
      "icon": "damaged_cars",
      "3d_icon": null,
      "order": 9,
      "isNew": false,
      "isImportant": false,
      "action": {"type": "page", "value": RouteName.DCCameraPage},
      "ar": {"title": "السيارات التالفة", "description": null, "tag": null},
      "en": {"title": "Damaged Cars", "description": null, "tag": null}
    },
    {
      "id": 10,
      "icon": "your_opnion_matter",
      "3d_icon": null,
      "order": 10,
      "isNew": true,
      "isImportant": false,
      "action": {"type": "page", "value": RouteName.qrScreenRoute},
      "ar": {
        "title": "رأيك يفرق",
        "description": "يمكنك الآن حجز موعد عبر التطبيق !",
        "tag": null
      },
      "en": {
        "title": "Your Opnion Matter",
        "description": "You can now book an appointment through the app!",
        "tag": null
      }
    },
    {
      "id": 11,
      "icon": "issue_trade_license",
      "3d_icon": null,
      "order": 11,
      "isNew": false,
      "isImportant": false,
      "action": {"type": "page", "value": "/issue-trade-license"},
      "ar": {"title": "إصدار رخصة تجارية", "description": null, "tag": null},
      "en": {"title": "Issue Trade License", "description": null, "tag": null}
    },
    {
      "id": 12,
      "icon": "fee_calculator",
      "3d_icon": null,
      "order": 12,
      "isNew": false,
      "isImportant": false,
      "action": {"type": "page", "value": RouteName.calculatorMapRoute},
      "ar": {"title": "حاسبة الرسوم", "description": null, "tag": null},
      "en": {"title": "Fee Calculator", "description": null, "tag": null}
    },
    {
      "id": 13,
      "icon": "municipal_advisor",
      "3d_icon": null,
      "order": 13,
      "isNew": false,
      "isImportant": false,
      "action": {"type": "page", "value": "/municipal-advisor1"},
      "ar": {"title": "المستشار البلدي", "description": null, "tag": null},
      "en": {"title": "Municipal Advisor", "description": null, "tag": null}
    },
    {
      "id": 14,
      "icon": "move_diseased",
      "3d_icon": null,
      "order": 14,
      "isNew": false,
      "isImportant": false,
      "action": {"type": "page", "value": "/move-diseased"},
      "ar": {"title": "نقل وتجهيز الموتي", "description": null, "tag": null},
      "en": {"title": "Move Diseased", "description": null, "tag": null}
    },
    {
      "id": 15,
      "icon": "issue_health_certificate",
      "3d_icon": null,
      "order": 15,
      "isNew": false,
      "isImportant": false,
      "action": {"type": "page", "value": RouteName.newHealthCertificatePage},
      "ar": {"title": "إصدار شهادة صحية", "description": null, "tag": null},
      "en": {
        "title": "Issue Health Certificate",
        "description": null,
        "tag": null
      }
    },
    {
      "id": 16,
      "icon": "damaged_cars",
      "3d_icon": null,
      "order": 9,
      "isNew": false,
      "isImportant": false,
      "action": {"type": "page", "value": "/DCVeichlePage"},
      "ar": {"title": "استعادة مركبة مسحوبة", "description": null, "tag": null},
      "en": {"title": "Damaged Cars", "description": null, "tag": null}
    },
  ]
};

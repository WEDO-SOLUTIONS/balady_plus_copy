import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../services/data/models/service_model.dart';

ServiceModel postersModel() => ServiceModel.fromJson(
      {
        "id": 1,
        "icon": "send_image",
        "3d_icon": null,
        "order": 1,
        "isNew": false,
        "isImportant": false,
        "action": {"type": "cards", "value": ""},
        "ar": {
          "title": 'تصريح إعلاني مؤقت',
          "description": "",
          "tag": null,
          "warning":
              "يمكن إضافة أكثر من لوحة إعلانية بالطلب الواحد.\n\n قد تختلف رسوم الخدمة من بلدية لبلدية أخرى.\n\n يتم حساب الرسوم باليوم.\n\n الخدمة مخصصة للوحات الإعلانية التي يتم عرضها على واجهة المحل أو على الزجاج الخارجي للمحل، أما اللوحات الإعلانية داخل المحل فلا تحتاج لإصدار تصريح."
        },
        "en": {
          "title": 'تصريح إعلاني مؤقت',
          "description": "",
          "tag": null,
          "warning": null
        },
        "cards": [
          {
            "iconName": IconPath.serviceCardDesc,
            "type": ServiceCardsTypes.desc,
            "rate": 0,
            "duration": "",
            "fees": -1,
            "feesName": "",
            "feesLink": "",
            "ar": {
              "title": "وصف الخدمة",
              "description":
                  "يمكن من خلال هذه الخدمة إصدار تصريح إعلاني مؤقت، للوحة إعلانية أو مجموعة من اللوحات الإعلانية،  ليتم عرضها على واجهة المحل أو الزجاج الأمامي للمحل، لمدة محددة، كما يمكنك تحديد نوع اللوحة الإعلانية (تخفيضات/منتج جديد/خدمة للمحل)."
            },
            "en": {"title": "Service Description", "description": ""}
          },
          {
            "iconName": IconPath.serviceCardReq,
            "type": ServiceCardsTypes.req,
            "rate": 0,
            "duration": "0",
            "requirements": [
              "تحديد نوع اللوحة الإعلانية (تخفيضات/منتج جديد/خدمة للمحل)",
              "إدخال اسم اللوحة الإعلانية",
              "تحديد أبعاد اللوحة الإعلانية (الطول والعرض)",
              "إرفاق صورة اللوحة الإعلانية",
              "تحديد المدة المطلوبة بالأيام",
              "تحديد تاريخ بداية التصريح "
            ],
            "ar": {"title": "المتطلبات", "description": ""},
            "en": {"title": "Requirements", "description": ""}
          },
          {
            "iconName": IconPath.serviceCardFlow,
            "type": ServiceCardsTypes.flow,
            "rate": 0,
            "duration": "0",
            "flow": [
              {
                "title": "الطريقة الأولى",
                "steps": [
                  "تسجيل الدخول لتطبيق بلدي ",
                  "استعراض قائمة الرخص التجارية",
                  "تحديد الرخصة التجارية وعرض تفاصيلها",
                  "اختيار خدمة تصريح إعلاني مؤقت"
                ],
              },
              {
                "title": "الطريقة الثانية",
                "steps": [
                  "تسجيل الدخول لتطبيق بلدي ",
                  "التوجه للخدمات البلدية",
                  "التوجه لخدمة التصاريح المتعددة",
                  "اختيار خدمة تصريح إعلاني مؤقت"
                ],
              },
            ],
            "ar": {"title": "خطوات التقديم", "description": ""},
            "en": {"title": "", "description": ""}
          },
          {
            "iconName": IconPath.warning2,
            "type": ServiceCardsTypes.conditions,
            "rate": 0,
            "duration": "",
            "fees": null,
            "ar": {
              "title": "الاشتراطات والموافقات الحكومية",
              "description":
                  "1-ترتبط صلاحية التصريح الإعلاني المؤقت بصلاحية الرخصة التجارية.\n\n2-اللوحات الإعلانية المؤقتة على واجهة المحل يجب ألا تتعدا 50% من الواجهة كحد أقصى.\n\n3-أن تكون اللوحة الإعلانية ضمن مساحة العرض على واجهة المحل وتبعد مسافة متر عن الواجهة كحد أقصى.\n\n4-ألا تزيد الفترة الزمنية المسموح فيها للإعلان عن 90 يوماً من تاريخ إصدار التصريح الإعلاني المؤقت.\n\n5-يشترط أن تكون الرخصة التجارية سارية .\n\n6-يشترط إرفاق موافقة وزارة التجارة  في حال كان نوع اللوحة الإعلانية المؤقتة (تخفيضات).",
            },
            "en": {"title": "Service Description", "description": ""}
          },
          {
            "iconName": IconPath.serviceCardDesc,
            "type": ServiceCardsTypes.others,
            "rate": 0,
            "duration": "0",
            "flow": [
              {
                "title": "رسوم الخدمة",
                "steps": [
                  "لكل لوحة إعلانية بالطلب:",
                  "مساحة اللوحة الإعلانية بالمتر المربع * رسوم المتر المربع لليوم الواحد * عدد الأيام المطلوبة بالتصريح",
                  "ملحوظة: تختلف الرسوم من بلدية لبلدية أخرى.",
                ],
              },
              {
                "title": "وقت تنفيذ الخدمة",
                "steps": [
                  "خدمة فورية/غير فورية وفقاً للبلدية التابع لها الرخصة التجارية"
                ],
              },
              {
                "title": "الغرامات والجزاءات",
                "steps": ["لا يوجد غرامات أو جزاءات"],
              },
            ],
            "ar": {"title": "معلومات أخرى", "description": ""},
            "en": {"title": "", "description": ""}
          },
        ]
      },
    );

ServiceModel permits24Model() => ServiceModel.fromJson(
      {
        "id": 1,
        "icon": "send_image",
        "3d_icon": null,
        "order": 1,
        "isNew": false,
        "isImportant": false,
        "action": {"type": "cards", "value": ""},
        "ar": {
          "title": "permit_24_service_name".tr(),
          "description": "",
          "tag": null,
          "warning":
              "يمكن إضافة أكثر من لوحة إعلانية بالطلب الواحد.\n\n قد تختلف رسوم الخدمة من بلدية لبلدية أخرى.\n\n يتم حساب الرسوم باليوم.\n\n الخدمة مخصصة للوحات الإعلانية التي يتم عرضها على واجهة المحل أو على الزجاج الخارجي للمحل، أما اللوحات الإعلانية داخل المحل فلا تحتاج لإصدار تصريح."
        },
        "en": {
          "title": 'تصريح إعلاني مؤقت',
          "description": "",
          "tag": null,
          "warning": null
        },
        "cards": [
          {
            "iconName": IconPath.serviceCardDesc,
            "type": ServiceCardsTypes.desc,
            "rate": 0,
            "duration": "",
            "fees": -1,
            "feesName": "",
            "feesLink": "",
            "ar": {
              "title": "وصف الخدمة",
              "description":
                  "يمكن من خلال هذه الخدمة إصدار تصريح إعلاني مؤقت، للوحة إعلانية أو مجموعة من اللوحات الإعلانية،  ليتم عرضها على واجهة المحل أو الزجاج الأمامي للمحل، لمدة محددة، كما يمكنك تحديد نوع اللوحة الإعلانية (تخفيضات/منتج جديد/خدمة للمحل)."
            },
            "en": {"title": "Service Description", "description": ""}
          },
          {
            "iconName": IconPath.serviceCardReq,
            "type": ServiceCardsTypes.req,
            "rate": 0,
            "duration": "0",
            "requirements": [
              "تحديد نوع اللوحة الإعلانية (تخفيضات/منتج جديد/خدمة للمحل)",
              "إدخال اسم اللوحة الإعلانية",
              "تحديد أبعاد اللوحة الإعلانية (الطول والعرض)",
              "إرفاق صورة اللوحة الإعلانية",
              "تحديد المدة المطلوبة بالأيام",
              "تحديد تاريخ بداية التصريح "
            ],
            "ar": {"title": "المتطلبات", "description": ""},
            "en": {"title": "Requirements", "description": ""}
          },
          {
            "iconName": IconPath.serviceCardFlow,
            "type": ServiceCardsTypes.flow,
            "rate": 0,
            "duration": "0",
            "flow": [
              {
                "title": "الطريقة الأولى",
                "steps": [
                  "تسجيل الدخول لتطبيق بلدي ",
                  "استعراض قائمة الرخص التجارية",
                  "تحديد الرخصة التجارية وعرض تفاصيلها",
                  "اختيار خدمة تصريح إعلاني مؤقت"
                ],
              },
              {
                "title": "الطريقة الثانية",
                "steps": [
                  "تسجيل الدخول لتطبيق بلدي ",
                  "التوجه للخدمات البلدية",
                  "التوجه لخدمة التصاريح المتعددة",
                  "اختيار خدمة تصريح إعلاني مؤقت"
                ],
              },
            ],
            "ar": {"title": "خطوات التقديم", "description": ""},
            "en": {"title": "", "description": ""}
          },
          {
            "iconName": IconPath.warning2,
            "type": ServiceCardsTypes.conditions,
            "rate": 0,
            "duration": "",
            "fees": null,
            "ar": {
              "title": "الاشتراطات والموافقات الحكومية",
              "description":
                  "1-ترتبط صلاحية التصريح الإعلاني المؤقت بصلاحية الرخصة التجارية.\n\n2-اللوحات الإعلانية المؤقتة على واجهة المحل يجب ألا تتعدا 50% من الواجهة كحد أقصى.\n\n3-أن تكون اللوحة الإعلانية ضمن مساحة العرض على واجهة المحل وتبعد مسافة متر عن الواجهة كحد أقصى.\n\n4-ألا تزيد الفترة الزمنية المسموح فيها للإعلان عن 90 يوماً من تاريخ إصدار التصريح الإعلاني المؤقت.\n\n5-يشترط أن تكون الرخصة التجارية سارية .\n\n6-يشترط إرفاق موافقة وزارة التجارة  في حال كان نوع اللوحة الإعلانية المؤقتة (تخفيضات).",
            },
            "en": {"title": "Service Description", "description": ""}
          },
          {
            "iconName": IconPath.serviceCardDesc,
            "type": ServiceCardsTypes.others,
            "rate": 0,
            "duration": "0",
            "flow": [
              {
                "title": "رسوم الخدمة",
                "steps": [
                  "لكل لوحة إعلانية بالطلب:",
                  "مساحة اللوحة الإعلانية بالمتر المربع * رسوم المتر المربع لليوم الواحد * عدد الأيام المطلوبة بالتصريح",
                  "ملحوظة: تختلف الرسوم من بلدية لبلدية أخرى.",
                ],
              },
              {
                "title": "وقت تنفيذ الخدمة",
                "steps": [
                  "خدمة فورية/غير فورية وفقاً للبلدية التابع لها الرخصة التجارية"
                ],
              },
              {
                "title": "الغرامات والجزاءات",
                "steps": ["لا يوجد غرامات أو جزاءات"],
              },
            ],
            "ar": {"title": "معلومات أخرى", "description": ""},
            "en": {"title": "", "description": ""}
          },
        ]
      },
    );

ServiceModel permitsTobaccoModel() => ServiceModel.fromJson(
      {
        "id": 1,
        "icon": "send_image",
        "3d_icon": null,
        "order": 1,
        "isNew": false,
        "isImportant": false,
        "action": {"type": "cards", "value": ""},
        "ar": {
          "title": "permit_24_service_name".tr(),
          "description": "",
          "tag": null,
          "warning":
              "يمكن إضافة أكثر من لوحة إعلانية بالطلب الواحد.\n\n قد تختلف رسوم الخدمة من بلدية لبلدية أخرى.\n\n يتم حساب الرسوم باليوم.\n\n الخدمة مخصصة للوحات الإعلانية التي يتم عرضها على واجهة المحل أو على الزجاج الخارجي للمحل، أما اللوحات الإعلانية داخل المحل فلا تحتاج لإصدار تصريح."
        },
        "en": {
          "title": 'تصريح تقديم منتجات التبغ',
          "description": "",
          "tag": null,
          "warning": null
        },
        "cards": [
          {
            "iconName": IconPath.serviceCardDesc,
            "type": ServiceCardsTypes.desc,
            "rate": 0,
            "duration": "",
            "fees": -1,
            "feesName": "",
            "feesLink": "",
            "ar": {
              "title": "وصف الخدمة",
              "description":
                  "يمكن من خلال هذه الخدمة إصدار تصريح إعلاني مؤقت، للوحة إعلانية أو مجموعة من اللوحات الإعلانية،  ليتم عرضها على واجهة المحل أو الزجاج الأمامي للمحل، لمدة محددة، كما يمكنك تحديد نوع اللوحة الإعلانية (تخفيضات/منتج جديد/خدمة للمحل)."
            },
            "en": {"title": "Service Description", "description": ""}
          },
          {
            "iconName": IconPath.serviceCardReq,
            "type": ServiceCardsTypes.req,
            "rate": 0,
            "duration": "0",
            "requirements": [
              "تحديد نوع اللوحة الإعلانية (تخفيضات/منتج جديد/خدمة للمحل)",
              "إدخال اسم اللوحة الإعلانية",
              "تحديد أبعاد اللوحة الإعلانية (الطول والعرض)",
              "إرفاق صورة اللوحة الإعلانية",
              "تحديد المدة المطلوبة بالأيام",
              "تحديد تاريخ بداية التصريح "
            ],
            "ar": {"title": "المتطلبات", "description": ""},
            "en": {"title": "Requirements", "description": ""}
          },
          {
            "iconName": IconPath.serviceCardFlow,
            "type": ServiceCardsTypes.flow,
            "rate": 0,
            "duration": "0",
            "flow": [
              {
                "title": "الطريقة الأولى",
                "steps": [
                  "تسجيل الدخول لتطبيق بلدي ",
                  "استعراض قائمة الرخص التجارية",
                  "تحديد الرخصة التجارية وعرض تفاصيلها",
                  "اختيار خدمة تصريح إعلاني مؤقت"
                ],
              },
              {
                "title": "الطريقة الثانية",
                "steps": [
                  "تسجيل الدخول لتطبيق بلدي ",
                  "التوجه للخدمات البلدية",
                  "التوجه لخدمة التصاريح المتعددة",
                  "اختيار خدمة تصريح إعلاني مؤقت"
                ],
              },
            ],
            "ar": {"title": "خطوات التقديم", "description": ""},
            "en": {"title": "", "description": ""}
          },
          {
            "iconName": IconPath.warning2,
            "type": ServiceCardsTypes.conditions,
            "rate": 0,
            "duration": "",
            "fees": null,
            "ar": {
              "title": "الاشتراطات والموافقات الحكومية",
              "description":
                  "1-ترتبط صلاحية التصريح الإعلاني المؤقت بصلاحية الرخصة التجارية.\n\n2-اللوحات الإعلانية المؤقتة على واجهة المحل يجب ألا تتعدا 50% من الواجهة كحد أقصى.\n\n3-أن تكون اللوحة الإعلانية ضمن مساحة العرض على واجهة المحل وتبعد مسافة متر عن الواجهة كحد أقصى.\n\n4-ألا تزيد الفترة الزمنية المسموح فيها للإعلان عن 90 يوماً من تاريخ إصدار التصريح الإعلاني المؤقت.\n\n5-يشترط أن تكون الرخصة التجارية سارية .\n\n6-يشترط إرفاق موافقة وزارة التجارة  في حال كان نوع اللوحة الإعلانية المؤقتة (تخفيضات).",
            },
            "en": {"title": "Service Description", "description": ""}
          },
          {
            "iconName": IconPath.serviceCardDesc,
            "type": ServiceCardsTypes.others,
            "rate": 0,
            "duration": "0",
            "flow": [
              {
                "title": "رسوم الخدمة",
                "steps": [
                  "لكل لوحة إعلانية بالطلب:",
                  "مساحة اللوحة الإعلانية بالمتر المربع * رسوم المتر المربع لليوم الواحد * عدد الأيام المطلوبة بالتصريح",
                  "ملحوظة: تختلف الرسوم من بلدية لبلدية أخرى.",
                ],
              },
              {
                "title": "وقت تنفيذ الخدمة",
                "steps": [
                  "خدمة فورية/غير فورية وفقاً للبلدية التابع لها الرخصة التجارية"
                ],
              },
              {
                "title": "الغرامات والجزاءات",
                "steps": ["لا يوجد غرامات أو جزاءات"],
              },
            ],
            "ar": {"title": "معلومات أخرى", "description": ""},
            "en": {"title": "", "description": ""}
          },
        ]
      },
    );

import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../services/data/models/service_model.dart';

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
          "title": "permit_tobacco_name".tr(),
          "description": "",
          "tag": null,
          "warning": null,
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
                  "إصدار تصريح لتقديم منتجات التبغ على رخصة تجارية سارية للمنشآت المرخصة لبعض الأنشطة التجارية المسموح بها بمزاولة خدمة تقديم منتجات التبغ."
            },
            "en": {"title": "Service Description", "description": ""}
          },
          {
            "iconName": IconPath.serviceCardReq,
            "type": ServiceCardsTypes.req,
            "rate": 0,
            "duration": "0",
            "requirements": [
              "رخصة المحل سارية المفعول",
              "أن يكون النشاط ضمن قائمة الأنشطة المسموح إصدار التصريح لها حيث أن هناك أنشطة محددة يُسمح لها بتقديم منتجات التبغ مثل المطاعم والمقاهي"
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
                "title": "",
                "steps": [
                  "تحديد سجل المنشأة واختيار الرخصة",
                  "استكمال البيانات المطلوبة",
                  "إرسال الطلب إلى البلدية",
                  "دفع الرسوم بعد اعتماد الطلب من البلدية"
                ],
              },
            ],
            "ar": {"title": "خطوات التقديم", "description": ""},
            "en": {"title": "", "description": ""}
          },
          {
            "iconName": IconPath.warning2,
            "type": ServiceCardsTypes.authorInfo,
            "rate": 0,
            "duration": "",
            "fees": null,
            "ar": {
              "title": "الاشتراطات والغرامات",
              "description": "متطلبات واشتراطات الخدمة",
              "descriptionLink": "https://new.balady.gov.sa/ar/node/11352",
              "feesName": "لائحة الجزاءات عن المخالفات البلدية",
              "feesLink":
                  "https://balady.gov.sa/sites/default/files/2023-06/%D8%AC%D8%AF%D9%88%D9%84%20%D8%A7%D9%84%D8%AC%D8%B2%D8%A7%D8%A1%D8%A7%D8%AA%20%D8%B9%D9%86%20%D8%A7%D9%84%D9%85%D8%AE%D8%A7%D9%84%D9%81%D8%A7%D8%AA%20%D8%A7%D9%84%D8%A8%D9%84%D8%AF%D9%8A%D8%A9.pdf",
            },
            "en": {"title": "Service Description", "description": ""}
          }
        ]
      },
    );

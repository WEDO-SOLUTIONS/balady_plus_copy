import 'package:balady_plus/app/features/services/data/models/service_model.dart';

import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/enums/enums.dart';

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
          "title": "permit_24_service_name",
          "description": "",
          "tag": null,
          "warning": null,
        },
        "en": {
          "title": 'permit_24_service_name',
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
              "title": "service_describtion",
              "description": "permit_24_desc"
            },
            "en": {"title": "permit_24_desc", "description": ""}
          },
          {
            "iconName": IconPath.serviceCardReq,
            "type": ServiceCardsTypes.req,
            "rate": 0,
            "duration": "0",
            "requirements": [
              "permit_24_req_1",
            ],
            "ar": {"title": "requirements", "description": ""},
            "en": {"title": "requirements", "description": ""}
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
                  "permit_24_applying_step_1",
                  "permit_24_applying_step_2"
                ],
              },
            ],
            "ar": {"title": "applying_steps", "description": ""},
            "en": {"title": "", "description": ""}
          },
          {
            "iconName": IconPath.warning2,
            "type": ServiceCardsTypes.authorInfo,
            "rate": 0,
            "duration": "",
            "fees": null,
            "ar": {
              "title": "conditions_and_fines",
              "description": "service_conditions_and_fess",
              "descriptionLink": "https://new.balady.gov.sa/ar/node/11356",
              "feesName": "list_municipal_violations",
              "feesLink":
                  "https://balady.gov.sa/sites/default/files/2023-06/%D8%AC%D8%AF%D9%88%D9%84%20%D8%A7%D9%84%D8%AC%D8%B2%D8%A7%D8%A1%D8%A7%D8%AA%20%D8%B9%D9%86%20%D8%A7%D9%84%D9%85%D8%AE%D8%A7%D9%84%D9%81%D8%A7%D8%AA%20%D8%A7%D9%84%D8%A8%D9%84%D8%AF%D9%8A%D8%A9.pdf",
            },
            "en": {"title": "Service Description", "description": ""}
          }
        ]
      },
    );

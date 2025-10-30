import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/enums/enums.dart';
import '../../../../../features/services/data/models/service_model.dart';

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
          "title": 'posters_service_name',
          "description": "",
          "tag": null,
          "warning": "posters_service_warning"
        },
        "en": {
          "title": 'posters_service_name',
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
              "description": "posters_service_desc"
            },
            "en": {"title": "posters_service_desc", "description": ""}
          },
          {
            "iconName": IconPath.serviceCardReq,
            "type": ServiceCardsTypes.req,
            "rate": 0,
            "duration": "0",
            "requirements": [
              "posters_service_req1",
              "posters_service_req2",
              "posters_service_req3",
              "posters_service_req4",
              "posters_service_req5",
              "posters_service_req6"
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
                "title": "first_method",
                "steps": [
                  "posters_service_applying_first_step_1",
                  "posters_service_applying_first_step_2",
                  "posters_service_applying_first_step_3",
                  "posters_service_applying_first_step_4"
                ],
              },
              {
                "title": "second_method",
                "steps": [
                  "posters_service_applying_second_step_1",
                  "posters_service_applying_second_step_2",
                  "posters_service_applying_second_step_3",
                  "posters_service_applying_second_step_4"
                ],
              },
            ],
            "ar": {"title": "applying_steps", "description": ""},
            "en": {"title": "applying_steps", "description": ""}
          },
          {
            "iconName": IconPath.warning2,
            "type": ServiceCardsTypes.conditions,
            "rate": 0,
            "duration": "",
            "fees": null,
            "ar": {
              "title": "governce_conditions",
              "description": "posters_service_governce_desc",
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
                "title": "service_fess",
                "steps": [
                  "posters_service_fee_1",
                  "posters_service_fee_2",
                  "posters_service_fee_3"
                ],
              },
              {
                "title": "service_duration_time",
                "steps": ["posters_service_duration_desc"],
              },
              {
                "title": "fines_penatlies",
                "steps": ["no_fines"],
              },
            ],
            "ar": {"title": "another_info", "description": ""},
            "en": {"title": "", "description": ""}
          },
        ]
      },
    );

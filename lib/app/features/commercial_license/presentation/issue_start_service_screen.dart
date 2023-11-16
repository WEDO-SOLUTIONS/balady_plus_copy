import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';

import 'package:balady_plus/app/core/utils/enums/enums.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';

import 'package:balady_plus/app/features/services/services_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IssueStartService extends StatelessWidget {
  const IssueStartService({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ServiceEntity service = model();

    int? requestId = ModalRoute.of(context)!.settings.arguments as int?;

    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ServiceCardsCubit(service),
          ),
        ],
        child: Scaffold(
          appBar: DefaultAppBarWidget(
            title: service.title,
            bottom: ServiceCardsList(
              cards: service.cards,
            ),
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  const Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 16),
                        ServiceCardDescription(),
                      ],
                    ),
                  ),
                  SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButtonWidget.startService(
                        onPressed: () async {
                          Navigator.of(context).pushNamed(
                              RouteName.commercialLicensePage,
                              arguments: requestId);
                        },
                      ),
                    ),
                  )
                  /* SafeArea(
                    top: false,
                    child: ServiceWarningWidget(
                      warning: service.warning ?? "",
                      onPress: () async {
                        Navigator.of(context).pushNamed(
                            RouteName.commercialLicensePage,
                            arguments: requestId);
                      },
                    ),
                  )*/
                ],
              ),
            ],
          ),
        ));
  }

  ServiceModel model() => ServiceModel.fromJson(
        {
          "id": 1,
          "icon": "send_image",
          "3d_icon": null,
          "order": 1,
          "isNew": false,
          "isImportant": false,
          "action": {"type": "cards", "value": ""},
          "ar": {
            "title": "إصدار رخصة تجارية",
            "description": "",
            "tag": null,
            "warning": null
          },
          "en": {
            "title": "إصدار رخصة تجارية",
            "description": "",
            "tag": null,
            "warning": null
          },
          "cards": [
            {
              "iconName": IconPath.serviceCardDesc,
              "type": ServiceCardsTypes.desc,
              "rate": 0,
              "duration": "1 - 10 أيام",
              "fees": -1,
              "feesName": "حاسبة الرسوم المعلوماتية",
              "feesLink": "https://apps.balady.gov.sa/Eservices/FeesCalculator",
              "ar": {
                "title": "وصف الخدمة",
                "description":
                    "من خلال هذه الخدمة يمكنك البدء بممارسة العمل التجاري من خلال إصدار رخصة نشاط تجاري بالإضافة إلى تصريح السلامة الصادر من المديرية العامة للدفاع المدني لجميع الأنشطة التجارية المعتمدة لدى وزارة الشؤون البلدية والقروية والإسكان."
              },
              "en": {"title": "Service Description", "description": ""}
            },
            {
              "iconName": IconPath.serviceCardReq,
              "type": ServiceCardsTypes.req,
              "rate": 0,
              "duration": "0",
              "requirements": [
                "صورة خارجية للمحل ويتم إبراز لوحة المحل.",
                "عقد الإيجار أو صك الملكية أو عقد الاستثمار للموقع من البلدية أو الجهات الحكومية الأخرى.",
                "عقد النظافة (اختياري حسب التعاقد ونوع النشاط).",
                "فاتورة أدوات السلامة أو تقرير سلامة من الدفاع المدني للأنشطة الفورية.",
                "صورة من رخصة البناء."
              ],
              "ar": {"title": "المتطلبات", "description": ""},
              "en": {"title": "Requirements", "description": ""}
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
                "descriptionLink": "https://new.balady.gov.sa/ar/node/10856",
                "feesName": "لائحة الجزاءات عن المخالفات البلدية",
                "feesLink":
                    "https://balady.gov.sa/sites/default/files/2023-06/%D8%AC%D8%AF%D9%88%D9%84%20%D8%A7%D9%84%D8%AC%D8%B2%D8%A7%D8%A1%D8%A7%D8%AA%20%D8%B9%D9%86%20%D8%A7%D9%84%D9%85%D8%AE%D8%A7%D9%84%D9%81%D8%A7%D8%AA%20%D8%A7%D9%84%D8%A8%D9%84%D8%AF%D9%8A%D8%A9.pdf",
              },
              "en": {"title": "Service Description", "description": ""}
            },
          ]
        },
      );
}

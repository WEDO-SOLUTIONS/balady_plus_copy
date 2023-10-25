import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';

import 'package:balady_plus/app/core/utils/enums/enums.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';

import 'package:balady_plus/app/features/services/services_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../blocs/renew_start_service_bloc/renew_commercial_license_bloc.dart';

class RenewStartService extends StatelessWidget {
  const RenewStartService({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ServiceEntity service = model();

    int licenseId = ModalRoute.of(context)!.settings.arguments as int;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) =>
              RenewStartServiceBloc(licenseId: licenseId),
        ),
        BlocProvider(
          create: (context) => ServiceCardsCubit(service),
        ),
      ],
      child: BlocConsumer<RenewStartServiceBloc, RenewStartServiceState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
          }
        },
        builder: (context, state) {
          return Scaffold(
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
                      child: ServiceWarningWidget(
                        warning: service.warning ?? "",
                        onPress: () async {
                          context
                              .read<RenewStartServiceBloc>()
                              .add(const ValidateBeforeApplyEvent());
                        },
                      ),
                    )
                  ],
                ),
                if (state.status == BlocStatus.loading)
                  const CustomCircularLoadingWidget()
              ],
            ),
          );
        },
      ),
    );
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
            "title": "الغاء رخصة تجارية",
            "description": "",
            "tag": null,
            "warning": "يجب أن يتم إلغاء رخصة النشاط التجاري قبل شطب السجل التجاري."
                "\n\n"
                "سوف يتم إلغاء الرخصة بشكل آلــي بعد مرور سنة وأكثر من انتهاء الرخصة.\n\n"
                "تأخرك في إلغاء الرخصة يعرضك لدفع رسوم تجديد عند الإلغاء وذلك وفقًــا للائحة التنفيذية لإجراءات التراخيص البلدية 1438 هـ.\n\n"
                "يمكنك الاطلاع على حاسبة الرسوم المعلوماتية من خلال الرابط.\n"
                "https://apps.balady.gov.sa//Eservices/FeesCalculator\n\n"
                "رسوم الإلغاء 20 ريال مع ضرورة أن تكون الرخصة سارية.\n"
          },
          "en": {
            "title": "الغاء رخصة تجارية",
            "description": "",
            "tag": null,
            "warning": "يجب أن يتم إلغاء رخصة النشاط التجاري قبل شطب السجل التجاري.\n"
                "سوف يتم إلغاء الرخصة بشكل آلــي بعد مرور سنة وأكثر من انتهاء الرخصة.\n"
                "تأخرك في إلغاء الرخصة يعرضك لدفع رسوم تجديد عند الإلغاء وذلك وفقًــا للائحة التنفيذية لإجراءات التراخيص البلدية 1438 هـ.\n"
                "يمكنك الاطلاع على حاسبة الرسوم المعلوماتية من خلال الرابط.\n"
                "https://apps.balady.gov.sa//Eservices/FeesCalculator\n"
                "رسوم الإلغاء 20 ريال مع ضرورة أن تكون الرخصة سارية.\n"
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
                    "في مرحلة إنهاء ممارسة العمل التجاري يتوجب على المستفيد إلغاء رخصته التجارية المرتبطة بالمنشأة، ومن خلال هذه الخدمة يمكنك إلغاء الرخصة."
              },
              "en": {"title": "Service Description", "description": ""}
            },
            {
              "iconName": IconPath.serviceCardReq,
              "type": ServiceCardsTypes.req,
              "rate": 0,
              "duration": "0",
              "requirements": [
                "في حالة أن الإلغاء غير فوري، يتم طلب مرفقات لإثبات إغلاق النشاط.",
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
                  "title": "من خلال المستفيد بنفسه (بدون مكتب هندسي)",
                  "steps": [
                    "تحديد سجل المنشأة واختيار الرخصة.",
                    "استكمال البيانات المطلوبة إن وجدت.",
                    "دفع الرسوم في حال الإلغاء الفوري أو إرسال الطلب للبلدية في حال أن الإلغاء غير فوري.",
                    "إصدار شهادة امتثال المباني للمبنى.",
                  ]
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
              "ar": {"title": "الغرامات والجزاءات", "description": "اضغط هنا"},
              "en": {"title": "Service Description", "description": ""}
            },
          ]
        },
      );
}

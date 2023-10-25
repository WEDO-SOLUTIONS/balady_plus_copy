import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/core/utils/enums/enums.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/commercial_license_cancel/data/models/cancellation_rquest_response.dart';
import 'package:balady_plus/app/features/commercial_license_cancel/presentation/apply_cancel/mvvm/apply_cancel_view_model.dart';
import 'package:balady_plus/app/features/commercial_license_cancel/presentation/commercial_license_cancel/blocs/commercial_license_cancel/commercial_license_cancel_bloc.dart';
import 'package:balady_plus/app/features/services/services_exports.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class ApplyCancelScreen extends StatelessWidget {
  const ApplyCancelScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ApplyCancelViewModel viewModel =
        ModalRoute.of(context)!.settings.arguments as ApplyCancelViewModel;
    ServiceEntity service = ServiceModel.fromJson(
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
          "warning":
          "يجب أن يتم إلغاء رخصة النشاط التجاري قبل شطب السجل التجاري."
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
          "warning":
              "يجب أن يتم إلغاء رخصة النشاط التجاري قبل شطب السجل التجاري.\n"
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
            "feesLink":"https://apps.balady.gov.sa/Eservices/FeesCalculator",
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
            "ar": {
              "title": "الغرامات والجزاءات",
              "description": "اضغط هنا"
            },
            "en": {"title": "Service Description", "description": ""}
          },
        ]
      },
    );

    return ChangeNotifierProvider(
      create: (BuildContext context) => viewModel,
      child: BlocProvider(
        create: (context) => ServiceCardsCubit(service),
        child: Scaffold(
          appBar: DefaultAppBarWidget(
            title: service.title,
            // actions: [
            //   Padding(
            //     padding: const EdgeInsetsDirectional.only(end: 10),
            //     child: InkWell(
            //       onTap: () async {
            //         try {
            //           sl<DelegatorsCubit>().getDelegators();
            //           await BottomSheetDialog.showDraggableSheet(
            //             context,
            //             dialogKeyName: DialogName.delegatorsDialog,
            //             currentRouteName: RouteName.createCompliancePage,
            //             child: DelegatorList(
            //               fromService: true,
            //               delegatorsCubit: sl<DelegatorsCubit>(),
            //             ),
            //           );
            //         } catch (ex) {
            //           print(ex);
            //         }
            //       },
            //       child: CircleIcon(
            //         icon: IconPath.switchProfileIcon,
            //         iconColor: AppColor.primary600Light,
            //         backgroundColor: AppColor.geyser.withOpacity(0.4),
            //         iconSize: 18,
            //       ),
            //     ),
            //   ),
            // ],
            bottom: ServiceCardsList(
              cards: service.cards,
            ),
          ),
          body: Column(
            children: [
              const Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 16),
                      ServiceCardDescription(),
                    ],
                  ),
                ),
              ),


              SafeArea(
                top: false,
                child: Selector<ApplyCancelViewModel, bool>(
                  selector: (context, provider) => provider.isLoading,
                  builder: (BuildContext context, isLoading, Widget? child) {
                    return isLoading
                        ? const ShimmerEffectWidget(
                      height: 55,
                      borderRadius: 6,
                    )
                        : child!;
                  },
                  child: ServiceWarningWidget(
                    warning: service.warning ?? "",
                    onPress: () async {
                      try {
                        NavigatorState navigator = Navigator.of(context);
                        CancellationRequestResponse? cancellationRequest =
                        await viewModel
                            .applyCommercialLicenseCancellation();
                        if (cancellationRequest != null) {
                          navigator.popAndPushNamed(
                            RouteName.commercialLicenseCancel,
                            arguments: CommercialLicenseCancelBloc(
                              webService: sl(),
                              requestId: cancellationRequest.requestId,
                              availableCloseDate: cancellationRequest.availableCloseDate,
                              crNumber: viewModel.submitterInfo.crNumber,
                              crType: viewModel.submitterInfo.crType!,
                              reasonCancel: viewModel.reasonCancel,
                            ),
                          );
                        }
                      } on DioError catch (error) {
                        CommonFunctions.showError(error.toString());
                      } catch (e) {
                        CommonFunctions.showError(e.toString());
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

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
          "warning": ""
        },
        "en": {
          "title": "الغاء رخصة تجارية",
          "description": "",
          "tag": null,
          "warning":
              ". Please renew the license before it expires or cancel it if you do not want to renew it in order to avoid the required delay penalty fees.\n. The license can be renewed 90 days before its expiry date."
        },
        "cards": [
          {
            "iconName": IconPath.serviceCardDesc,
            "type": ServiceCardsTypes.desc,
            "rate": 0,
            "duration": 0,
            "fees": 0,
            "ar": {
              "title": "وصف الخدمة",
              "description":
                  "هي خدمة يتم من خلالها إصدار شهادة امتثال للمبنى تفيد بالتزام المبنى بمجموعة من الاشتراطات التي أقرتها وزارة الشؤون البلدية والقروية والإسكان وذلك للحد من مظاهر التشوه البصري في المباني التجارية والسكنية والارتقاء بجودة المشهد الحضري في المدن"
            },
            "en": {"title": "Service Description", "description": ""}
          },
          {
            "iconName": IconPath.serviceCardReq,
            "type": ServiceCardsTypes.req,
            "rate": 0,
            "duration": 0,
            "requirements": [
              "يجب أن يكون مقدم الطلب هو المالك للمبنى أو مفوض من مالك المبنى بتفويض إليكتروني ساري وصادر من بلدي.",
              "يجب أن يكون لدى مقدم الطلب رخصة إنشائية أو صك ملكية."
            ],
            "ar": {"title": "المتطلبات", "description": ""},
            "en": {"title": "Requirements", "description": ""}
          },
          {
            "iconName": IconPath.serviceCardFlow,
            "type": ServiceCardsTypes.flow,
            "rate": 0,
            "duration": 0,
            "flow": [
              {
                "title": "من خلال المستفيد بنفسه (بدون مكتب هندسي)",
                "steps": [
                  "تسجيل الدخول عبر تطبيق بلدي.",
                  "الدخول على خدمة إصدار شهادة امتثال المباني.",
                  "إدخال بيانات رخصة البناء أو الوثيقة الملكية للمبنى واستكمال كافة البيانات المطلوبة في نموذج طلب إصدار شهادة الامتثال.",
                  "الإقرار في الطلب باستيفاء عناصر التقييم الخاصة بإصدار شهادة امتثال المباني الواردة في هذا الدليل",
                  "قيام البلدية بجدولة زيارة للتحقق من البيانات المدخلة",
                  "موافقة الأمانة/البلدية على الطلب.",
                  "إصدار شهادة امتثال المباني للمبنى.",
                ]
              },
              {
                "title": "من خلال المكتب الهندسي المؤهل",
                "steps": [
                  "تسجيل الدخول عبر تطبيق بلدي والدخول على الخدمة.",
                  "تفويض مكتب هندسي مؤهل لاستكمال إجراءات إصدار شهادة امتثال المباني.",
                  "قيام المكتب الهندسي المؤهل باستكمال كافة البيانات المطلوبة في نموذج طلب إصدار شهادة الامتثال.",
                  "قيام المكتب الهندسي المؤهل بالتحقق من استيفاء المبنى لجميع اشتراطات ومتطلبات شهادة امتثال المباني.",
                  "الإقرار باستيفاء جميع اشتراطات ومتطلبات إصدار شهادة امتثال المباني الواردة في هذا الدليل.",
                  "يقوم المكتب الهندسي المؤهل باستكمال إجراءات إصدار الشهادة وفق الاجراءات المتبعة في الأمانة/البلدية.",
                  "إصدار شهادة امتثال المباني من قبل الأمانة/البلدية من خلال المكتب الهندسي المؤهل."
                ]
              }
            ],
            "ar": {"title": "خطوات التقديم", "description": ""},
            "en": {"title": "", "description": ""}
          }
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
                    child: ElevatedButtonWidget.startService(
                      onPressed: () async {
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
                                cancellationRequestResponse: cancellationRequest,
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

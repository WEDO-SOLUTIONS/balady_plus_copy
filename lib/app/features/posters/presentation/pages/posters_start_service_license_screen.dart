import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';

import 'package:balady_plus/app/core/utils/enums/enums.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';

import 'package:balady_plus/app/features/services/services_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/constants/dialog_names.dart';
import '../../../_shared_feature_/presentation/dialogs/need_login_dialog.dart';
import '../../../_shared_feature_/presentation/dialogs/not_authorized_indivivisual.dart';
import '../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../commercial_license_details/data/models/commercial_licence_details.dart';
import '../../data/models/permit_license_response_model.dart';
import '../blocs/posters_license_bloc.dart';

class PostersLicenseStartService extends StatefulWidget {
  const PostersLicenseStartService({Key? key}) : super(key: key);

  @override
  State<PostersLicenseStartService> createState() =>
      _PostersLicenseStartServiceState();
}

class _PostersLicenseStartServiceState
    extends State<PostersLicenseStartService> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // CommonFunctions.sendEventToAnalytics(AppEvents.renewCommercialLicenseOpen);
  }

  @override
  Widget build(BuildContext context) {
    ServiceEntity service = model();
    CommercialLicenceDetails? commercialLicenceDetails =
        ModalRoute.of(context)!.settings.arguments as CommercialLicenceDetails;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ServiceCardsCubit(service),
        ),
        BlocProvider(
          create: (context) => PostersLicenseBloc(
              groupId: 1042,
              licenseId: commercialLicenceDetails.licenseInfo?.licenseId,
              selectedLicense: PermitsLicensesItem(
                  licenseId: commercialLicenceDetails.licenseInfo?.licenseId,
                  statusName: commercialLicenceDetails.licenseInfo?.statusDesc,
                  licenseExpirationDate:
                      commercialLicenceDetails.licenseInfo?.licenseEndDate,
                  municipalityName:
                      commercialLicenceDetails.locationInfo?.municipalityName,
                  subMunicipalityName: commercialLicenceDetails
                      .locationInfo?.subMunicipalityName)),
        ),
      ],
      child: BlocConsumer<PostersLicenseBloc, PostersLicenseState>(
          listener: (context, state) {
        if (state.status == BlocStatus.failure) {
          CommonFunctions.showError(state.error ?? "");
        }
      }, builder: (context, state) {
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
                  /*  SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButtonWidget.startService(
                        onPressed: () async {
                         
                        },
                      ),
                    ),
                  )*/
                  SafeArea(
                    top: false,
                    child: ServiceWarningWidget(
                      warning: service.warning ?? "",
                      onPress: () async {
                        if (CommonProperties.isLoggedIn) {
                          // if (CommonProperties.selectedDelegator != null) {
                          context
                              .read<PostersLicenseBloc>()
                              .add(ApplyLicenseEvent());
                          /* } else {
                              await BottomSheetDialog.showDraggableSheet(
                                context,
                                isFullHeight: false,
                                dialogKeyName:
                                    DialogName.notAuthorizedIndivisualDialog,
                                currentRouteName: RouteName.postersStartService,
                                child: NotAuthorizedIndivisualDialog(),
                              );
                            }*/
                        } else {
                          showDialog(
                              context: context,
                              builder: (ctx) => NeedLoginDialog(
                                      onSuccessLogin: (bool? isSuccess) async {
                                    if (isSuccess ?? false) {
                                      /* if (CommonProperties
                                                .selectedDelegator !=
                                            null) {*/
                                      context
                                          .read<PostersLicenseBloc>()
                                          .add(ApplyLicenseEvent());
                                      /* } else {
                                          await BottomSheetDialog
                                              .showDraggableSheet(
                                            context,
                                            isFullHeight: false,
                                            dialogKeyName: DialogName
                                                .notAuthorizedIndivisualDialog,
                                            currentRouteName:
                                                RouteName.postersStartService,
                                            child:
                                                NotAuthorizedIndivisualDialog(),
                                          );
                                        }*/
                                    }
                                  }));
                        }
                      },
                    ),
                  )
                ],
              ),
              if (state.status == BlocStatus.loading)
                CustomCircularLoadingWidget(),
            ],
          ),
        );
      }),
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
            "title": 'تصريح إعلاني مؤقت',
            "description": "",
            "tag": null,
            "warning":
                "يمكن إضافة أكثر من لوحة إعلانية بالطلب الواحد.\n قد تختلف رسوم الخدمة من بلدية لبلدية أخرى.\n يتم حساب الرسوم باليوم.\n الخدمة مخصصة للوحات الإعلانية التي يتم عرضها على واجهة المحل أو على الزجاج الخارجي للمحل، أما اللوحات الإعلانية داخل المحل فلا تحتاج لإصدار تصريح."
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
              "ar": {"title": "خطوات التقديم", "description": ""},
              "en": {"title": "", "description": ""}
            },
          ]
        },
      );
}

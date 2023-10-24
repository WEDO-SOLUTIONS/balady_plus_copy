/*import 'package:balady_plus/app/app.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/create_compliance_location_widgets/create_compliance_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CreateComplianceLocationPage extends StatelessWidget {
  const CreateComplianceLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CreateComplianceLocationWidget(),
    );
  }
}*/

import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/features/profile_features/delegators/delegators_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/dialog_names.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../_shared_feature_/presentation/dialogs/need_login_dialog.dart';
import '../../../_shared_feature_/shared_feature_exports.dart'
    show BottomSheetDialog, DefaultAppBarWidget, ElevatedButtonWidget;
import '../../../home_page/presentation/widgets/home_app_bar/circle_icon.dart';
import '../../../services/data/models/service_model.dart';
import '../../../services/domain/entities/service_entity.dart';
import '../../../services/presentation/cubit/service_cards_cubit/service_cards_cubit.dart';
import '../../../services/presentation/widgets/service_card_description.dart';
import '../../../services/presentation/widgets/service_cards_list.dart';
import '../../../services/presentation/widgets/service_warning_widget.dart';
import '../widgets/create_compliance_location_widgets/create_compliance_widget.dart';

class CreateComplianceLocationPage extends StatefulWidget {
  const CreateComplianceLocationPage({
    super.key,
  });

  @override
  State<CreateComplianceLocationPage> createState() => _ServiceCardsPageState();
}

class _ServiceCardsPageState extends State<CreateComplianceLocationPage> {
  @override
  Widget build(BuildContext context) {
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
          "title": "إصدار شهادة امتثال المباني",
          "description": "",
          "tag": null,
          "warning": ""
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
            "iconName": IconPath.serviceCardDesc,
            "type": ServiceCardsTypes.desc,
            "rate": 0,
            "duration": "0",
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
            "duration": "0",
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
            "duration": "0",
            "flow": [
              {
                "title": "من خلال المستفيد بنفسه (بدون مكتب هندسي)",
                "steps": [
                  "تسجيل الدخول عبر تطبيق بلدي.",
                  "الدخول على خدمة إصدار شهادة امتثال المباني.",
                  "إدخال بيانات رخصة البناء أو وثيقة مستند التقديم للمبنى واستكمال كافة البيانات المطلوبة في نموذج طلب إصدار شهادة الامتثال.",
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

    return BlocProvider(
      create: (context) => ServiceCardsCubit(service),
      child: Scaffold(
        appBar: DefaultAppBarWidget(
          title: service.title,
          actions: [
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 10),
              child: InkWell(
                onTap: () async {
                  try {
                    sl<DelegatorsCubit>().getDelegators();
                    await BottomSheetDialog.showDraggableSheet(
                      context,
                      dialogKeyName: DialogName.delegatorsDialog,
                      currentRouteName: RouteName.createCompliancePage,
                      child: DelegatorList(
                        fromService: true,
                        delegatorsCubit: sl<DelegatorsCubit>(),
                      ),
                    );
                  } catch (ex) {
                    print(ex);
                  }
                },
                child: CircleIcon(
                  icon: IconPath.switchProfileIcon,
                  iconColor: AppColor.primary600Light,
                  backgroundColor: AppColor.geyser.withOpacity(0.4),
                  iconSize: 18,
                ),
              ),
            ),
          ],
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
            /* if (service.warning != null)
              ServiceWarningWidget(
                warning: service.warning ?? "",
                onPress: () {
                  BottomSheetDialog.showDraggableSheet(context,
                      // dialogKeyName: DialogName.dcVeichlesDialog,
                      // currentRouteName: RouteName.DCVeichlePage,

                      isFullHeight: false,
                      child: CreateComplianceLocationWidget());
                },
              )
            else*/
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButtonWidget.startService(
                  onPressed: () async {
                    bool isLocationAvailable =
                        await CommonFunctions.checkLocationSettings(context);

                    if (isLocationAvailable) {
                      if (CommonProperties.isLoggedIn) {
                        BottomSheetDialog.showDraggableSheet(context,
                            dialogKeyName:
                                DialogName.complianceConfirmLocationDialog,
                            currentRouteName: RouteName.createCompliancePage,
                            isFullHeight: false,
                            child: CreateComplianceLocationWidget());
                      } else {
                        showDialog(
                            context: context,
                            builder: (ctx) => NeedLoginDialog(
                                    onSuccessLogin: (bool? isSuccess) async {
                                  if (isSuccess ?? false) {
                                    BottomSheetDialog.showDraggableSheet(
                                        context,
                                        dialogKeyName: DialogName
                                            .complianceConfirmLocationDialog,
                                        currentRouteName:
                                            RouteName.createCompliancePage,
                                        isFullHeight: false,
                                        child:
                                            CreateComplianceLocationWidget());
                                  }
                                }));
                      }
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

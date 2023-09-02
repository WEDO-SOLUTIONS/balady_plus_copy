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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../_shared_feature_/shared_feature_exports.dart'
    show BottomSheetDialog, DefaultAppBarWidget, ElevatedButtonWidget;
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
          "description":
              "حسّن المشهد الحضري في مدينتك، وبلّغ عن مظاهر التشوه البصري",
          "tag": null,
          "warning":
              ". يرجى الالتزام بتجديد الرخصة قبل انتهائها أو إلغائها في حالة عدم الرغبة في تجديدها وذلك لتجنب رسوم غرامة المشترطة على التأخير في التجديد.\n. يمكن تجديد الرخصة قبل 90 يوم من تاريخ انتهائها."
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
            "iconName": "service_description",
            "rate": 5.4,
            "duration": 5,
            "ar": {
              "title": "وصف الخدمه",
              "description":
                  "من خلال هذه الخدمة يمكنك البدء بممارسة العمل التجاري من خلال إصدار رخصة نشاط تجاري  بالإضافة إلى تصريح السلامة الصادر من المديرية العامة للدفاع المدني لجميع الأنشطة التجارية المعتمدة لدى وزارة الشؤون البلدية والقروية والإسكان."
            },
            "en": {
              "title": "Service Description",
              "description":
                  "Through this service, you can start practicing business by issuing a commercial activity license in addition to the safety permit issued by the General Directorate of Civil Defense for all commercial activities approved by the Ministry of Municipal and Rural Affairs and Housing."
            }
          },
          {
            "iconName": "requirements",
            "rate": 5.4,
            "duration": 5,
            "ar": {
              "title": "المتطلبات",
              "description":
                  "من خلال هذه الخدمة يمكنك البدء بممارسة العمل التجاري من خلال إصدار رخصة نشاط تجاري  بالإضافة إلى تصريح السلامة الصادر من المديرية العامة للدفاع المدني لجميع الأنشطة التجارية المعتمدة لدى وزارة الشؤون البلدية والقروية والإسكان."
            },
            "en": {
              "title": "Requirements",
              "description":
                  "Through this service, you can start practicing business by issuing a commercial activity license in addition to the safety permit issued by the General Directorate of Civil Defense for all commercial activities approved by the Ministry of Municipal and Rural Affairs and Housing."
            }
          }
        ]
      },
    );

    return BlocProvider(
      create: (context) => ServiceCardsCubit(service),
      child: Scaffold(
        appBar: DefaultAppBarWidget(
          title: service.title,
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
            if (service.warning != null)
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
            else
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButtonWidget.startService(
                    onPressed: () {
                      print("HEREE");
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

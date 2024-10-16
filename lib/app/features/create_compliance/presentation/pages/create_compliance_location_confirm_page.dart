import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/constants/remote_config.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:balady_plus/app/features/profile_features/delegators/delegators_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/dialog_names.dart';
import '../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../_shared_feature_/presentation/dialogs/need_login_dialog.dart';
import '../../../_shared_feature_/shared_feature_exports.dart'
    show BottomSheetDialog, DefaultAppBarWidget, ElevatedButtonWidget;
import '../../../home_page/presentation/widgets/home_app_bar/circle_icon.dart';
import '../../../services/data/models/service_model.dart';
import '../../../services/domain/entities/service_entity.dart';
import '../../../services/presentation/cubit/service_cards_cubit/service_cards_cubit.dart';
import '../../../services/presentation/mvvm/service_data_view_model.dart';
import '../../../services/presentation/widgets/service_card_description.dart';
import '../../../services/presentation/widgets/service_cards_dynamic/service_card_desc_widget.dart';
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
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonFunctions.sendUXCamEvent(
        UXCamEvents.startCardServiceComplianceCertificate);

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.Compliance_Certificate_Open_Service_Card_Event);
  }

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [

        ChangeNotifierProvider(
          create: (BuildContext context) => ServiceDataViewModel(
            webService: sl(),
            serviceId: RemoteConfig.MunicipalServicesIDs["create_complianceLocation"]["id"],
          ),
        ),
      ],
      child: Scaffold(
        body: Column(
          children: [
            const Expanded(child: ServiceCardDescDynamicWidget(showDelagator: true,openFromCompliance: true,)),
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(36),
                    topRight: Radius.circular(36),
                  ),
                  color: Colors.white),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 26),
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
            )
          ],
        ),
      ),
    );



  }
}


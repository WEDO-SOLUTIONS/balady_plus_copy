import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/constants/dialog_names.dart';
import 'package:balady_plus/app/core/utils/constants/remote_config.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/services/presentation/mvvm/service_data_view_model.dart';
import 'package:balady_plus/app/features/services/presentation/widgets/service_cards_dynamic/service_card_desc_widget.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';

import '../../../../../features/_shared_feature_/presentation/dialogs/not_authorized_indivivisual.dart';
import '../blocs/posters_license_bloc.dart';

import 'package:balady_plus/app/commercial_model/commercial_routes/commercial_route_names.dart';

class PostersStartService extends StatefulWidget {
  const PostersStartService({Key? key}) : super(key: key);

  @override
  State<PostersStartService> createState() => _PostersStartServiceState();
}

class _PostersStartServiceState extends State<PostersStartService> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.startCardServiceMultiplePostersPermit);

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.Posters_Open_Service_Card_For_Multiple_Event);
  }

  @override
  Widget build(BuildContext context) {

    PostersLicenseBloc? bloc =
        ModalRoute.of(context)!.settings.arguments as PostersLicenseBloc?;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => ServiceDataViewModel(
            webService: sl(),
            serviceId: RemoteConfig.MunicipalServicesIDs["PostersLicenseService"]["id"],
          ),
        ),
      ],
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                const Expanded(child: ServiceCardDescDynamicWidget()),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButtonWidget.startService(
                      onPressed: () async {
                        if (CommonProperties.selectedDelegator != null) {
                          Navigator.of(context).pushNamed(
                              CommercialRouteName.postersDetailsPage,
                              arguments: bloc);
                        } else {
                          await BottomSheetDialog.showDraggableSheet(
                            context,
                            isFullHeight: false,
                            dialogKeyName:
                                DialogName.notAuthorizedIndivisualDialog,
                            currentRouteName:
                                CommercialRouteName.postersStartService,
                            child: NotAuthorizedIndivisualDialog(),
                          );
                        }
                      },
                    ),
                  ),
                )
                /*SafeArea(
                      top: false,
                      child: ServiceWarningWidget(
                        warning: service.warning ?? "",
                        onPress: () async {
                          context
                              .read<PostersStartServiceBloc>()
                              .add(const ValidateBeforeApplyEvent());
                        },
                      ),
                    )*/
              ],
            ),
          ],
        ),
      ),
    );
  }
}


import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/constants/remote_config.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/services/presentation/mvvm/service_data_view_model.dart';
import 'package:balady_plus/app/features/services/presentation/widgets/service_cards_dynamic/service_card_desc_widget.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../../../features/services/services_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../data/models/permit_license_response_model.dart';
import '../../data/models/service_card.dart';
import '../blocs/posters_license_bloc.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/data/models/commercial_licence_details.dart';

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

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.startCardServiceIndivisualPostersPermit);

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.Posters_Open_Service_Card_For_License_Event);
  }

  @override
  Widget build(BuildContext context) {
    ServiceEntity service = postersModel();
    CommercialLicenceDetails? commercialLicenceDetails =
        ModalRoute.of(context)!.settings.arguments as CommercialLicenceDetails;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => ServiceDataViewModel(
            webService: sl(),
            serviceId: RemoteConfig.MunicipalServicesIDs["PostersLicenseService"]["id"],
            // serviceId: 11820, // this not corect id
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
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
            body: Stack(
              children: [
                Column(
                  children: [
                    const Expanded(child: ServiceCardDescDynamicWidget()),
                    SafeArea(
                      top: false,
                      child: ServiceWarningWidget(
                        warning: service.warning?.tr() ?? "",
                        onPress: () async {
                            // if (CommonProperties.selectedDelegator != null) {
                            context.read<PostersLicenseBloc>().add(ApplyLicenseEvent());
                            /* } else {
                                await BottomSheetDialog.showDraggableSheet(
                                  context,
                                  isFullHeight: false,
                                  dialogKeyName:
                                      DialogName.notAuthorizedIndivisualDialog,
                                  currentRouteName: CommercialRouteName.postersStartService,
                                  child: NotAuthorizedIndivisualDialog(),
                                );
                              }*/
                        },
                      ),
                    )
                  ],
                ),
                if (state.status == BlocStatus.loading)
                  const CustomCircularLoadingWidget(),
              ],
            ),
          );
        }),
      ),
    );
  }
}

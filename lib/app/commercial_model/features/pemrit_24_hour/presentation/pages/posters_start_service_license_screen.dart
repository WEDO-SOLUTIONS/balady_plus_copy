import 'package:balady_plus/app/core/utils/constants/remote_config.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/services/presentation/widgets/service_cards_dynamic/service_card_desc_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import '../../../../../features/_shared_feature_/presentation/dialogs/need_login_dialog.dart';
import '../../../../../features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../commercial_license_details/data/models/commercial_licence_details.dart';
import 'package:balady_plus/app/features/services/presentation/mvvm/service_data_view_model.dart';
import '../blocs/permit_24_bloc.dart';

class PermitsLicenseStartService extends StatefulWidget {
  const PermitsLicenseStartService({Key? key}) : super(key: key);

  @override
  State<PermitsLicenseStartService> createState() =>
      _PermitsLicenseStartServiceState();
}

class _PermitsLicenseStartServiceState
    extends State<PermitsLicenseStartService> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    CommonFunctions.sendUXCamEvent(UXCamEvents.detailsService24HourPermit);

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.Permit_24_Open_Service_Card_Event);
  }

  @override
  Widget build(BuildContext context) {
    //ServiceEntity service = permits24Model();
    CommercialLicenceDetails? commercialLicenceDetails =
        ModalRoute.of(context)!.settings.arguments as CommercialLicenceDetails;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => Permit24LicenseBloc(
              licenseId: commercialLicenceDetails.licenseInfo?.licenseId,
              commercialLicenceDetails: commercialLicenceDetails),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => ServiceDataViewModel(
            webService: sl(),
            serviceId: RemoteConfig.MunicipalServicesIDs["PermitsLicenseService24H"]["id"],
          ),
        ),
      ],
      child: BlocConsumer<Permit24LicenseBloc, Permit24LicenseState>(
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
                  Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(36),
                          topRight: Radius.circular(36),
                        ),
                        color: Colors.white),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 26),
                    child: ElevatedButtonWidget.startService(
                      onPressed: () async {
                        if (CommonProperties.isLoggedInMunicipality) {
                          context
                              .read<Permit24LicenseBloc>()
                              .add(const ValidatePermitEvent());
                        } else {
                          showDialog(
                              context: context,
                              builder: (ctx) => NeedLoginDialog(
                                      onSuccessLogin: (bool? isSuccess) async {
                                    if (isSuccess ?? false) {
                                      context
                                          .read<Permit24LicenseBloc>()
                                          .add(const ValidatePermitEvent());
                                    }
                                  }));
                        }
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
    );
  }
}

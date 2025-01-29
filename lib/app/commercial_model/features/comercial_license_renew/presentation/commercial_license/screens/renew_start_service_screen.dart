import 'package:balady_plus/app/core/utils/constants/remote_config.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/app_analytics_events.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import 'package:balady_plus/app/features/services/presentation/mvvm/service_data_view_model.dart';
import 'package:balady_plus/app/features/services/presentation/widgets/service_cards_dynamic/service_card_desc_widget.dart';
import '../blocs/renew_start_service_bloc/renew_commercial_license_bloc.dart';

class RenewStartService extends StatefulWidget {
  const RenewStartService({Key? key}) : super(key: key);

  @override
  State<RenewStartService> createState() => _RenewStartServiceState();
}

class _RenewStartServiceState extends State<RenewStartService> {
  @override
  void initState() {
    super.initState();
    CommonFunctions.sendEventToAnalytics(AppEvents.renewCommercialLicenseOpen);
    CommonFunctions.sendUXCamEvent(
        UXCamEvents.startCardServiceRenewLicenseService);

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.RenewCommercialLicense_Open_Service_Card_Event);
  }

  @override
  Widget build(BuildContext context) {
    int licenseId = ModalRoute.of(context)!.settings.arguments as int;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) =>
              RenewStartServiceBloc(licenseId: licenseId),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => ServiceDataViewModel(
            webService: sl(),
            serviceId: RemoteConfig.MunicipalServicesIDs["CommercialLicenseRenew"]["id"],
          ),
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
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 26,
                      ),
                      child: state.status == BlocStatus.loading
                          ? const Center(child: CustomCircularLoadingWidget())
                          : ElevatedButtonWidget.startService(
                        onPressed: () async {
                          context.read<RenewStartServiceBloc>().add(
                            const ValidateBeforeApplyEvent(),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

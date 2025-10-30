import 'package:balady_plus/etmam_app/core/dependency_injection/injection_container.dart'
    show sl;

import 'package:balady_plus/app/core/utils/utils_exports.dart';

import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show AppEvents;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show CustomLoadingWidget;
import 'package:balady_plus/etmam_app/features/etmam_entry_point/presentation/cubit/etmam_entry_point_cubit.dart';
import 'package:balady_plus/etmam_app/features/home/home_exports.dart'
    show
        EtmamBannerSlider,
        EtmamHomeAppBarWidget,
        EtmamMainServicesWidget,
        EtmamSubServicesWidget,
        EtmamTopRatedProvidersWidget,
        HomeBloc,
        HomeState;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/core/utils/constants/ux_cam_events.dart';
import '../widgets/etmam_home_page/etmam_bidding_widget.dart';

class EtmamHomePage extends StatefulWidget {
  final bool isMunicipalService;
  const EtmamHomePage({Key? key, this.isMunicipalService = true})
      : super(key: key);

  @override
  State<EtmamHomePage> createState() => _EtmamHomePage();
}

class _EtmamHomePage extends State<EtmamHomePage> {
  @override
  void initState() {
    super.initState();
    //CommonFunctions.sendEventToAnalytics(AppEvents.HomePage);
    sl<EtmamEntryPointCubit>().onLogin();

    if (widget.isMunicipalService) {
      CommonFunctions.sendUXCamEvent(
          UXCamEvents.startServiceLicensingAndPlanningServices);
    } else {
      CommonFunctions.sendUXCamEvent(UXCamEvents.startServiceServicesProviders);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
      create: (context) => HomeBloc(
          isMunicipalService: widget.isMunicipalService,
          getMainServices: sl(),
          getTopOrderedSubService: sl(),
          getTopRatedProviders: sl(),
          getSubService: sl(),
          getServicesProvidersByService: sl(),
          getProviderDetails: sl(),
          getAds: sl()),
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const EtmamHomeAppBarWidget(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(children: [
                        const EtmamMainServicesWidget(),
                        if (context.read<HomeBloc>().isMunicipalService ==
                            true) ...[
                          const EtmamBannerSlider(),
                          if (!(state.hideBidding ?? false))
                            const EtmamBiddingWidget(),
                        ],
                        // EtmamSubServicesWidget(),
                        const EtmamTopRatedProvidersWidget(),
                      ]),
                    ),
                  ),
                ],
              ),
              if (state.status == BlocStatus.loading)
                const Center(child: CustomLoadingWidget()),
            ],
          );
        },
      ),
    ));
  }
}

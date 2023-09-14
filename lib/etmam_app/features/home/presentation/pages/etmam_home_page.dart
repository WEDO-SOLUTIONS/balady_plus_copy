import 'package:balady_plus/etmam_app/core/dependency_injection/injection_container.dart'
    show sl;
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show CommonFunctions;
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

import '../widgets/etmam_home_page/etmam_bidding_widget.dart';

class EtmamHomePage extends StatefulWidget {
  const EtmamHomePage({Key? key}) : super(key: key);

  @override
  State<EtmamHomePage> createState() => _EtmamHomePage();
}

class _EtmamHomePage extends State<EtmamHomePage> {
  @override
  void initState() {
    super.initState();
    //CommonFunctions.sendEventToAnalytics(AppEvents.HomePage);
    sl<EtmamEntryPointCubit>().onLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
      create: (context) => HomeBloc(
          getMainServices: sl(),
          getTopOrderedSubService: sl(),
          getTopRatedProviders: sl(),
          getSubService: sl(),
          getServicesProvidersByService: sl(),
          getProviderDetails: sl(),
          getAds: sl()),
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Column(
            children: [
              const EtmamHomeAppBarWidget(),
              Expanded(
                child: SingleChildScrollView(
                  child: Stack(alignment: Alignment.center, children: [
                    const Column(children: [
                      EtmamMainServicesWidget(),
                      EtmamBannerSlider(),
                      EtmamBiddingWidget(),
                      // EtmamSubServicesWidget(),
                      EtmamTopRatedProvidersWidget(),
                    ]),
                    if (state.status == BlocStatus.loading)
                      const Center(child: CustomLoadingWidget())
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    ));
  }
}

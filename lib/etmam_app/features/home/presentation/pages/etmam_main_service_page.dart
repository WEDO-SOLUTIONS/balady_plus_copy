import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show CommonFunctions, CommonProperties, trans;
import 'package:balady_plus/app/core/utils/utils_exports.dart' show BlocStatus;

import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show AppEvents;
import 'package:balady_plus/etmam_app/features/home/home_exports.dart'
    show
        GetSubServiceEvent,
        MainServiceResponse,
        MainServicesBloc,
        MainServicesState,
        ServiceCardWidget,
        EtmamMainServiceCardWidget,
        SubServiceParams;
import 'package:balady_plus/etmam_app/core/dependency_injection/injection_container.dart'
    show sl;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show CustomAppBar, CustomLoadingWidget, CustomShimmerGridViewWidget;

import '../../../../../app/core/utils/constants/constants.dart';

class EtmamMainServicesPage extends StatefulWidget {
  const EtmamMainServicesPage({
    Key? key,
  }) : super(key: key);

  @override
  State<EtmamMainServicesPage> createState() => _EtmamMainServicesPageState();
}

class _EtmamMainServicesPageState extends State<EtmamMainServicesPage> {
  @override
  void initState() {
    super.initState();
    //CommonFunctions.sendEventToAnalytics(AppEvents.MainServicesListPage);
  }

  @override
  Widget build(BuildContext context) {
    (MainServiceResponse, String) args = ModalRoute.of(context)!
        .settings
        .arguments as (MainServiceResponse, String);

    return Scaffold(
      appBar: CustomAppBar(title: trans('services')),
      body: BlocProvider(
        create: (context) => MainServicesBloc(
            getSubService: sl(),
            classificationId: args.$2,
            mainServiceResponse: args.$1,
            getMainServices: sl()),
        child: BlocConsumer<MainServicesBloc, MainServicesState>(
          listener: (context, state) {
            if (state.blocStatus == BlocStatus.failure) {
              CommonFunctions.showError(state.errorMessage ?? "");
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    //padding: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.only(
                        bottom: Constants.mediumPadding,
                        left: Constants.semiMediumPadding,
                        right: Constants.semiMediumPadding,
                        top: Constants.smallPadding),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 19.0,
                      mainAxisSpacing: 18.0,
                    ),
                    itemCount: state.mainServiceResponse?.items?.length ?? 0,
                    itemBuilder: (ctx, index) {
                      return EtmamMainServiceCardWidget(
                        serviceName:
                            state.mainServiceResponse?.items?[index].name ?? "",
                        serviceIcon:
                            state.mainServiceResponse?.items?[index].logoUrl ??
                                "",
                        btnPressed: () {
                          context.read<MainServicesBloc>().add(
                              GetSubServiceEvent(
                                  params: SubServiceParams(
                                      cityId: CommonProperties.cityId,
                                      mainServiceId: state.mainServiceResponse!
                                          .items![index].id!,
                                      mainServiceName: state
                                          .mainServiceResponse!
                                          .items![index]
                                          .name!)));
                        },
                      );
                    }),
                if (state.blocStatus == BlocStatus.loadingShimmer)
                  const CustomShimmerGridViewWidget(
                    height: 110,
                  ),
                if (state.blocStatus == BlocStatus.loading)
                  const CustomLoadingWidget()
              ],
            );
          },
        ),
      ),
    );
  }
}

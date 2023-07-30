import 'package:balady_plus/etmam_app/core/dependency_injection/injection_container.dart'
    show sl;
import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show AppEvents;
import 'package:balady_plus/etmam_app/features/home/home_exports.dart'
    show
        SubServiceCardWidget,
        SubServicePageArgs,
        SubServicesBloc,
        EtmamSubServicePageCardWidget,
        SubServicesState;
import 'package:balady_plus/etmam_app/features/home/presentation/blocs/sub_service_bloc/sub_services_bloc.dart';
import 'package:balady_plus/etmam_app/features/services/services_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/utils_exports.dart'
    show CommonFunctions, CommonProperties;
import 'package:balady_plus/app/core/utils/utils_exports.dart' show BlocStatus;

import '../../../_shared_feature_/shared/shared_feature_exports.dart'
    show CustomAppBar, CustomLoadingWidget;

class EtmamSubServicesPage extends StatefulWidget {
  // SubServiceResponse subServiceResponse;
  //
  // SubServicesPage({Key? key, required this.subServiceResponse})
  //     : super(key: key);
  final SubServicePageArgs subServicePageArgs;

  EtmamSubServicesPage({Key? key, required this.subServicePageArgs})
      : super(key: key);

  @override
  State<EtmamSubServicesPage> createState() => _EtmamSubServicesPageState();
}

class _EtmamSubServicesPageState extends State<EtmamSubServicesPage> {
  @override
  void initState() {
    super.initState();
    //CommonFunctions.sendEventToAnalytics(AppEvents.SubServicesListPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.subServicePageArgs.mainServiceName),
      body: BlocProvider(
        create: (context) => SubServicesBloc(
          response: widget.subServicePageArgs.subServiceResponse,
          getServicesProvidersByService: sl(),
          // getSubService: sl()
        ),
        child: BlocConsumer<SubServicesBloc, SubServicesState>(
          listener: (context, state) {
            if (state.blocStatus == BlocStatus.failure) {
              CommonFunctions.showError(state.errorMessage ?? "");
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                ListView.builder(
                    padding:
                        const EdgeInsets.only(right: 16, left: 16, top: 10),
                    itemCount: state.subServiceResponse?.items?.length ?? 0,
                    itemBuilder: (ctx, index) {
                      return EtmamSubServicePageCardWidget(
                        fromPage: true,
                        subServiceIcon:
                            state.subServiceResponse?.items?[index].imageUrl ??
                                "",
                        subServiceName:
                            state.subServiceResponse?.items?[index].name ?? "",
                        btnPressed: () {
                          context.read<SubServicesBloc>().add(GetProvidersEvent(
                                params: ServiceParams(
                                    cityId: CommonProperties.cityId,
                                    pageIndex: "1",
                                    subServiceId: state
                                        .subServiceResponse!.items![index].id!,
                                    subServiceName: state.subServiceResponse!
                                        .items![index].name!),
                              ));
                        },
                      );
                    }),
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

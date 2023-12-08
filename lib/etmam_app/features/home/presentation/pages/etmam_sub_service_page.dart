import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/etmam_app/core/dependency_injection/injection_container.dart'
    show sl;
import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show AppEvents;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_circular_icon_button.dart';
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
import 'package:balady_plus/app/core/utils/utils_exports.dart'
    show AppFontWeight, BlocStatus;

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
    return
        // Scaffold(
        //   backgroundColor: Colors.white,
        //   appBar: CustomAppBar(title: widget.subServicePageArgs.mainServiceName),
        BlocProvider(
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
          return ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Container(
              color: AppColor.white,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Stack(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomTextWidget(
                              widget.subServicePageArgs.mainServiceName ?? '',
                              fontSize: 20,
                              fontWeight: AppFontWeight.bold,
                              fontColor: AppColor.blackModern900Light,
                            ),
                            CustomCircularContainerForIcons.green(
                              child: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.only(
                              right: 16, left: 16, top: 10),
                          itemCount:
                              state.subServiceResponse?.items?.length ?? 0,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemBuilder: (ctx, index) {
                            return EtmamSubServicePageCardWidget(
                              subServiceIcon: state.subServiceResponse
                                      ?.items?[index].imageUrl ??
                                  "",
                              subServiceName: state
                                      .subServiceResponse?.items?[index].name ??
                                  "",
                              btnPressed: () {
                                context.read<SubServicesBloc>().add(
                                      GetProvidersEvent(
                                        params: ServiceParams(
                                            cityId: CommonProperties.cityId,
                                            pageIndex: "1",
                                            subServiceId: state
                                                .subServiceResponse!
                                                .items![index]
                                                .id!,
                                            subServiceName: state
                                                .subServiceResponse!
                                                .items![index]
                                                .name!),
                                      ),
                                    );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  // ListView.builder(
                  //   padding: const EdgeInsets.only(right: 16, left: 16, top: 10),
                  //   itemCount: state.subServiceResponse?.items?.length ?? 0,
                  //   itemBuilder: (ctx, index) {
                  //     return EtmamSubServicePageCardWidget(
                  //       fromPage: true,
                  //       subServiceIcon:
                  //           state.subServiceResponse?.items?[index].imageUrl ??
                  //               "",
                  //       subServiceName:
                  //           state.subServiceResponse?.items?[index].name ?? "",
                  //       btnPressed: () {
                  //         context.read<SubServicesBloc>().add(GetProvidersEvent(
                  //               params: ServiceParams(
                  //                   cityId: CommonProperties.cityId,
                  //                   pageIndex: "1",
                  //                   subServiceId: state
                  //                       .subServiceResponse!.items![index].id!,
                  //                   subServiceName: state
                  //                       .subServiceResponse!.items![index].name!),
                  //             ));
                  //       },
                  //     );
                  //   },
                  // ),
                  if (state.blocStatus == BlocStatus.loading)
                    const CustomLoadingWidget()
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

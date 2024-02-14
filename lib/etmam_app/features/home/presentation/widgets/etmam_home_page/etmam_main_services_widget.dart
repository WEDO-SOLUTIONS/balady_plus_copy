import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart'
    show BlocStatus, IconPath, CommonFunctions;

import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomIndicatorWidget,
        CustomInkWellButtonWidget,
        CustomShimmerHorizontalListWidget,
        CustomTextWidget,
        CustomSvgIconWidget,
        CustomNetworkImageWidget,
        CustomVerticalSpace,
        ReloadWidget;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, CommonProperties, trans;
import 'package:balady_plus/etmam_app/features/home/home_exports.dart'
    show
        EtmamSubServicesPage,
        GetMainServicesEvent,
        GetSubServicesEvent,
        HomeBloc,
        HomeState,
        MainServiceItems,
        MainServiceParams,
        SubServicePageArgs,
        SubServiceParams,
        SubServiceResponse;

import '../../../../_shared_feature_/shared/presentation/widgets/header_with_all_button_widget.dart';
import '../../../../_shared_feature_/shared/presentation/widgets/no_data_widget.dart';

class EtmamMainServicesWidget extends StatefulWidget {
  const EtmamMainServicesWidget({Key? key}) : super(key: key);

  @override
  State<EtmamMainServicesWidget> createState() => _EtmamMainServicesWidget();
}

class _EtmamMainServicesWidget extends State<EtmamMainServicesWidget> {
  int currentIndex = 0;
  int _numWidgetsPerPage = 3;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        double height = 100;
        if ((state.mainServiceResponse?.items?.length ?? 0) > 2) {
          height = 270;
        }
        if ((state.mainServiceResponse?.items?.length ?? 0) == 2) {
          height = 210;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomTextWidget(
                trans("available_services"),
                fontSize: 18,
                fontWeight: AppFontWeight.bold,
                fontColor: AppColor.black700,
              ),
            ),
            if (state.mainServiceStatus == BlocStatus.success &&
                (state.mainServiceResponse?.items?.isEmpty ?? true))
              NoDataWidget(),
            if (state.mainServiceStatus == BlocStatus.loading)
              const EtmamServicesLoadingWidget(),
            if (state.mainServiceStatus == BlocStatus.failure)
              ReloadWidget(
                widgetHeight: 96,
                onTab: () {
                  context.read<HomeBloc>().add(
                        GetMainServicesEvent(
                          params: MainServiceParams(
                              cityId: CommonProperties.cityId,
                              pageIndex: "0",
                              pageSize: "20"),
                        ),
                      );
                },
              ),
            if (state.mainServiceStatus == BlocStatus.success) ...[
              Container(
                height: height,
                child: PageView.builder(
                  padEnds: false,
                  itemCount: ((state.mainServiceResponse?.items?.length ?? 0) /
                          _numWidgetsPerPage)
                      .ceil(),
                  controller: PageController(initialPage: 0),
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemBuilder: (BuildContext context, int itemIndex) {
                    int startIndex = itemIndex * _numWidgetsPerPage;
                    int endIndex = (itemIndex + 1) * _numWidgetsPerPage;

                    List<MainServiceItems>? widgetsToShow =
                        state.mainServiceResponse?.items?.sublist(
                      startIndex,
                      endIndex.clamp(
                        0,
                        state.mainServiceResponse?.items?.length ?? 0,
                      ),
                    );
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: widgetsToShow!.map(
                        (widget) {
                          return Container(
                            margin: const EdgeInsetsDirectional.symmetric(
                              horizontal: 16,
                            ),
                            child: EtmamServiceCardWidget(
                              serviceName: widget.name ?? "",
                              // serviceName:
                              //     state.mainServiceResponse?.items?[itemIndex].name ??
                              //         "",
                              serviceIcon: widget.logoUrl ?? "",
                              btnPressed: () {
                                context.read<HomeBloc>().add(
                                      GetSubServicesEvent(
                                        params: SubServiceParams(
                                          cityId: CommonProperties.cityId,
                                          mainServiceId: widget.id!,
                                          mainServiceName: widget.name!,
                                        ),
                                      ),
                                    );

                                // show bottom modal sheet
                                // showModalBottomSheet(
                                //     context: context,
                                //     isScrollControlled: true,
                                //     shape: const RoundedRectangleBorder(
                                //       borderRadius: BorderRadius.only(
                                //         topLeft: Radius.circular(16),
                                //         topRight: Radius.circular(16),
                                //       ),
                                //     ),
                                //     builder: (context) {
                                //       return EtmamSubServicesPage(
                                //         subServicePageArgs: SubServicePageArgs(
                                //           subServiceResponse:
                                //           SubServiceResponse(
                                //             items: widget.subServices
                                //           ),

                                //         )
                                //       )
                                //     });
                              },
                            ),
                          );
                        },
                      ).toList(),
                    );
                  },
                ),
              ),
              const CustomVerticalSpace(height: 12),
              // indicator
              SizedBox(
                height: 10.0,
                child: CustomIndicatorWidget(
                  currentIndex: currentIndex,
                  length: ((state.mainServiceResponse?.items?.length ?? 0) / 3)
                      .ceil(),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class EtmamServiceCardWidget extends StatelessWidget {
  final String serviceName;
  final String serviceIcon;
  final VoidCallback btnPressed;

  const EtmamServiceCardWidget(
      {Key? key,
      required this.serviceName,
      required this.btnPressed,
      required this.serviceIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomInkWellButtonWidget(
      btnPressed: btnPressed,
      widget: Container(
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(14),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        height: 78,
        child: Row(
          children: [
            Container(
              margin: const EdgeInsetsDirectional.all(16),
              child: CustomNetworkImageWidget(
                serviceIcon,
                imageHeight: 35,
                imageWidth: 35,
                imageFit: BoxFit.contain,
                placeHolderWidget: Container(
                  color: Colors.grey,
                  width: 55,
                  height: 55,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                child: ListTile(
                  title: CustomTextWidget(
                    serviceName,
                    fontSize: 14,
                    fontColor: AppColor.black,
                    fontWeight: AppFontWeight.bold,
                    maxLines: 2,
                  ),
                ),
              ),
            ),
            RotatedBox(
              quarterTurns: CommonFunctions.isAppAR ? 0 : 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomSvgIconWidget(
                  IconPath.arrowForward2,
                  iconColor: AppColor.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EtmamServicesLoadingWidget extends StatelessWidget {
  const EtmamServicesLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CustomShimmerHorizontalListWidget(height: 100);
  }
}

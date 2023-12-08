import 'package:balady_plus/etmam_app/core/utils/common_properties.dart';
import 'package:balady_plus/etmam_app/features/home/domain/entities/sub_services/top_ordered_sub_service_params.dart';
import 'package:balady_plus/etmam_app/features/home/presentation/blocs/home_bloc/home_bloc.dart';
import 'package:balady_plus/etmam_app/features/services/services_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart' show BlocStatus;

import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, BlocStatus, trans;

import '../../../../_shared_feature_/shared/presentation/widgets/header_with_all_button_widget.dart';
import '../../../../_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomInkWellButtonWidget,
        CustomNetworkImageWidget,
        CustomShimmerGridViewWidget,
        CustomTextWidget,
        CustomVerticalSpace,
        ReloadWidget;

class EtmamSubServicesWidget extends StatelessWidget {
  const EtmamSubServicesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Column(
          children: [
            HeaderWithAllButtonWidget(
              showAllButton: false,
              allOnPressed: () {},
              header: trans('most_ordered_services'),
            ),
            if (state.topOrderedSubServiceStatus == BlocStatus.loading)
              const EtmamSubServicesLoadingWidget(),
            if (state.topOrderedSubServiceStatus == BlocStatus.failure)
              ReloadWidget(
                widgetHeight: 180,
                onTab: () {
                  context.read<HomeBloc>().add(GetTopOrderedSubServicesEvent(
                      params: TopOrderedSubServiceParams(
                          cityId: CommonProperties.cityId,
                          pageSize: "4",
                          pageIndex: "1")));
                },
              ),
            if (state.topOrderedSubServiceStatus == BlocStatus.success)
              Container(
                  height: (state.getTopOrderedSubServiceCount() != null &&
                          state.getTopOrderedSubServiceCount()! < 3)
                      ? 180
                      : 360,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(top: 10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20.0,
                              mainAxisExtent: 162),
                      itemCount:
                          state.topOrderedsubServiceResponse?.items?.length ??
                              0,
                      itemBuilder: (ctx, index) {
                        return EtmamSubServiceCardWidget(
                          subServiceIcon: state.topOrderedsubServiceResponse
                                  ?.items?[index].logoUrl ??
                              "",
                          subServiceName: state.topOrderedsubServiceResponse
                                  ?.items?[index].name ??
                              "",
                          btnPressed: () {
                            context.read<HomeBloc>().add(GetProviders(
                                params: ServiceParams(
                                    cityId: CommonProperties.cityId,
                                    pageIndex: "1",
                                    subServiceId: state
                                            .topOrderedsubServiceResponse
                                            ?.items?[index]
                                            .id ??
                                        "",
                                    subServiceName: state
                                        .topOrderedsubServiceResponse!
                                        .items![index]
                                        .name!)));
                          },
                        );
                      })),
          ],
        );
      },
    );
  }
}

class EtmamSubServiceCardWidget extends StatelessWidget {
  final String subServiceName;
  final String subServiceIcon;
  final VoidCallback btnPressed;

  const EtmamSubServiceCardWidget(
      {Key? key,
      required this.subServiceName,
      required this.btnPressed,
      required this.subServiceIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomInkWellButtonWidget(
        btnPressed: btnPressed,
        widget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 162,
              width: double.infinity,
              decoration: new BoxDecoration(
                color: Color(0xffffffff),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                      color: Color(0x19000000),
                      offset: Offset(0, 1),
                      blurRadius: 15,
                      spreadRadius: 0)
                ],
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomVerticalSpace(height: 24),
                  // icon
                  CustomNetworkImageWidget(
                    subServiceIcon,
                    imageHeight: 52,
                    imageWidth: 52,
                    imageFit: BoxFit.fill,
                  ),
                  CustomVerticalSpace(height: 12),
                  // service name
                  CustomTextWidget(
                    subServiceName,
                    fontColor: AppColor.black,
                    fontSize: 14.0,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    fontWeight: AppFontWeight.bold,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

class EtmamSubServicesLoadingWidget extends StatelessWidget {
  const EtmamSubServicesLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 180,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: CustomShimmerGridViewWidget(
          crossAxisCount: 2,
          itemCount: 2,
          height: 162,
        ));
  }
}

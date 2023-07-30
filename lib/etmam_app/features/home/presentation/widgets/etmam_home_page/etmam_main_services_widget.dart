import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart' show BlocStatus;

import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomIndicatorWidget,
        CustomInkWellButtonWidget,
        CustomNetworkImageWidget,
        CustomShimmerHorizontalListWidget,
        CustomTextWidget,
        CustomVerticalSpace,
        ReloadWidget;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show
        AppColor,
        AppFontWeight,
        BlocStatus,
        CommonFunctions,
        CommonProperties,
        RouteName,
        trans;
import 'package:balady_plus/etmam_app/features/home/home_exports.dart'
    show
        GetMainServicesEvent,
        GetSubServicesEvent,
        HomeBloc,
        HomeState,
        MainServiceParams,
        SubServiceParams;

import '../../../../_shared_feature_/shared/presentation/widgets/header_with_all_button_widget.dart';

class EtmamMainServicesWidget extends StatefulWidget {
  const EtmamMainServicesWidget({Key? key}) : super(key: key);

  @override
  State<EtmamMainServicesWidget> createState() => _EtmamMainServicesWidget();
}

class _EtmamMainServicesWidget extends State<EtmamMainServicesWidget> {
  int currentIndex = 0;

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
              showAllButton: (state.mainServiceStatus == BlocStatus.success &&
                  (state.mainServiceResponse?.items?.length ?? 0) > 0),
              allOnPressed: () {
                NavigationService.pushNamed(
                    routeName: EtmamRoutesNames.mainServicesPage,
                    args: state.mainServiceResponse);
              },
              header: trans('services'),
            ),
            if (state.mainServiceStatus == BlocStatus.loading)
              const EtmamServicesLoadingWidget(),
            if (state.mainServiceStatus == BlocStatus.failure)
              ReloadWidget(
                widgetHeight: 96,
                onTab: () {
                  context.read<HomeBloc>().add(GetMainServicesEvent(
                      params: MainServiceParams(
                          cityId: CommonProperties.cityId,
                          pageIndex: "1",
                          pageSize: "3")));
                },
              ),
            if (state.mainServiceStatus == BlocStatus.success) ...[
              Container(
                height: 100,
                child: PageView.builder(
                  padEnds: false,
                  itemCount: state.mainServiceResponse?.items?.length ?? 0,
                  controller: PageController(viewportFraction: 0.7),
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemBuilder: (BuildContext context, int itemIndex) {
                    return Container(
                      margin: EdgeInsetsDirectional.only(
                          start: itemIndex == 0 ? 16 : 0),
                      child: EtmamServiceCardWidget(
                          serviceName: state.mainServiceResponse
                                  ?.items?[itemIndex].name ??
                              "",
                          serviceIcon: state.mainServiceResponse
                                  ?.items?[itemIndex].logoUrl ??
                              "",
                          btnPressed: () {
                            context.read<HomeBloc>().add(GetSubServicesEvent(
                                params: SubServiceParams(
                                    cityId: CommonProperties.cityId,
                                    mainServiceId: state.mainServiceResponse!
                                        .items![itemIndex].id!,
                                    mainServiceName: state.mainServiceResponse!
                                        .items![itemIndex].name!)));
                          }),
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
                    length: state.mainServiceResponse?.items?.length ?? 0,
                  )),
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
        decoration: new BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
                color: Color(0x14000000),
                offset: Offset(0, 2),
                blurRadius: 4,
                spreadRadius: 0)
          ],
        ),
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        height: 96,
        child: Row(
          children: [
            Expanded(
                flex: 4,
                child: Container(
                    margin: const EdgeInsetsDirectional.only(start: 16),
                    child: CustomTextWidget(
                      serviceName,
                      fontSize: 17,
                      fontColor: AppColor.black,
                      fontWeight: AppFontWeight.bold,
                      maxLines: 2,
                    ))),
            Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsetsDirectional.only(end: 5),
                child: CustomNetworkImageWidget(
                  serviceIcon,
                  imageHeight: double.infinity,
                  imageWidth: double.infinity,
                  imageFit: BoxFit.contain,
                  placeHolderWidget: Container(
                    color: Colors.transparent,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
            )
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

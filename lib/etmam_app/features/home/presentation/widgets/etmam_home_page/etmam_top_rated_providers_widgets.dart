import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show HeaderWithAllButtonWidget;
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/etmam_app/core/utils/common_properties.dart';
import 'package:balady_plus/etmam_app/features/home/home_exports.dart';
import 'package:balady_plus/etmam_app/features/providers/providers_exports.dart'
    show ProviderDetailsParams;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, trans;
import 'package:balady_plus/app/core/utils/utils_exports.dart' show BlocStatus;

import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import '../../../../_shared_feature_/shared/presentation/widgets/header_with_all_button_widget.dart';
import '../../../../_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomInkWellButtonWidget,
        CustomShimmerHorizontalListWidget,
        CustomTextWidget,
        CustomVerticalSpace,
        EtmamProviderLogoIcon,
        EtmamRatingEvaluationWidget,
        ReloadWidget;

class EtmamTopRatedProvidersWidget extends StatelessWidget {
  const EtmamTopRatedProvidersWidget({Key? key}) : super(key: key);

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
              showAllButton:
                  (state.topRatedProvidersStatus == BlocStatus.success &&
                      (state.topRatedProviderResponse?.items?.length ?? 0) > 0),
              allOnPressed: () {
                NavigationService.pushNamed(
                    routeName: EtmamRoutesNames.providersListPage,
                    args: state.topRatedProviderResponse);
              },
              header: trans('top_rated_providers'),
            ),
            if (state.topRatedProvidersStatus == BlocStatus.loading)
              const EtmamProvidersLoadingWidget(),
            if (state.topRatedProvidersStatus == BlocStatus.failure)
              ReloadWidget(
                widgetHeight: 200,
                onTab: () {
                  context.read<HomeBloc>().add(GetTopRatedProvidersEvent(
                      params: TopRatedProviderParams(
                          cityId: CommonProperties.cityId,
                          pageSize: "4",
                          pageIndex: "1")));
                },
              ),
            if (state.topRatedProvidersStatus == BlocStatus.success)
              Container(
                  padding: EdgeInsetsDirectional.only(start: 16, end: 16),
                  height: 200,
                  child: ListView.builder(
                      clipBehavior: Clip.none,
                      itemCount:
                          state.topRatedProviderResponse?.items?.length ?? 0,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx, index) {
                        return EtmamServiceProviderItem(
                          isFirst: index == 0,
                          isLast: index ==
                              ((state.topRatedProviderResponse?.items?.length ??
                                      0) -
                                  1),
                          providerName: state.topRatedProviderResponse
                                  ?.items?[index].serviceProviderName ??
                              "",
                          providerRating: state.topRatedProviderResponse
                                  ?.items?[index].ratingAverage ??
                              0,
                          totalEvaluation: state.topRatedProviderResponse
                                  ?.items?[index].totalEvaluationNumber ??
                              0.0,
                          providerIcon: state.topRatedProviderResponse
                                  ?.items?[index].logoImageUrl ??
                              "",
                          onPress: () {
                            context.read<HomeBloc>().add(
                                GetProviderDetailsEvent(
                                    params: ProviderDetailsParams(
                                        cityId: CommonProperties.cityId,
                                        providerId: state
                                                .topRatedProviderResponse
                                                ?.items?[index]
                                                .id ??
                                            "")));
                          },
                        );
                      })),
          ],
        );
      },
    );
  }
}

class EtmamServiceProviderItem extends StatelessWidget {
  final String providerName;
  final double providerRating;
  final double totalEvaluation;
  final String providerIcon;
  final Function onPress;
  final bool isFirst;
  final bool isLast;

  const EtmamServiceProviderItem(
      {Key? key,
      required this.providerName,
      required this.providerRating,
      required this.totalEvaluation,
      required this.onPress,
      required this.providerIcon,
      this.isFirst = false,
      this.isLast = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomInkWellButtonWidget(
      btnPressed: () => onPress(),
      widget: Container(
        height: 200,
        width: 208,
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 20),
        margin: EdgeInsetsDirectional.only(bottom: 12, end: 12),
        decoration: new BoxDecoration(
          color: Color(0xffffffff),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
                color: Color(0x19000000),
                offset: Offset(0, 2),
                blurRadius: 10,
                spreadRadius: 0)
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          EtmamProviderLogoIcon(imageUrl: providerIcon),
          CustomVerticalSpace(height: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: CustomTextWidget(
                    providerName,
                    fontSize: 17,
                    fontColor: AppColor.black,
                    fontWeight: AppFontWeight.bold,
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: EtmamRatingEvaluationWidget(
                      rating: providerRating,
                      totalEvaluation: totalEvaluation,
                      withDot: false,
                    )),
              ],
            ),
          )
        ]),
      ),
    );
  }
}

class EtmamProvidersLoadingWidget extends StatelessWidget {
  const EtmamProvidersLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CustomShimmerHorizontalListWidget(height: 200);
  }
}

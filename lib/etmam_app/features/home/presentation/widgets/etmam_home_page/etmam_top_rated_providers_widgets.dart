import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/etmam_app/core/utils/common_properties.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/no_data_widget.dart';
import 'package:balady_plus/etmam_app/features/home/home_exports.dart';
import 'package:balady_plus/etmam_app/features/providers/providers_exports.dart'
    show ProviderDetailsParams;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, trans;
import 'package:balady_plus/app/core/utils/utils_exports.dart' show BlocStatus;

import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
              fontSize: 18,
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
            if (state.topRatedProvidersStatus == BlocStatus.success &&
                (state.topRatedProviderResponse?.items?.length ?? 0) > 0)
              Container(
                // padding: const EdgeInsetsDirectional.only(start: 16, end: 16),
                margin: const EdgeInsetsDirectional.only(bottom: 16),
                height: 90,
                child: ListView.builder(
                  clipBehavior: Clip.none,
                  itemCount: state.topRatedProviderResponse?.items?.length ?? 0,
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
                                  providerId: state.topRatedProviderResponse
                                          ?.items?[index].id ??
                                      "",
                                ),
                              ),
                            );
                      },
                    );
                  },
                ),
              ),
            if ((state.topRatedProvidersStatus == BlocStatus.success &&
                (state.topRatedProviderResponse?.items?.length ?? 0) == 0))
              NoDataWidget(
                title: "no_data".tr(),
              )
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
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(14),
        ),
        width: 303,
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        padding: EdgeInsets.only(bottom: 30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsetsDirectional.all(16),
              child: EtmamProviderLogoIcon(
                imageUrl: providerIcon,
              ),
            ),
            Expanded(
              child: SizedBox(
                child: ListTile(
                  title: CustomTextWidget(
                    providerName,
                    fontSize: 16,
                    fontColor: AppColor.black,
                    fontWeight: AppFontWeight.bold,
                    maxLines: 2,
                  ),
                  subtitle: EtmamRatingEvaluationWidget(
                    rating: providerRating,
                    totalEvaluation: totalEvaluation,
                    withDot: false,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Icon(
                Icons.arrow_forward,
                size: 14,
                color: AppColor.black700,
              ),
            ),
          ],
        ),
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

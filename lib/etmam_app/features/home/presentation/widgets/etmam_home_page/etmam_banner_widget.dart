import 'package:balady_plus/etmam_app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/etmam_app/features/home/home_exports.dart'
    show GetAdsEvent, HomeBloc, HomeState;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart'
    hide AppColor, AppFontWeight;

import '../../../../../../app/core/utils/constants/constants.dart';
import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppFontWeight;
import '../../../../_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomIndicatorWidget,
        CustomInkWellButtonWidget,
        CustomShimmerWidget,
        CustomTextWidget,
        CustomVerticalSpace,
        ReloadWidget;

class EtmamBannerSlider extends StatefulWidget {
  const EtmamBannerSlider({Key? key}) : super(key: key);

  @override
  State<EtmamBannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<EtmamBannerSlider> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Column(
          children: [
            if (state.adsResponseStatus == BlocStatus.loading)
              const EtmamAdsLoadingWidget(),
            if (state.adsResponseStatus == BlocStatus.failure)
              ReloadWidget(
                widgetHeight: 105,
                onTab: () {
                  context.read<HomeBloc>().add(GetAdsEvent());
                },
              ),
            if (state.adsResponseStatus == BlocStatus.success &&
                state.adsResponse?.items != null &&
                (state.adsResponse?.items?.length ?? 0) > 0) ...[
              CustomVerticalSpace(height: 24),
              Ink(
                color: Colors.transparent,
                child: SizedBox(
                  height: 105,
                  child: PageView.builder(
                    itemCount: state.adsResponse?.items?.length,
                    controller: PageController(keepPage: true),
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    itemBuilder: (BuildContext context, int itemIndex) {
                      return EtmamBannerWidget(
                        bannerTitle: state.adsResponse?.items?[itemIndex]
                                .mainDescription ??
                            "",
                        bannerDesc: state.adsResponse?.items?[itemIndex]
                                .subDescription ??
                            "",
                        onBannerPressed: () {},
                      );
                    },
                  ),
                ),
              ),
              if ((state.adsResponse?.items?.length ?? 0) > 1) ...[
                const CustomVerticalSpace(height: 12),
                // indicator
                SizedBox(
                    height: 10.0,
                    child: CustomIndicatorWidget(
                      currentIndex: currentIndex,
                      length: (state.adsResponse?.items?.length ?? 0),
                    )),
              ]
            ]
          ],
        );
      },
    );
  }
}

class EtmamBannerWidget extends StatelessWidget {
  final String bannerTitle;
  final String? bannerDesc;
  final VoidCallback? onBannerPressed;

  const EtmamBannerWidget(
      {Key? key,
      required this.bannerTitle,
      this.bannerDesc,
      this.onBannerPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomInkWellButtonWidget(
      btnPressed: onBannerPressed,
      widget: Container(
        height: 100,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        padding: const EdgeInsets.only(left: 16, top: 14, right: 16, bottom: 4),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(Constants.newInformationCardImg),
            ),
            boxShadow: Constants.boxShadow),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextWidget(
              bannerTitle,
              fontSize: 11,
              fontColor: AppColor.baladyDarkGreen2,
              fontWeight: AppFontWeight.medium,
              textAlign: TextAlign.start,
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
            ),
            CustomVerticalSpace(height: 8),
            if (bannerDesc != null)
              CustomTextWidget(
                bannerDesc ?? "",
                fontSize: 16,
                fontColor: AppColor.black500,
                fontWeight: AppFontWeight.medium,
                textAlign: TextAlign.start,
                maxLines: 2,
                textOverflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }
}

class EtmamAdsLoadingWidget extends StatelessWidget {
  const EtmamAdsLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CustomShimmerWidget(
      padding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}

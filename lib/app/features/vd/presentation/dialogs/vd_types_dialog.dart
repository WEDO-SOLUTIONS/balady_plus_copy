import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/vd/vd_exports.dart';
import 'package:balady_plus/shared/features/_shared_feature_/shared/shared_feature_exports.dart'
    show CustomShimmerGridViewWidget;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget copy.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class VDTypesDialog extends StatefulWidget {
  final bool? isFromHome;
  VDTypesDialog({Key? key, this.isFromHome = false}) : super(key: key);

  @override
  State<VDTypesDialog> createState() => _VDTypesDialog();
}

class _VDTypesDialog extends State<VDTypesDialog> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VDCategoryBloc, VDCategoryState>(
      listener: (context, state) {
        if (state.allCategorystatus == BlocStatus.failure) {
          CommonFunctions.showError(state.errorMessage ?? "");
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // button, title,
            Padding(
              padding: const EdgeInsets.only(
                top: GeneralKey.semiMediumPadding,
                left: GeneralKey.semiMediumPadding,
                right: GeneralKey.semiMediumPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // close button
                  CustomTextButtonWidget(
                    btnPressed: () => Navigator.of(context).pop(),
                    btnText: Helpers.translatingWord(
                      "customerVoiceBackButtonWord",
                    ),
                    btnTextColor: AppColor.grey1000,
                    btnTextSize: 17.0,
                    btnTextWeight: AppFontWeight.medium,
                  ),
                  Constants.verticalSpaceMedium,
                  // title
                  CustomTextWidget(
                    ("customerVoiceReportTypeWord").tr(),
                    fontColor: AppColor.black,
                    fontSize: 24.0,
                  ),
                  const CustomVerticalSpace(height: 18.0),
                  // subtitle
                  CustomTextWidget(
                    ("customerVoiceSelectReportTypeWord").tr(),
                    fontColor: AppColor.black400,
                    fontWeight: AppFontWeight.medium,
                  ),
                  Constants.verticalSpaceSmall,
                ],
              ),
            ),
            if (state.allCategorystatus == BlocStatus.loading)
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(
                    bottom: GeneralKey.mediumPadding,
                    left: GeneralKey.semiMediumPadding,
                    right: GeneralKey.semiMediumPadding,
                    top: GeneralKey.smallPadding),
                child: CustomShimmerGridViewWidget(
                  height: 100,
                  mainAxisExtent: 150,
                ),
              )),

            if (state.allCategorystatus == BlocStatus.failure)
              Expanded(
                child: ReloadWidget(onTab: () {
                  context.read<VDCategoryBloc>().add(GetAllCategories());
                }),
              ),
            if (state.allCategorystatus == BlocStatus.success)
              // types
              Expanded(
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(
                      bottom: GeneralKey.mediumPadding,
                      left: GeneralKey.semiMediumPadding,
                      right: GeneralKey.semiMediumPadding,
                      top: GeneralKey.smallPadding),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 19.0,
                      mainAxisSpacing: 18.0,
                      mainAxisExtent: 150),
                  itemCount: state.allCategories?.length ?? 0,
                  itemBuilder: (context, index) => VDCardWidgetInDialog(
                      title: state.allCategories?[index].categoryName ?? "",
                      icon: state.allCategories?[index].getMainImageUrl() ?? "",
                      btnPressed: () async {
                        bool isLocationAvailable =
                            await Helpers.checkLocationSettings(context);
                        bool isCameraAllowed =
                            await Helpers.checkCameraSettings(context);
                        if (isLocationAvailable && isCameraAllowed)
                          context.read<VDCategoryBloc>().navigateToCamera(index,
                              isFromHome: widget.isFromHome ?? false);
                      }),
                ),
              )
          ],
        );
        return Container();
      },
    );
  }
}

class VDCardWidgetInDialog extends StatelessWidget {
  final VoidCallback btnPressed;
  final String title;
  final String icon;

  const VDCardWidgetInDialog(
      {Key? key,
      required this.title,
      required this.icon,
      required this.btnPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomInkWellButtonWidget(
      btnPressed: btnPressed,
      widget: Container(
        height: 150,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Color(0x14000000),
                          offset: Offset(0, 2),
                          blurRadius: 5,
                          spreadRadius: 0)
                    ],
                    borderRadius: BorderRadius.circular(24),
                    color: AppColor.white),
                height: 134,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  children: [
                    CustomCachedNetworkImage(
                      icon,
                      imageHeight: 96,
                      imageFit: BoxFit.fitWidth,
                      placeHolderWidget: Container(
                        color: Colors.transparent,
                        height: 96,
                      ),
                    ),
                    CustomVerticalSpace(height: 10),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: CustomTextWidget(
                        title,
                        fontSize: 14,
                        fontColor: AppColor.black,
                        fontWeight: AppFontWeight.bold,
                        maxLines: 2,
                        height: 1.5,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

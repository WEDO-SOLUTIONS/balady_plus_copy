import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/vd/vd_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/constants/ux_cam_events.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_shimmer_list_widget.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../domain/entities/camera/camera_page_params.dart';

class QrTypesDialog extends StatefulWidget {
  final CameraParamsPage? cmeraParamsPage;

  QrTypesDialog({Key? key, this.cmeraParamsPage})
      : super(key: key);

  @override
  State<QrTypesDialog> createState() => _QrTypesDialog();
}

class _QrTypesDialog extends State<QrTypesDialog> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonFunctions.sendUXCamEvent(UXCamEvents.SnapAndSend_Open_QR_Types_Event);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VDCategoryBloc(getCategories: sl()),
      child: BlocConsumer<VDCategoryBloc, VDCategoryState>(
        listener: (context, state) {
          if (state.allCategorystatus == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
          }
        },
        builder: (context, state) {
          return Container(
            height: MediaQuery.of(context).size.height - 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // button, title,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // title
                    CustomTextWidget(
                      ("vd_report_type").tr(),
                      fontColor: AppColor.blackModern500Light,
                      fontSize: 14.0,
                    ),

                    Constants.verticalSpaceSmall,
                  ],
                ),
                if (state.allCategorystatus == BlocStatus.loading)
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(
                        /* bottom: GeneralKey.mediumPadding,
                        left: GeneralKey.semiMediumPadding,
                        right: GeneralKey.semiMediumPadding,
                        top: GeneralKey.smallPadding*/
                        ),
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
                          /*bottom: GeneralKey.mediumPadding,
                          left: GeneralKey.semiMediumPadding,
                          right: GeneralKey.semiMediumPadding,
                          top: GeneralKey.smallPadding*/
                          ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 19.0,
                              mainAxisSpacing: 18.0,
                              mainAxisExtent: 150),
                      itemCount: state.qrCategory?.length ?? 0,
                      itemBuilder: (context, index) => VDCardWidgetInDialog(
                          title: state.qrCategory?[index].categoryName ?? "",
                          icon:
                              state.qrCategory?[index].getMainImageUrl() ?? "",
                          btnPressed: () async {
                            bool isLocationAvailable =
                                await CommonFunctions.checkLocationSettings(
                                    context);
                            bool isCameraAllowed =
                                await CommonFunctions.checkCameraSettings(
                                    context);
                            if (isLocationAvailable && isCameraAllowed) {
                              NavigationService.navigatorKey.currentState!
                                  .pushNamed(
                                RouteName.vdCameraPage,
                                arguments: CameraParamsPage(
                                  lat: widget.cmeraParamsPage?.lat,
                                  lon: widget.cmeraParamsPage?.lon,
                                  qrCodeFlow: true,
                                  pageType: widget.cmeraParamsPage?.pageType,
                                  selectedCategory: CategoryItem(
                                      categoryId:
                                          state.qrCategory?[index].categoryId),
                                  // isFromHome: false,
                                ),
                              );
                            }
                          }),
                    ),
                  )
              ],
            ),
          );
          return Container();
        },
      ),
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
                      /* BoxShadow(
                          color: Color(0x14000000),
                          offset: Offset(0, 2),
                          blurRadius: 5,
                          spreadRadius: 0)*/
                    ],
                    borderRadius: BorderRadius.circular(16),
                    color: Color(0xFFF5F8FA)),
                height: 150,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: EdgeInsets.only(left: 5, right: 5, top: 8),
                child: Column(
                  children: [
                    CustomCachedNetworkImage(
                      icon,
                      imageHeight: 88,
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

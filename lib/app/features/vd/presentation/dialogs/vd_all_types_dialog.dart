import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/vd/vd_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/constants/ux_cam_events.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_shimmer_list_widget.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class VDAllTypesScreen extends StatefulWidget {
  const VDAllTypesScreen({Key? key}) : super(key: key);

  @override
  State<VDAllTypesScreen> createState() => _VDAllTypesDialog();
}

class _VDAllTypesDialog extends State<VDAllTypesScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonFunctions.sendUXCamEvent(
      UXCamEvents.SnapAndSend_Open_From_Services_Event,
    );
    CommonFunctions.sendUXCamEvent(UXCamEvents.typeServiceSnapAndSend);
    CommonFunctions.sendUXCamEvent(UXCamEvents.SnapAndSend_Open_Types_Event);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VDCategoryBloc(getCategories: sl()),
      child: Scaffold(
        appBar: AppBar(
          title: Text("customerVoiceReportTypeWord".tr()),
        ),
        body: BlocConsumer<VDCategoryBloc, VDCategoryState>(
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // title
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomTextWidget(
                        ("vd_report_type").tr(),
                        fontColor: AppColor.blackModern500Light,
                        maxLines: 4,
                        fontSize: 14.0,
                        height: 1.5,
                        fontWeight: AppFontWeight.bold,
                      ),
                    ),

                    Constants.verticalSpaceSmall,
                  ],
                ),
                if (state.allCategorystatus == BlocStatus.loading)
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          /* bottom: GeneralKey.mediumPadding,
                        left: GeneralKey.semiMediumPadding,
                        right: GeneralKey.semiMediumPadding,
                        top: GeneralKey.smallPadding*/
                          ),
                      child: CustomShimmerGridViewWidget(
                        height: 100,
                        mainAxisExtent: 150,
                      ),
                    ),
                  ),

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
                      itemCount: state.allCategories?.length ?? 0,
                      itemBuilder: (context, index) => VDCardWidgetInDialog(
                        title: state.allCategories?[index].categoryName ?? "",
                        icon:
                            state.allCategories?[index].getMainImageUrl() ?? "",
                        btnPressed: () async {
                          bool isLocationAvailable =
                              await CommonFunctions.checkLocationSettings(
                                  context);
                          bool isCameraAllowed =
                              await CommonFunctions.checkCameraSettings(
                                  context);
                          if (isLocationAvailable && isCameraAllowed) {
                            context.read<VDCategoryBloc>().navigateToCamera(
                                  index,
                                );
                          }
                        },
                      ),
                    ),
                  )
              ],
            );
          },
        ),
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
      widget: SizedBox(
        height: 150,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                    boxShadow: const [
                      /* BoxShadow(
                          color: Color(0x14000000),
                          offset: Offset(0, 2),
                          blurRadius: 5,
                          spreadRadius: 0)*/
                    ],
                    borderRadius: BorderRadius.circular(16),
                    color: const Color(0xFFF5F8FA)),
                height: 150,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: const EdgeInsets.only(left: 5, right: 5, top: 8),
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
                    const CustomVerticalSpace(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
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

import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/constants.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/etmam_app/features/services/services_exports.dart'
    show Project, ServiceDetailsBloc, ServiceDetailsState;
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/utils_exports.dart'
    show AppFontWeight, IconPath, PrimaryIcons, RouteName, trans;
import '../../../../_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomElevatedButtonWidget,
        CustomHorizontalSpace,
        CustomInkWellButtonWidget,
        CustomNetworkImageWidget,
        CustomSvgIconWidget,
        CustomTextWidget,
        CustomVerticalSpace,
        HeaderWithViewAllWidget,
        SectionTitleWidget;

class PreviousWorks extends StatelessWidget {
  final List<Project>? projects;

  const PreviousWorks({
    super.key,
    required this.projects,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        (projects?.length ?? 0) > 0
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  color: AppColor.white,
                  boxShadow: Constants.boxShadow,
                ),
                child: Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemCount: (projects?.length ?? 0) > 3
                          ? 3
                          : (projects?.length ?? 0),
                      itemBuilder: (_, index) => PreviousWorkCard(
                        project: projects?[index],
                      ),
                    ),
                    const SizedBox(height: 12),
                    if ((projects?.length ?? 0) > 3)
                      CustomElevatedButtonWidget(
                        btnText: trans("show_all"),
                        btnTextColor: AppColor.primary900Light,
                        btnTextSize: 12,
                        btnTextWeight: AppFontWeight.bold,
                        btnHeight: 42,
                        btnRadius: 8,
                        btnBorderWidth: 1,
                        btnColor: AppColor.white,
                        btnBorderColor: AppColor.primary900Light,
                        btnPadding: const EdgeInsets.symmetric(horizontal: 16),
                        btnPressed: () {
                          NavigationService.pushNamed(
                              routeName: EtmamRoutesNames.previousWorksPage,
                              args: projects);
                        },
                      ),
                  ],
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}

// class PreviousWorksWidgets extends StatelessWidget {
//   const PreviousWorksWidgets({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ServiceDetailsBloc, ServiceDetailsState>(
//       builder: (context, state) {
//         return (state.response.provider?.projects?.length ?? 0) > 0
//             ? Container(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       HeaderWithViewAllWidget(
//                         headerText: trans('previous_works_desc'),
//                         headerTextColor: AppColor.bottomNavigationShadow,
//                         headerTextSize: 12,
//                         headerFontWeight: AppFontWeight.regular,
//                         margin: EdgeInsets.zero,
//                         showAllButton:
//                             (state.response.provider?.projects?.length ?? 0) >
//                                 3,
//                         btnPressed: () {
//                           NavigationService.pushNamed(
//                               routeName: EtmamRoutesNames.previousWorksPage,
//                               args: state.response.provider?.projects);
//                         },
//                       ),
//                       const CustomVerticalSpace(height: 24),
//                       SizedBox(
//                           height: 190,
//                           child: ListView.builder(
//                               itemCount:
//                                   (state.response.provider?.projects?.length ??
//                                               0) >
//                                           3
//                                       ? 3
//                                       : (state.response.provider?.projects
//                                               ?.length ??
//                                           0),
//                               scrollDirection: Axis.horizontal,
//                               itemBuilder: (ctx, index) {
//                                 return PreviousWorkCard(
//                                     project: state
//                                         .response.provider?.projects?[index]);
//                               })),
//                     ]))
//             : Container();
//       },
//     );
//   }
// }

class PreviousWorkCard extends StatelessWidget {
  final Project? project;

  const PreviousWorkCard({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomInkWellButtonWidget(
      btnPressed: () {
        NavigationService.pushNamed(
            routeName: EtmamRoutesNames.previousWorksDetailsPage,
            args: project);
      },
      widget: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: AppColor.primary5Light,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          children: [
            Image.asset(
              IconPath.attach,
              width: 32,
              height: 32,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextWidget(
                project?.name ?? '',
                fontSize: 12,
                fontWeight: AppFontWeight.bold,
                fontColor: AppColor.black600,
              ),
            ),
            const SizedBox(width: 12),
            const CustomSvgIconWidget(
              IconPath.arrowLeft,
              iconSize: 10,
              iconColor: AppColor.black700,
            ),
          ],
        ),
      ),

      // Container(
      //   height: 180,
      //   width: 120,
      //   margin: const EdgeInsetsDirectional.only(end: 10),
      //   decoration: const BoxDecoration(
      //     borderRadius: BorderRadius.all(Radius.circular(4)),
      //     color: AppColor.black100,
      //   ),
      //   child: Column(
      //     children: [
      //       SizedBox(
      //         height: 124,
      //         width: double.infinity,
      //         child: Stack(
      //           children: [
      //             Align(
      //               alignment: Alignment.center,
      //               child: ClipRRect(
      //                 borderRadius: const BorderRadius.only(
      //                     topLeft: Radius.circular(4),
      //                     topRight: Radius.circular(4)),
      //                 child: SizedBox(
      //                   height: 152,
      //                   width: double.infinity,
      //                   child: CustomNetworkImageWidget(
      //                     project?.images?.firstOrNull ?? "",
      //                     imageHeight: 152,
      //                     imageWidth: double.infinity,
      //                     imageFit: BoxFit.fill,
      //                   ),
      //                 ),
      //               ),
      //             ),
      //             // Align(
      //             //   alignment: AlignmentDirectional.bottomCenter,
      //             //   child: LocationWidget(location: location),
      //             // )
      //           ],
      //         ),
      //       ),
      //       Expanded(
      //         child: Container(
      //           padding: EdgeInsets.symmetric(horizontal: 12),
      //           alignment: Alignment.center,
      //           child: CustomTextWidget(
      //             project?.name ?? "",
      //             fontColor: AppColor.black,
      //             maxLines: 2,
      //             fontSize: 13,
      //             fontWeight: AppFontWeight.medium,
      //           ),
      //         ),
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}

// class LocationWidget extends StatelessWidget {
//   final String location;
//
//   const LocationWidget({Key? key, required this.location}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         height: 24,
//         width: double.infinity,
//         color: AppColor.approvedOrderTextColor.withOpacity(0.8),
//         child: Container(
//           padding: const EdgeInsetsDirectional.only(start: 12),
//           child: Row(
//             children: [
//               const CustomSvgIconWidget(
//                 IconPath.providerDetailsLocation,
//                 iconColor: AppColor.white,
//                 iconSize: 10,
//               ),
//               const CustomHorizontalSpace(width: 5),
//               CustomTextWidget(
//                 location,
//                 fontColor: AppColor.white,
//                 maxLines: 1,
//                 fontSize: 12,
//                 fontWeight: AppFontWeight.regular,
//               ),
//             ],
//           ),
//         ));
//   }
// }

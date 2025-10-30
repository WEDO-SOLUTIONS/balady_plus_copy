// import 'package:balady_plus/app/core/utils/utils_exports.dart';
// import 'package:balady_plus/app/features/vd/vd_exports.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';
//
// import '../../../../core/dependency_injection/injection_container.dart';
// import '../../../../core/utils/constants/constants.dart';
// import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
// import '../../../_shared_feature_/presentation/widgets/custom_shimmer_list_widget.dart';
// import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
// import '../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
// import '../../../_shared_feature_/presentation/widgets/reload_widget.dart';
// import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
//
// class VDTypesDialog extends StatefulWidget {
//   final bool? isFromHome;
//
//   VDTypesDialog({Key? key, this.isFromHome = false}) : super(key: key);
//
//   @override
//   State<VDTypesDialog> createState() => _VDTypesDialog();
// }
//
// class _VDTypesDialog extends State<VDTypesDialog> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => VDCategoryBloc(getCategories: sl()),
//       child: BlocConsumer<VDCategoryBloc, VDCategoryState>(
//         listener: (context, state) {
//           if (state.vdCategorystatus == BlocStatus.failure) {
//             CommonFunctions.showError(state.errorMessage ?? "");
//           }
//         },
//         builder: (context, state) {
//           return Container(
//             height: MediaQuery.of(context).size.height - 200,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // button, title,
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // title
//                     CustomTextWidget(
//                       ("vd_report_type").tr(),
//                       fontColor: AppColor.blackModern500Light,
//                       fontSize: 14.0,
//                     ),
//
//                     Constants.verticalSpaceSmall,
//                   ],
//                 ),
//                 if (state.vdCategorystatus == BlocStatus.loading)
//                   const Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.only(
//                           /* bottom: GeneralKey.mediumPadding,
//                         left: GeneralKey.semiMediumPadding,
//                         right: GeneralKey.semiMediumPadding,
//                         top: GeneralKey.smallPadding*/
//                           ),
//                       child: CustomShimmerGridViewWidget(
//                         height: 100,
//                         mainAxisExtent: 150,
//                       ),
//                     ),
//                   ),
//
//                 if (state.vdCategorystatus == BlocStatus.failure)
//                   Expanded(
//                     child: ReloadWidget(onTab: () {
//                       context.read<VDCategoryBloc>().add(GetAllCategories());
//                     }),
//                   ),
//                 if (state.vdCategorystatus == BlocStatus.success)
//                   // types
//                   Expanded(
//                     child: GridView.builder(
//                       physics: const BouncingScrollPhysics(),
//                       padding: const EdgeInsets.only(
//                           /*bottom: GeneralKey.mediumPadding,
//                           left: GeneralKey.semiMediumPadding,
//                           right: GeneralKey.semiMediumPadding,
//                           top: GeneralKey.smallPadding*/
//                           ),
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 2,
//                               crossAxisSpacing: 19.0,
//                               mainAxisSpacing: 18.0,
//                               mainAxisExtent: 150),
//                       itemCount: state.vdCategories?.length ?? 0,
//                       itemBuilder: (context, index) => VDCardWidgetInDialog(
//                           title: state.vdCategories?[index].categoryName ?? "",
//                           icon: state.vdCategories?[index].getMainImageUrl() ??
//                               "",
//                           btnPressed: () async {
//                             bool isLocationAvailable =
//                                 await CommonFunctions.checkLocationSettings(
//                                     context);
//                             bool isCameraAllowed =
//                                 await CommonFunctions.checkCameraSettings(
//                                     context);
//                             if (isLocationAvailable && isCameraAllowed) {
//                               context.read<VDCategoryBloc>().navigateToCamera(
//                                     index,
//                                     isVD: true,
//                                   );
//                             }
//                           }),
//                     ),
//                   )
//               ],
//             ),
//           );
//           return Container();
//         },
//       ),
//     );
//   }
// }
//
// class VDCardWidgetInDialog extends StatelessWidget {
//   final VoidCallback btnPressed;
//   final String title;
//   final String icon;
//
//   const VDCardWidgetInDialog(
//       {Key? key,
//       required this.title,
//       required this.icon,
//       required this.btnPressed})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomInkWellButtonWidget(
//       btnPressed: btnPressed,
//       widget: Container(
//         height: 150,
//         child: Stack(
//           children: [
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 decoration: BoxDecoration(
//                     boxShadow: [
//                       /* BoxShadow(
//                           color: Color(0x14000000),
//                           offset: Offset(0, 2),
//                           blurRadius: 5,
//                           spreadRadius: 0)*/
//                     ],
//                     borderRadius: BorderRadius.circular(16),
//                     color: Color(0xFFF5F8FA)),
//                 height: 150,
//               ),
//             ),
//             Align(
//               alignment: Alignment.topCenter,
//               child: Container(
//                 padding: EdgeInsets.only(left: 5, right: 5, top: 8),
//                 child: Column(
//                   children: [
//                     CustomCachedNetworkImage(
//                       icon,
//                       imageHeight: 88,
//                       imageFit: BoxFit.fitWidth,
//                       placeHolderWidget: Container(
//                         color: Colors.transparent,
//                         height: 96,
//                       ),
//                     ),
//                     CustomVerticalSpace(height: 10),
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: 5),
//                       child: CustomTextWidget(
//                         title,
//                         fontSize: 14,
//                         fontColor: AppColor.black,
//                         fontWeight: AppFontWeight.bold,
//                         maxLines: 2,
//                         height: 1.5,
//                         textOverflow: TextOverflow.ellipsis,
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

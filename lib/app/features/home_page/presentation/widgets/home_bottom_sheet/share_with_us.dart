// import 'package:flutter/material.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';
//
// import '../../../../../core/services/local/navigation_services.dart';
// import '../../../../../core/utils/constants/dialog_names.dart';
// import '../../../../../core/utils/utils_exports.dart'
//     show AppColor, AppStyle, ImagePath;
// import '../../../../_shared_feature_/presentation/widgets/custom_popups_widgets.dart';
// import '../../../../_shared_feature_/shared_feature_exports.dart'
//     show
//         BottomSheetDialog,
//         BottomSheetTitle,
//         BottomSheetWithActions,
//         CustomTextWidget,
//         ElevatedButtonWidget;
// import '../../../../vd/presentation/dialogs/vd_all_types_dialog.dart';
// import '../../../../vd/presentation/dialogs/vd_types_dialog.dart';
// import '../../../home_exports.dart' show HomeSection;
//
// class ShareWithUs extends StatelessWidget {
//   const ShareWithUs({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return HomeSection(
//       title: "shareWithUs".tr(),
//       child: Container(
//         height: 294,
//         padding: EdgeInsets.only(top: 60),
//         decoration: const BoxDecoration(
//           borderRadius: BorderRadius.all(Radius.circular(16)),
//           image: DecorationImage(
//             image: AssetImage(ImagePath.shareUsBg),
//             fit: BoxFit.fill,
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             CustomTextWidget(
//               "send_image".tr(),
//               textStyle: AppStyle.mainTextStyle.copyWith(
//                 color: AppColor.blackModern900Light,
//               ),
//             ),
//             const SizedBox(height: 12),
//             CustomTextWidget(
//               "sendImageHint".tr(),
//               textStyle: AppStyle.serviceDescriptionStyle,
//               maxLines: 2,
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 12),
//             ElevatedButtonWidget.sendImage(
//               onPressed: () async {
//                 await BottomSheetDialog.showDraggableSheet(context,
//                     dialogKeyName: DialogName.vdTypesDialog,
//                     currentRouteName: "HomePage",
//                     child: BottomSheetWithActions(
//                       title: "customerVoiceReportTypeWord".tr(),
//                       body: VDAllTypesScreen(),
//                     ));
//               },
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

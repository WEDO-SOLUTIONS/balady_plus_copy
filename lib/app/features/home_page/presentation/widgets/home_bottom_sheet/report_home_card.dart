// import 'package:flutter/material.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';
//
// import '../../../../../core/utils/constants/dialog_names.dart';
// import '../../../../../core/utils/utils_exports.dart';
// import '../../../../_shared_feature_/shared_feature_exports.dart';
// import '../../../../vd/presentation/dialogs/vd_all_types_dialog.dart';
// import '../../../../vd/presentation/dialogs/vd_types_dialog.dart';
//
// class ReportHomeCard extends StatelessWidget {
//   const ReportHomeCard({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () async {
//         await BottomSheetDialog.showDraggableSheet(context,
//             dialogKeyName: DialogName.vdTypesDialog,
//             currentRouteName: "HomePage",
//             child: BottomSheetWithActions(
//               title: "اختر نوع البلاغ".tr(),
//               body: VDAllTypesScreen(),
//             ));
//       },
//       child: Container(
//         height: 175,
//         width: MediaQuery.sizeOf(context).width,
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         margin: const EdgeInsets.only(left: 16, right: 16, top: 24),
//         decoration: const BoxDecoration(
//           borderRadius: BorderRadius.all(Radius.circular(16)),
//           image: DecorationImage(
//             image: AssetImage(ImagePath.reportBg),
//             fit: BoxFit.fill,
//           ),
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               flex: 3,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const CustomTextWidget(
//                     "صور وارسل",
//                     fontColor: AppColor.blackModern50Light,
//                     fontWeight: AppFontWeight.bold,
//                     fontSize: 14,
//                   ),
//                   const SizedBox(height: 6),
//                   const CustomTextWidget(
//                     "حسن المشهد الحضري لمدينتك، وبلغ عن مظاهر التشوه البصري",
//                     fontColor: AppColor.blackModern50Light,
//                     fontWeight: AppFontWeight.bold,
//                     fontSize: 12,
//                     maxLines: null,
//                     height: 1.5,
//                   ),
//                   const SizedBox(height: 12),
//                   CustomElevatedButtonWidget(
//                     btnColor: AppColor.secondary900Light,
//                     textStyle: AppStyle.elevatedButtonStyle.copyWith(
//                       color: AppColor.white,
//                       fontWeight: FontWeight.w700,
//                       fontSize: 12,
//                     ),
//                     btnHeight: 40,
//                     btnWidth: 157,
//                     text: "ارفع بلاغ",
//                     onPressed: () async {
//                       await BottomSheetDialog.showDraggableSheet(context,
//                           dialogKeyName: DialogName.vdTypesDialog,
//                           currentRouteName: "HomePage",
//                           child: BottomSheetWithActions(
//                             title: "اختر نوع البلاغ".tr(),
//                             body: VDAllTypesScreen(),
//                           ));
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             const Expanded(flex: 2, child: SizedBox()),
//           ],
//         ),
//       ),
//     );
//   }
// }

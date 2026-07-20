// import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
// import 'package:flutter/material.dart';
//
// import '../../../../../core/utils/utils_exports.dart'
//     show AppColor, AppStyle, IconPath;
// import '../../../../_shared_feature_/shared_feature_exports.dart'
//     show CustomTextWidget, DrawIconBasedTypeWidget;
// import '../../../home_exports.dart' show HomeTag;
//
// class ServiceCard extends StatelessWidget {
//   final ServiceEntity service;
//   final bool fullWidth;
//
//   const ServiceCard({
//     super.key,
//     required this.service,
//     this.fullWidth = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width - (fullWidth ? 32 : 80);
//     return Container(
//       width: width,
//       height: 100,
//       margin: const EdgeInsetsDirectional.only(top: 16, start: 16),
//       padding: const EdgeInsets.all(12),
//       decoration: const BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(16)),
//         /*boxShadow: [
//           BoxShadow(
//             color: AppColor.darkSlateBlue6,
//             offset: Offset(0, -4),
//             blurRadius: 32,
//           )
//         ],*/
//         color: AppColor.blackModern50Light,
//       ),
//       child: Stack(
//         children: [
//           if (service.tag != null)
//             Positioned.directional(
//               top: 0,
//               end: 0,
//               textDirection: TextDirection.rtl,
//               child: HomeTag(
//                 title: service.tag!,
//                 backgroundColor: AppColor.iceBlue,
//                 fontSize: 8.0,
//               ),
//             ),
//           Row(
//             children: [
//               DrawIconBasedTypeWidget(
//                 icon:
//                     "assets/icons/png/new_services/recover_veichle.webp", //service.image,
//                 iconSize: 68,
//               ),
//               const SizedBox(width: 16),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CustomTextWidget(
//                     service.title,
//                     textStyle: AppStyle.serviceTitleStyle,
//                   ),
//                   const SizedBox(height: 8),
//                   SizedBox(
//                     width: width - 110,
//                     child: Row(
//                       children: [
//                         CustomTextWidget(
//                           service.description ?? "",
//                           fontColor: AppColor.blackModern400Light,
//                           fontSize: 12,
//                           fontWeight: AppFontWeight.bold,
//                         ),
//                         const Spacer(),
//                         const DrawIconBasedTypeWidget(
//                           icon: Icons.arrow_forward,
//                           iconSize: 16,
//                           iconColor: AppColor.blackModern700Light,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:balady_plus/app/core/services/local/navigation_services.dart';
// import 'package:balady_plus/app/core/utils/utils_exports.dart';
// import 'package:balady_plus/app/features/_shared_feature_/balady_features/balady_exports.dart';
// import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_network_icon_widget.dart';
// import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_spaces_widgets.dart';
// import 'package:balady_uikit/core/typography/text_theme_styles.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// class EventItemCard extends StatelessWidget {
//   final SearchEventsItem item;
//   final double? width;
//   final EdgeInsets? padding;
//   final ValueChanged<SearchEventsItem>? onItemTap;
//
//   const EventItemCard({
//     super.key,
//     required this.item,
//     this.width,
//     this.padding,
//     this.onItemTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         onItemTap?.call(item);
//         NavigationService.navigatorKey.currentState!.pushNamed(
//           RouteName.eventsDetailsPage,
//           arguments: item.id,
//         );
//       },
//       child: Container(
//         height: 187,
//         margin: padding ?? const EdgeInsets.only(top: 16, left: 16, right: 16),
//         width: width ?? MediaQuery.of(context).size.width - 32,
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(8),
//           ),
//           alignment: AlignmentDirectional.bottomStart,
//           child: Stack(
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(14),
//                 child: CustomNetworkImageWidget(
//                   item.logoImage ?? "",
//                   imageWidth: MediaQuery.of(context).size.width,
//                   imageHeight: 200,
//                   placeHolderWidget: SvgPicture.asset(ImagePath.calendarBackground),
//                 ),
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(14),
//                   gradient: LinearGradient(
//                     begin: FractionalOffset.topCenter,
//                     end: FractionalOffset.bottomCenter,
//                     colors: [
//                       const Color(0x00000000),
//                       const Color(0xFF000000).withOpacity(0.8),
//                     ],
//                   ),
//                 ),
//               ),
//               Align(
//                 alignment: AlignmentDirectional.bottomStart,
//                 child: Container(
//                   padding: const EdgeInsetsDirectional.only(start: 24, bottom: 20),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Flexible(
//                         child: Text(
//                           item.eventName ?? "",
//                           textAlign: CommonFunctions.isAppAR ? TextAlign.right : TextAlign.left,
//                           maxLines: 2,
//                           style: Theme.of(context)
//                               .extension<ThemeTextStyles>()
//                               ?.heading2
//                               .copyWith(color: Colors.white, height: 1.5),
//                         ),
//                       ),
//                       Date(
//                         text: item.getDate(),
//                       ),
//                       const CustomVerticalSpace(height: 6),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           IconName(
//                             icon: IconPath.locationHomeEvents,
//                             name: item.city ?? "",
//                             color: const Color(0xFFE7E7E8),
//                           ),
//                           const CustomHorizontalSpace(width: 8),
//                           IconName(
//                             icon: IconPath.planetRingedHomeEvents,
//                             name: item.category ?? "",
//                             color: Colors.white,
//                           ),
//                           const CustomHorizontalSpace(width: 8),
//                           if (item.feesType != null && item.feesType!.isNotEmpty)
//                             IconName(
//                               icon: IconPath.tagHomeEvents,
//                               name: item.feesType!,
//                               color: Colors.white,
//                             ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class IconName extends StatelessWidget {
//   final String name;
//   final String icon;
//   final Color color;
//
//   const IconName({
//     super.key,
//     required this.name,
//     required this.icon,
//     required this.color,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         SvgPicture.asset(
//           icon,
//           width: 12,
//           colorFilter: const ColorFilter.mode(Color(0xCCFFFFFF), BlendMode.srcIn),
//         ),
//         const SizedBox(
//           width: 4,
//         ),
//         Text(
//           name,
//           style: Theme.of(context).extension<ThemeTextStyles>()?.footNote.copyWith(
//                 color: const Color(0xCCFFFFFF),
//               ),
//         ),
//       ],
//     );
//   }
// }
//
// class Date extends StatelessWidget {
//   final String text;
//   const Date({super.key, required this.text});
//
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       text,
//       style: Theme.of(context).extension<ThemeTextStyles>()?.footNote.copyWith(
//             color: const Color(0xCCFFFFFF),
//           ),
//     );
//   }
// }

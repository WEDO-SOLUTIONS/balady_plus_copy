// import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
// import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
//
// import 'package:localize_and_translate/localize_and_translate.dart';
// import 'package:provider/provider.dart';
//
// import '../../../../../core/utils/constants/constants.dart';
// import '../../../../../core/utils/utils_exports.dart' show AppColor, IconPath;
// import '../../../../home_page/presentation/pages/home_page.dart';
// import '../../../../home_page/presentation/widgets/home_app_bar/circle_icon.dart';
// import '../../../../map_page/presentation/dialogs/map_layer_dialog.dart';
// import '../../../../map_page/presentation/mvvm/layers_gis_view_model.dart';
// import '../../../../map_page/presentation/mvvm/map_view_model.dart';
// import '../../../shared_feature_exports.dart'
//     show
//         BottomSheetDialog,
//         BottomSheetWithActions,
//         DrawLineWidget,
//         GlowingScrollWidget;
// import 'package:localize_and_translate/localize_and_translate.dart';
//
// import '../../../../../core/utils/utils_exports.dart'
//     show AppColor, CommonProperties, IconPath, WeathherConditions;
// import 'package:balady_plus/app/features/home_page/home_exports.dart';
// import '../../../shared_feature_exports.dart'
//     show
//         CustomTextFieldWidget,
//         DrawIconBasedTypeWidget,
//         DrawLineWidget,
//         GlowingScrollWidget;
//
// class DraggableSheetCard extends StatefulWidget {
//   final double minSize;
//   final double maxSize;
//   final double initialChildSize;
//   final double? cornerRadius;
//   final List<Widget> children;
//
//   const DraggableSheetCard({
//     super.key,
//     required this.minSize,
//     required this.maxSize,
//     required this.initialChildSize,
//     this.cornerRadius,
//     required this.children,
//   });
//
//   @override
//   State<DraggableSheetCard> createState() => _DraggableSheetCardState();
// }
//
// class _DraggableSheetCardState extends State<DraggableSheetCard> {
//   @override
//   void initState() {
//     super.initState();
//
//     SchedulerBinding.instance.addPostFrameCallback((_) {
//       MapViewModel mapViewModel =
//           Provider.of<MapViewModel>(context, listen: false);
//
//       mapViewModel.draggableScrollableController
//           .jumpTo(mapViewModel.bottomSheetSizeFraction.value);
//       mapViewModel.bottomSheetSize.notifyListeners();
//
//       mapViewModel.draggableScrollableController.addListener(() {
//         mapViewModel.bottomSheetSize.value =
//             mapViewModel.draggableScrollableController.pixels;
//         mapViewModel.bottomSheetSize.notifyListeners();
//
//         mapViewModel.bottomSheetSizeFraction.value =
//             mapViewModel.draggableScrollableController.size;
//         mapViewModel.bottomSheetSizeFraction.notifyListeners();
//
//         if (mapViewModel.draggableScrollableController.size > 0.6) {
//         } else {
//         }
//       });
//     });
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     MapViewModel mapViewModel =
//         Provider.of<MapViewModel>(context, listen: false);
//
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(widget.cornerRadius ?? 36),
//             topRight: Radius.circular(widget.cornerRadius ?? 36),
//           ),
//           color: AppColor.white,
//           boxShadow: [
//             BoxShadow(
//               color: AppColor.blackModern900Light.withOpacity(0.1),
//               blurRadius: 8,
//               offset: const Offset(0, -4),
//             ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(widget.cornerRadius ?? 36),
//             topRight: Radius.circular(widget.cornerRadius ?? 36),
//           ),
//           child: DraggableScrollableSheet(
//             controller: mapViewModel.draggableScrollableController,
//             initialChildSize: widget.initialChildSize,
//             minChildSize: widget.minSize,
//             maxChildSize: widget.maxSize,
//             expand: false,
//             builder: (_, controller) => InkWell(
//               onTap: () {
//                 /* if (draggableScrollableController.size <= widget.minSize) {
//                   draggableScrollableController.animateTo(
//                     widget.maxSize,
//                     duration: const Duration(milliseconds: 500),
//                     curve: Curves.easeOutBack,
//                   );
//                 } else {
//                   draggableScrollableController.animateTo(
//                     widget.minSize,
//                     duration: const Duration(milliseconds: 500),
//                     curve: Curves.easeOutBack,
//                   );
//                   controller.jumpTo(0);
//                 }*/
//               },
//               child: GlowingScrollWidget(
//                 child: SingleChildScrollView(
//                   keyboardDismissBehavior:
//                       ScrollViewKeyboardDismissBehavior.onDrag,
//                   padding: EdgeInsets.zero,
//                   controller: controller,
//                   child: Column(
//                     children: widget.children,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
// }

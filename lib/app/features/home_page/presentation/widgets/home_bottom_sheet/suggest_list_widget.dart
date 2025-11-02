// import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
// import 'package:balady_plus/app/core/utils/constants/app_style.dart';
// import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
// import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/draw_icon_based_type_widget.dart';
// import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/need_login_widget.dart';
// import 'package:balady_plus/app/features/map_page/presentation/mvvm/map_view_model.dart';
// import 'package:balady_plus/app/features/map_page/presentation/mvvm/search_bottom_view_model.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';
// import 'package:provider/provider.dart';
//
// import '../../../../_shared_feature_/presentation/widgets/custom_shimmer_list_widget.dart';
//
// class SuggestListWidget extends StatelessWidget {
//   const SuggestListWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     SearchBottomViewModel searchBottomViewModel =
//         context.watch<SearchBottomViewModel>();
//     MapViewModel mapViewModel = context.watch<MapViewModel>();
//
//     return ValueListenableBuilder3(
//       first: searchBottomViewModel.suggestResultMessage,
//       second: searchBottomViewModel.isLoadingData,
//       third: searchBottomViewModel.showCategory,
//       builder: (context, listSuggest, isLoading, showCategory, child) {
//         if (listSuggest != null &&
//             listSuggest.suggests.isNotEmpty &&
//             !isLoading)
//           return ListView.builder(
//             shrinkWrap: true,
//             scrollDirection: Axis.vertical,
//             itemCount: listSuggest.suggests.length,
//             physics: const NeverScrollableScrollPhysics(),
//             padding: const EdgeInsets.only(top: 16),
//             itemBuilder: (context, index) {
//               return Column(
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       if (listSuggest.suggests[index]!.handler.objectHandler !=
//                           null) {
//                         mapViewModel.addOneMarkerWithMoveCamera(
//                           listSuggest.suggests[index]!.handler.objectHandler!
//                               .item.markerPosition!,
//                           listSuggest
//                               .suggests[index]!.handler.objectHandler!.item.id!,
//                         );
//                         searchFocusNode.unfocus();
//                         searchBottomViewModel.removeSuggestList();
//                         searchController.text = '';
//                         mapViewModel.setBottomSheetSize(.1);
//                         searchBottomViewModel.saveItemHistory(listSuggest
//                             .suggests[index]!.handler.objectHandler!);
//                       } else {
//                         mapViewModel.selectedCategory.value = null;
//                         searchController.text =
//                             listSuggest.suggests[index]!.title.text;
//                         mapViewModel.callSearch();
//                       }
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       child: Row(
//                         children: [
//                           const DrawIconBasedTypeWidget(
//                             icon: IconPath.searchSuggestIcon,
//                             iconSize: 20,
//                           ),
//                           const SizedBox(width: 16),
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 listSuggest.suggests[index]?.title.text ?? '',
//                                 style: AppStyle.textFieldTitleTextStyle,
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 listSuggest.suggests[index]?.subtitle.text ??
//                                     '',
//                                 style: AppStyle.requestNumberTextStle,
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const Divider(
//                     color: Color(0xffE6ECEE),
//                     height: 16,
//                     thickness: 1, //#
//                   ),
//                 ],
//               );
//             },
//           );
//
//         if (isLoading) return const CustomShimmerWidget();
//
//         /*if (showCategory)
//           return ValueListenableBuilder(
//             valueListenable: searchBottomViewModel.suggestResultMessageHistory,
//             builder: (BuildContext context, listSuggestHistory, Widget? child) {
//               return listSuggestHistory != null
//                   ? Container(
//                       padding: const EdgeInsets.all(16),
//                       margin: const EdgeInsets.all(16),
//                       decoration: ShapeDecoration(
//                           color: Color(0xA0E8EFF1),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(16),
//                           )),
//                       child: Column(
//                         children: listSuggestHistory.keys.map((key) {
//                           return Column(
//                             children: [
//                               InkWell(
//                                 onTap: () {
//                                   mapViewModel.addOneMarkerWithMoveCamera(
//                                     listSuggestHistory[key]!.markerPosition,
//                                     listSuggestHistory[key]!.id,
//                                   );
//                                   searchFocusNode.unfocus();
//                                   searchController.text = '';
//                                   mapViewModel.setBottomSheetSize(.1);
//                                   // searchBottomViewModel.saveItemHistory(listSuggest[key]);
//                                 },
//                                 child: Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 16),
//                                   child: Row(
//                                     children: [
//                                       const Icon(
//                                         Icons.access_time,
//                                         size: 20,
//                                         color: AppColor.primary600Light,
//                                       ),
//                                       const SizedBox(width: 16),
//                                       Expanded(
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               listSuggestHistory[key]?.title ??
//                                                   '',
//                                               style: AppStyle
//                                                   .textFieldTitleTextStyle,
//                                               maxLines: 3,
//                                             ),
//                                             const SizedBox(height: 8),
//                                             Text(
//                                               listSuggestHistory[key]
//                                                       ?.subtitle ??
//                                                   '',
//                                               style: AppStyle
//                                                   .requestNumberTextStle,
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               const Divider(
//                                 color: Color(0xffE6ECEE),
//                                 height: 16,
//                                 thickness: 1, //#
//                               ),
//                             ],
//                           );
//                         }).toList(),
//                       ),
//                     )
//                   : EmptyListWidget(
//                       title: "no_data".tr(),
//                       imgHeight: 0,
//                     );
//             },
//           );*/
//
//         return EmptyListWidget(
//           title: "no_data".tr(),
//           imgHeight: 0,
//         );
//       },
//     );
//   }
// }
//
// class ValueListenableBuilder3<A, B, C> extends StatelessWidget {
//   const ValueListenableBuilder3({
//     required this.first,
//     required this.second,
//     required this.third,
//     Key? key,
//     required this.builder,
//     this.child,
//   }) : super(key: key);
//
//   final ValueListenable<A> first;
//   final ValueListenable<B> second;
//   final ValueListenable<C> third;
//
//   final Widget? child;
//   final Widget Function(BuildContext context, A a, B b, C c, Widget? child)
//       builder;
//
//   @override
//   Widget build(BuildContext context) => ValueListenableBuilder<A>(
//         valueListenable: first,
//         builder: (_, a, __) {
//           return ValueListenableBuilder<B>(
//             valueListenable: second,
//             builder: (context, b, __) {
//               return ValueListenableBuilder<C>(
//                   valueListenable: third,
//                   builder: (_, c, __) {
//                     return builder(context, a, b, c, child);
//                   });
//             },
//           );
//         },
//       );
// }

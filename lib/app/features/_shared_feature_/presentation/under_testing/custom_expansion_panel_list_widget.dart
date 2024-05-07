// import 'package:expandable/expandable.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder, Cubit;

// import '../../../../core/utils/utils_exports.dart'
//     show AppColor, AppStyle, DIRECTION, DirectionConversion, UIHelper;
// import '../../shared_feature_exports.dart'
//     show CustomAutoSizeTextWidget, DrawIconBasedTypeWidget, ExpansionPanelInfo;

// class _ExpansionPanelCubit extends Cubit<int> {
//   final int initialIndex;
//   _ExpansionPanelCubit({required this.initialIndex}) : super(initialIndex);

//   void onChangeState(int panelIndex) => emit(panelIndex);
// }

// class CustomExpansionPanelListWidget extends StatefulWidget {
//   final List<ExpansionPanelInfo> children;
//   final void Function(int, bool)? expansionCallback;
//   const CustomExpansionPanelListWidget({
//     super.key,
//     required this.children,
//     this.expansionCallback,
//   });

//   @override
//   State<CustomExpansionPanelListWidget> createState() =>
//       _CustomExpansionPanelListWidgetState();
// }

// class _CustomExpansionPanelListWidgetState
//     extends State<CustomExpansionPanelListWidget> {
//   late List<ExpandableController> _controllers;

//   late List<ExpansionPanelInfo> _children;
//   late void Function(int, bool)? _expansionCallback;

//   late _ExpansionPanelCubit _panelCubit;

//   @override
//   void initState() {
//     super.initState();
//     _children = widget.children;
//     _expansionCallback = widget.expansionCallback;

//     _controllers = [];
//     for (var panel in _children) {
//       _controllers.add(ExpandableController(initialExpanded: panel.isExpanded));
//     }

//     _panelCubit = _ExpansionPanelCubit(
//       initialIndex: _children.indexWhere((panel) => panel.isExpanded),
//     );
//   }

//   @override
//   void dispose() {
//     for (var controller in _controllers) {
//       controller.dispose();
//     }
//     _panelCubit.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ExpandableTheme(
//       data: const ExpandableThemeData(
//         hasIcon: false,
//         useInkWell: false,
//         tapHeaderToExpand: false,
//         tapBodyToCollapse: false,
//         tapBodyToExpand: false,
//       ),
//       child: BlocBuilder<_ExpansionPanelCubit, int>(
//         bloc: _panelCubit,
//         builder: (_, panelIndex) => Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: List.generate(
//             _children.length,
//             (index) {
//               final expansionState = _controllers[index].expanded;
//               // panelIndex == index ? _controllers[index].expanded : false;
//               // final expansionState =
//               //     panelIndex == index ? _controllers[index].expanded : false;

//               return Container(
//                 width: _children[index].expansionWidth ?? double.infinity,
//                 // padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                 decoration: BoxDecoration(
//                   color: expansionState
//                       ? AppColor.gray
//                       : Theme.of(context).scaffoldBackgroundColor,
//                   border: _children[index].underline
//                       ? Border(
//                           bottom: expansionState
//                               ? contentBottomBorder
//                               : headerBottomBorder,
//                         )
//                       : null,
//                 ),
//                 child: ExpandablePanel(
//                   controller: _controllers[index],
//                   header: _children[index].header ??
//                       ListTile(
//                         contentPadding:
//                             _children[index].headerPadding ?? headerPadding,
//                         dense: true,
//                         horizontalTitleGap: 10.0,
//                         minLeadingWidth: 25.0,
//                         minVerticalPadding: 0.0,
//                         selectedColor: Colors.transparent,
//                         selectedTileColor: Colors.transparent,
//                         leading: _ExpansionLeadingWidget(
//                           expanded: expansionState,
//                           leading: _children[index].leading,
//                         ),
//                         title: _ExpansionTitleWidget(
//                           expanded: expansionState,
//                           title: _children[index].title,
//                         ),
//                         trailing: _ExpansionPanelArrowWidget(
//                           expanded: expansionState,
//                         ),
//                         onTap: () => onUpdatePanel(index),
//                       ),
//                   collapsed: const SizedBox(),
//                   expanded: Padding(
//                     padding: _children[index].expandedPadding ?? contentPadding,
//                     child: _children[index].body ?? const SizedBox(),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   EdgeInsets get headerPadding => const EdgeInsets.symmetric(
//         vertical: UIHelper.littlePadding,
//         horizontal: UIHelper.middlePadding + 2.0,
//       );

//   BorderSide get headerBottomBorder => BorderSide(
//         width: 1,
//         color: AppColor.gray.withOpacity(0.36),
//       );

//   EdgeInsets get contentPadding => const EdgeInsets.fromLTRB(
//         UIHelper.middlePadding + 2.0,
//         0.0,
//         UIHelper.middlePadding + 2.0,
//         UIHelper.smallPadding,
//       );

//   BorderSide get contentBottomBorder => const BorderSide(
//         width: 1.5,
//         color: AppColor.gray,
//       );

//   void onUpdatePanel(int index) {
//     for (int i = 0; i < _controllers.length; i++) {
//       final controller = _controllers[i];
//       if (i == index) {
//         controller.toggle();

//         final panelExpanded = controller.expanded;
//         _panelCubit.onChangeState(panelExpanded ? i : -1);
//         if (_expansionCallback != null) {
//           _expansionCallback!(i, panelExpanded);
//         }
//       } else {
//         controller.expanded = false;
//       }

//       if (_children[i].onExpansionChanged != null) {
//         _children[i].onExpansionChanged!(controller.expanded);
//       }
//     }
//   }
// }

// class _ExpansionLeadingWidget extends StatelessWidget {
//   final bool expanded;
//   final dynamic leading;
//   const _ExpansionLeadingWidget({
//     required this.expanded,
//     required this.leading,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return leading != null
//         ? Container(
//             width: 25.0,
//             height: 25.0,
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//               color: leadingBGColor,
//               borderRadius: BorderRadius.circular(8.0),
//             ),
//             child: leading is Widget
//                 ? leading
//                 : DrawIconBasedTypeWidget(
//                     icon: leading,
//                     iconSize: 16.0,
//                     iconColor: leadingColor,
//                   ),
//           )
//         : const SizedBox();
//   }

//   Color get leadingBGColor => expanded ? AppColor.blue : AppColor.white;
//   Color get leadingColor => expanded ? AppColor.black : AppColor.gray;
// }

// class _ExpansionTitleWidget extends StatelessWidget {
//   final String? title;
//   final bool expanded;

//   const _ExpansionTitleWidget({
//     required this.title,
//     required this.expanded,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return CustomAutoSizeTextWidget(
//       title ?? "",
//       textStyle: textStyle,
//       maxLines: 1,
//       textOverflow: TextOverflow.ellipsis,
//       textAlign: TextAlign.start,
//       minFontSize: 12.0,
//       // height: 1.3,
//     );
//   }

//   // double get titleWidth => leading == null
//   //     ? width - (25.0 + 10.0)
//   //     : width - (25.0 + 10.0 + 10.0 + 25.0);
//   TextStyle get textStyle => expanded
//       ? AppStyle.mainTextStyle
//       : AppStyle.mainTextThirdStyle.copyWith(
//           fontSize: 18.0,
//           color: AppColor.gray,
//         );
// }

// class _ExpansionPanelArrowWidget extends StatelessWidget {
//   final bool expanded;

//   const _ExpansionPanelArrowWidget({required this.expanded});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 25.0,
//       height: 25.0,
//       decoration: const BoxDecoration(
//         // color: expanded ? AppColor.mainDark : AppColor.mainTextThird,
//         shape: BoxShape.circle,
//       ),
//       child: Transform.rotate(
//         angle: angle,
//         child: Icon(Icons.arrow_back_ios_new, size: 14.0, color: iconColor),
//       ),
//     );
//   }

//   // because original arrow looks at the left,
//   // so, if expanded we need to rotate it by 90', otherwise rotate by 270'
//   double get angle =>
//       expanded ? DIRECTION.downward.rotate : DIRECTION.upward.rotate;
//   Color get iconColor => expanded ? AppColor.black : AppColor.gray;
// }

// /*

// BlocProvider<_ExpansionPanelCubit>(
//       create: (_) => _ExpansionPanelCubit(initialState: -1),
//       child: Builder(
//         builder: (context) {
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: List.generate(
//               children.length,
//               (index) => BlocBuilder<_ExpansionPanelCubit, int>(
//                 builder: (_, panelIndex) {
//                   final expansionState = index == panelIndex;
//                   return Container(
//                     width:
//                         children[index].expansionWidth ?? context.screenWidth,
//                     // padding: expandedPadding ??
//                     //     const EdgeInsets.symmetric(
//                     //       horizontal: UIHelper.semiMediumPadding,
//                     //       vertical: 8.0,
//                     //     ),
//                     decoration: BoxDecoration(
//                       color: expansionState
//                           ? AppColor.mainGrayDark2
//                           : Theme.of(context).scaffoldBackgroundColor,
//                       border: Border(bottom: border(expansionState)),
//                     ),
//                     child: LayoutBuilder(
//                       builder: (_, constraints) => SizedBox(
//                         width: constraints.maxWidth,
//                         child: Theme(
//                           data: ThemeData()
//                               .copyWith(dividerColor: Colors.transparent),
//                           child: ListTileTheme(
//                             contentPadding: EdgeInsets.zero,
//                             dense: true,
//                             horizontalTitleGap: 10.0,
//                             minLeadingWidth: 25.0,
//                             minVerticalPadding: 0.0,
//                             selectedColor: Colors.transparent,
//                             selectedTileColor: Colors.transparent,
//                             child: ExpansionTile(
//                               key: UniqueKey(),
//                               tilePadding: headerPadding,
//                               childrenPadding: contentPadding,
//                               backgroundColor: Colors.transparent,
//                               collapsedBackgroundColor: Colors.transparent,
//                               maintainState: children[index].keepState,
//                               initiallyExpanded: expansionState,
//                               leading: _ExpansionLeadingWidget(
//                                 expanded: expansionState,
//                                 leading: children[index].leading,
//                               ),
//                               title: _ExpansionTitleWidget(
//                                 expanded: expansionState,
//                                 title: children[index].title,
//                               ),
//                               trailing: _ExpansionPanelArrowWidget(
//                                 expanded: expansionState,
//                               ),
//                               children: [
//                                 children[index].body ?? const SizedBox()
//                               ],
//                               expandedCrossAxisAlignment:
//                                   CrossAxisAlignment.start,
//                               onExpansionChanged: (state) {
//                                 BlocProvider.of<_ExpansionPanelCubit>(context)
//                                     .onPanelChanged(index);
//                                 if (children[index].onExpansionChanged !=
//                                     null) {
//                                   children[index]
//                                       .onExpansionChanged!(expansionState);
//                                 }
//                                 if (expansionCallback != null) {
//                                   expansionCallback!(index, state);
//                                 }
//                               },
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           );
//         },
//       ),
//     )

// // return Accordion(
//     //   maxOpenSections: 1,
//     //   disableScrolling: true,
//     //   paddingListHorizontal: 0.0,
//     //   paddingListBottom: 0.0,
//     //   paddingListTop: 0.0,
//     //   children: List.generate(
//     //     children.length,
//     //     (index) => AccordionSection(
//     //       headerBackgroundColorOpened: AppColor.mainGrayDark2,
//     //       headerBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
//     //       headerBorderRadius: 0.0,
//     //       headerPadding: EdgeInsets.zero,
//     //       contentBorderColor: Theme.of(context).scaffoldBackgroundColor,
//     //       contentBackgroundColor: AppColor.mainGrayDark2,
//     //       contentBorderRadius: 0.0,
//     //       contentBorderWidth: 0.0,
//     //       contentHorizontalPadding: 0.0,
//     //       contentVerticalPadding: 0.0,
//     //       paddingBetweenClosedSections: 10.0,
//     //       paddingBetweenOpenSections: 0.0,
//     //       isOpen: children[index].isExpanded,
//     //       leftIcon: Container(
//     //         decoration: const BoxDecoration(
//     //             border: Border(bottom: BorderSide(color: Colors.red))),
//     //         child: _ExpansionLeadingWidget(
//     //           expanded: children[index].isExpanded,
//     //           leading: children[index].leading,
//     //         ),
//     //       ),
//     //       header: Container(
//     //         decoration: const BoxDecoration(
//     //             border: Border(bottom: BorderSide(color: Colors.red))),
//     //         child: _ExpansionTitleWidget(
//     //           expanded: children[index].isExpanded,
//     //           title: children[index].title,
//     //         ),
//     //       ),
//     //       content: Container(
//     //         padding: contentPadding,
//     //         decoration:
//     //             BoxDecoration(border: Border(bottom: contentBottomBorder)),
//     //         child: children[index].body,
//     //       ),
//     //       onOpenSection: () {
//     //         if (expansionCallback != null) expansionCallback!(index, true);
//     //         if (children[index].onExpansionChanged != null) {
//     //           children[index].onExpansionChanged!(true);
//     //         }
//     //       },
//     //       onCloseSection: () {
//     //         if (expansionCallback != null) expansionCallback!(index, false);
//     //         if (children[index].onExpansionChanged != null) {
//     //           children[index].onExpansionChanged!(false);
//     //         }
//     //       },
//     //     ),
//     //   ),
//     // );
// */

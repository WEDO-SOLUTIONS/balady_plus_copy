// import 'dart:async';
//
// import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
// import 'package:balady_plus/app/core/utils/constants/app_style.dart';
// import 'package:balady_plus/app/features/home_page/presentation/widgets/home_bottom_sheet/suggest_home_bottom_sheet.dart';
// import 'package:balady_plus/app/features/map_page/extensions/directory_object_ext.dart';
// import 'package:dgis_map/library.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../../core/utils/common_functions.dart';
// import '../../../../../core/utils/enums/bloc_status.dart';
// import '../../../../_shared_feature_/shared_feature_exports.dart';
// import '../../../../location/presentation/bloc/location_bloc.dart';
// import '../../../../map_page/presentation/mvvm/map_view_model.dart';
// import '../../../home_exports.dart'
//     show
//         BaladySmartAdvisorCard,
//         CertificationMapCard,
//         ChallengeHomeCard,
//         DraggableHeaderComponent,
//         NewServices,
//         PrayerHomeCard,
//         ReadHomeCard,
//         ReportHomeCard;
//
// import 'package:provider/provider.dart';
// import 'calendar_home_item_widget.dart';
// import 'cityscape_map_card.dart';
// import 'event_home_card.dart';
// import 'general_event_card.dart';
// import 'location_home_card.dart';
//
// class HomeBottomSheet extends StatelessWidget {
//   const HomeBottomSheet({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     MapViewModel mapViewModel = context.watch<MapViewModel?>()!;
//     return BlocListener<LocationCubit, LocationState>(listener:
//         (context, state) {
//       if (state.requestsStatus == BlocStatus.success) {
//         mapViewModel.moveCamera();
//       }
//     }, child:
//         BlocBuilder<LocationCubit, LocationState>(builder: (context, state) {
//       return ValueListenableBuilder<bool>(
//           valueListenable: mapViewModel.viewHomeBottomSheet,
//           builder: (_, visible, child) {
//             return visible ? child! : const SizedBox();
//           },
//           child: DraggableSheetCard(
//             minSize: 0.05,
//             maxSize: 0.9,
//             cornerRadius: 36,
//             initialChildSize: mapViewModel.bottomSheetSizeFraction.value,
//             children: [
//               const DraggableHeaderComponent(),
//               ValueListenableBuilder(
//                   valueListenable: mapViewModel.suggests,
//                   builder: (_, suggests, child) {
//                     if (suggests != null) {
//                       return SuggestHomeBottomSheet();
//                     }
//
//                     return Column(
//                       children: [
//                         if (CommonProperties.userLocation == null)
//                           const LocationHomeCard(),
//
//                         const CertificationMapCard(),
//                         const ReportHomeCard(),
//                         if (CommonProperties.userLocation != null)
//                           const PrayerHomeCard(),
//                         //    const ReadHomeCard(),
//                         // DeformityHomeCard(),
//                         BaladySmartAdvisorCard(),
//
//                         //GeneralEventHomeCard(),
//                         EventHomeCard(),
//                         //  CalendarHomeItemWidget(),
//
//                         //  ChallengeHomeCard(),
//                         const NewServices(),
//                         const SizedBox(height: 30),
//                       ],
//                     );
//                   })
//             ],
//           ));
//     }));
//   }
// }

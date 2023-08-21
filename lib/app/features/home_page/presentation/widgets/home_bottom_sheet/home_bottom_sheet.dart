import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/location/presentation/bloc/location_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/common_functions.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../../map_page/presentation/mvvm/map_view_model.dart';
import '../../../home_exports.dart'
    show
        BaladySmartAdvisorCard,
        CertificationMapCard,
        ChallengeHomeCard,
        DeformityHomeCard,
        DraggableHeaderComponent,
        NewServices,
        PrayerHomeCard,
        ReadHomeCard,
        ReportHomeCard;

import 'package:provider/provider.dart';

import 'location_home_card.dart';

class HomeBottomSheet extends StatelessWidget {
  const HomeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    MapViewModel mapViewModel = context.watch<MapViewModel?>()!;
    print("initial ${mapViewModel.bottomSheetSizeFraction.value}");
    return BlocListener<LocationCubit, LocationState>(
      listener: (context, state) {
        if (state.requestsStatus == BlocStatus.success) {
          mapViewModel.moveCamera();
        }
      },
      child: BlocBuilder<LocationCubit, LocationState>(
        builder: (context, state) {
          return ValueListenableBuilder<bool>(
              valueListenable: mapViewModel.viewHomeBottomSheet,
              builder: (_, visible, child) {
                print("initial ${mapViewModel.bottomSheetSizeFraction.value}");

                return visible ? child! : const SizedBox();
              },
              child: DraggableSheetCard(
                minSize: 0.05,
                maxSize: 0.9,
                cornerRadius: 36,
                initialChildSize: mapViewModel.bottomSheetSizeFraction.value,
                children: [
                  DraggableHeaderComponent(),
                  if (CommonProperties.userLocation == null) LocationHomeCard(),
                  CertificationMapCard(),
                  ReportHomeCard(),

                  // DeformityHomeCard(),
                  if (CommonProperties.userLocation != null) PrayerHomeCard(),
                  ReadHomeCard(),
                  //  BaladySmartAdvisorCard(),
                  //  ChallengeHomeCard(),
                  NewServices(),
                  SizedBox(height: 30),
                ],
              ));
        },
      ),
    );
  }
}

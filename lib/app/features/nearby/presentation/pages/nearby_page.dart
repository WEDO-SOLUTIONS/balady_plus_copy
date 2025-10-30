import 'package:balady_plus/app/features/map_page/presentation/mvvm/map_view_model.dart';
import 'package:balady_plus/app/features/nearby/presentation/mvvm/nearby_view_model.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;
import 'package:provider/provider.dart';

import '../../../../core/utils/utils_exports.dart' show AppColor, IconPath;
import '../../../_shared_feature_/shared_feature_exports.dart'
    show DefaultAppBarWidget, TabPageContainer;
import '../../../home_page/home_exports.dart';
import '../../nearby_exports.dart' show NearbyGrid, NearbyTagList;

class NearbyPage extends StatelessWidget {
  const NearbyPage({super.key});

  @override
  Widget build(BuildContext context) {
    MapViewModel mapViewModel = context.watch<MapViewModel>();
    return ChangeNotifierProvider(
      create: (BuildContext context) =>
          NearByViewModel(mapViewModel.controller),
      child: Scaffold(
        appBar: DefaultAppBarWidget(
          title: "nearby".tr(),
          bottom: const NearbyTagList(),
          actions: const [
            /*   Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: CircleIcon(
                backgroundColor: AppColor.primary50Light,
                icon: IconPath.filter,
                circleSize: 48.0,
                iconSize: 30.0,
              ),
            ),*/
          ],
        ),
        body: const TabPageContainer(
          child: NearbyGrid(),
        ),
      ),
    );
  }
}

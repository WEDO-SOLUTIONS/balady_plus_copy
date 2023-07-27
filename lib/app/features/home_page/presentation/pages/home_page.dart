import 'package:balady_plus/app/features/map_page/presentation/mvvm/layers_gis_view_model.dart';
import 'package:balady_plus/app/features/map_page/presentation/mvvm/map_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../_shared_feature_/shared_feature_exports.dart'
    show TabPageContainer;
import '../../home_exports.dart' show HomeBottomSheet, HomeMap;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    MapViewModel mapViewModel = context.watch<MapViewModel?>()!;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => LayersGisViewModel(
            layersRepositories: sl(),
            mapViewModel: mapViewModel,
          ),
        )
      ],
      child: Scaffold(
        body: TabPageContainer(
          child: Stack(
            children: [
              const HomeMap(),
              ValueListenableBuilder<bool>(
                valueListenable: mapViewModel.viewHomeBottomSheet,
                builder: (_, visible, child) {
                  return visible ? child! : const SizedBox();
                },
                child: const HomeBottomSheet(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

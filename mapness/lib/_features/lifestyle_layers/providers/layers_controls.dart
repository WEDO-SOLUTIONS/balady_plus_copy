import 'package:dgis_map/library.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/favourites/providers/favourite_markers.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'layers_controls.g.dart';

enum LayerType { favourites, invest, buildings, fencing, joy }

extension LayerTypeExt on LayerType {
  void onTap(WidgetRef ref) async {
    switch (this) {
      case LayerType.favourites:
        {
          ref.read(favouriteToggleProvider.notifier).toggle();
        }
      case LayerType.invest:
        {
          // final provider = ref.watch(layersControlsProvider);
          //
          // final controller = ref.watch(lifestyleRepositoryProvider.notifier);
          // await controller.test(provider.vr);
        }
      case LayerType.buildings:
        {}
      case LayerType.fencing:
        {}
      case LayerType.joy:
        {
          final dgisController = await ref.read(dgisControllerProvider.future);
          await dgisController.searchByRubrics(
            [168],
            sortingType: SortingTypeMessage.byRelevance,
          );
        }
    }
  }

  String iconPath() {
    return switch (this) {
      LayerType.favourites => "assets/icons/svg/ic_fav.svg",
      LayerType.invest => "assets/icons/svg/layers/Invest.svg",
      LayerType.buildings => "assets/icons/svg/layers/buildings.svg",
      LayerType.fencing => "assets/icons/svg/layers/fence.svg",
      LayerType.joy => "assets/icons/svg/layers/joy.svg",
    };
  }

  String title(AppLocalizations l10n) {
    return switch (this) {
      LayerType.favourites => l10n.favourites,
      LayerType.invest => l10n.investmentOpportunities,
      LayerType.buildings => l10n.compilanceBuildings,
      LayerType.fencing => l10n.fencingVacantLands,
      LayerType.joy => l10n.joyParks,
    };
  }
}

class LayersVisibleState {
  final bool layersVisible;
  LayerType? selectedType;
  VisibleRect? vr;

  LayersVisibleState({
    required this.layersVisible,
    this.selectedType,
    this.vr,
  });
}

@riverpod
class LayersControls extends _$LayersControls {
  @override
  LayersVisibleState build() {
    //   final dgisController = ref.watch(dgisControllerProvider);
    //   final visibleRectSubscription =
    //       dgisController?.visibleRectEvents.listen((event) {
    //     state = LayersVisibleState(
    //       layersVisible: state.layersVisible,
    //       selectedType: state.selectedType,
    //       vr: event.visibleRect,
    //     );
    //   });
    //
    return LayersVisibleState(layersVisible: false, selectedType: null);
  }

  void update({bool? visible, LayerType? selectedType}) =>
      state = LayersVisibleState(
          layersVisible: visible ?? state.layersVisible,
          selectedType: selectedType,
          vr: state.vr);

  void setSelected(LayerType value) {
    state = LayersVisibleState(
      vr: state.vr,
      layersVisible: state.layersVisible,
      selectedType: state.selectedType == value ? null : value,
    );
  }
}

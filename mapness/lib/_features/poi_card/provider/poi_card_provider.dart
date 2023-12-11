import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'poi_card_provider.g.dart';

class PoiCardState {
  bool isLoading;
  bool showEntrances;
  final DirectoryObjectMessage? gisObjectIdMessage;

  PoiCardState({
    required this.showEntrances,
    required this.isLoading,
    required this.gisObjectIdMessage,
  });

  PoiCardState copy(
      {bool? showEntrances,
      bool? isLoading,
        DirectoryObjectMessage? gisObjectIdMessage}) {
    return PoiCardState(
      showEntrances: showEntrances ?? this.showEntrances,
      isLoading: isLoading ?? this.isLoading,
      gisObjectIdMessage: gisObjectIdMessage ?? this.gisObjectIdMessage,
    );
  }
}

@riverpod
class PoiCardProvider extends _$PoiCardProvider {
  @override
  PoiCardState build() {
    return PoiCardState(
      isLoading: true,
      showEntrances: false,
      gisObjectIdMessage: null,
    );
  }

  void update({bool? showEntrances}) {
    state = state.copy(
      showEntrances: showEntrances,
    );
  }

  Future<void> onLoad(DgisObjectIdMessage object) async {
    final directoryObjectMessage = await ref.watch(
      pointOfInterestProvider(object).future
    );

      state = state.copy(
        gisObjectIdMessage: directoryObjectMessage
      );
  }

  void showEntrances() {
    // setState(() {
    //   showEntrances = !showEntrances;
    // });
    //
    // final highlightController = ref.read(highlightProvider.notifier);
    //
    // if (showEntrances) {
    //   for (var entrance in data.entrances) {
    //     highlightController.addHighlight(entrance!.id);
    //   }
    // } else {
    //   for (var entrance in data.entrances) {
    //     highlightController.removeHighlight(entrance!.id);
    //   }
    // }
  }
}

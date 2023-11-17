import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/_features/favourites/providers/favourite_repository.dart';
import 'package:mapness/_features/happiness_map/domain/happiness_feedback.dart';
import 'package:mapness/_features/landing/providers/map_controls.dart';
import 'package:mapness/_features/map/providers/point_of_interest.dart';
import 'package:mapness/_features/poi_card/enums/contacts_info_type.dart';
import 'package:mapness/_features/poi_card/extensions/directory_message_ext.dart';
import 'package:url_launcher/url_launcher.dart';

class PoiCardViewModel {
  final WidgetRef ref;

  PoiCardViewModel({
    required this.ref,
  });

  void addToFavourites(DirectoryObjectMessage? dataPoint) {
    ref.read(favouriteRepositoryProvider.notifier).addItem(
          FavouriteItem(
            coordinates: Coordinates(
              latitude: dataPoint?.markerPosition?.latitude ?? 24.712301,
              longitude: dataPoint?.markerPosition?.longitude ?? 46.674175,
            ),
            id: '${dataPoint?.id?.objectId ?? 'id'}',
            subtitle: dataPoint?.subtitle ?? '',
            title: dataPoint?.title ?? '',
            entity: FavouriteItemEntity(
              id: '${dataPoint?.id?.objectId ?? '70030076201324251'}',
              sourceType: EntitySourceType.urbi,
            ),
          ),
        );
  }

  void onError() => Future(
        () => ref
            .watch(mapControlsProvider.notifier)
            .update(MapControlsStateIdle()),
      );

  void openMap(DirectoryObjectMessage? data) {}

  void onEntranceTap() {}

  void share() {}

  void sendEmail(String value) {}

  Future<void> launch(String value) async {
    var url = Uri.parse(value);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.inAppWebView);
    }
  }

  Future<void> callPhone({
    DirectoryObjectMessage? data,
  }) async {
    final phoneNumber = data?.getContactsInfoModels().firstWhereOrNull(
          (element) => element.type == ContactsInfoType.phone,
        );
    final value = phoneNumber?.value;
    if (value != null) {
      await launchUrl(Uri(scheme: 'tel', path: value));
    }
  }

  FavouriteItem? getIsFavourite(PoiModel data) {
    final favouritesState = ref.watch(favouriteRepositoryProvider).requireValue;

    final isFavourite = favouritesState.items.firstWhereOrNull(
      (element) {
        var objectId = data.directoryObjectMessage?.id?.objectId;
        return element.entity?.id == '$objectId';
      },
    );
    return isFavourite;
  }
}

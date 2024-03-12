import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/favourites/domain/extensions/extensions.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/_features/favourites/providers/favourite_repository.dart';
import 'package:mapness/_features/happiness_map/domain/happiness_feedback.dart';
import 'package:mapness/_features/poi_card/extensions/geopoint_mapper.dart';
import 'package:mapness/_features/poi_card/poi_card_view_model.dart';
import 'package:mapness/_features/poi_card/widgets/footer/footer_style.dart';
import 'package:mapness/_features/poi_card/widgets/poi_favorite_dialog.dart';
import 'package:mapness/app/routes/routing.dart';
import 'package:mapness/features/routing/ui/brief_route_widgets.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';

part 'widgets/phone_item.dart';
part 'widgets/entrance_item.dart';
part 'widgets/car_item.dart';
part 'widgets/share_item.dart';
part 'widgets/favourite_item.dart';
part 'widgets/wrapper.dart';

class PoiCardFooter2 extends ConsumerWidget {
  PoiCardFooter2({
    required this.data,
    required this.viewModel,
    required this.onEntranceTap,
    super.key,
  }) {
    _finishPoint = RouteSearchPointMessage(
      coordinates: data.markerPosition!.toGeoPointMessage(),
      objectId: data.id!,
    );
  }
  final DirectoryObjectMessage data;
  final PoiCardViewModel viewModel;
  final void Function() onEntranceTap;
  late final RouteSearchPointMessage _finishPoint;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = PoiModel(directoryObjectMessage: data);

    final objectMessage = model.directoryObjectMessage;
    final hasEntrances = objectMessage?.entrances.isNotEmpty == true;
    final hasContacts = objectMessage?.contactInfos.isNotEmpty == true;
    final carIconFlex = (hasEntrances || hasContacts) ? 3 : 2;

    /// redraw footer if fav repo changes. Do not remove, entail bug with multi fav add!

    final hasContactsAndHasEntrances = hasContacts && hasEntrances;

    if (hasContactsAndHasEntrances) {
      return _Wrapper(
        children: [
          _FavouriveItem(
            objectMessage: data,
            objectId: model.directoryObjectMessage?.id?.objectId,
          ),
          _ShareItem(
            hasContactsAndHasEntrances: hasContactsAndHasEntrances,
            flex: 2,
            onTap: () => viewModel.share(objectMessage),
          ),
          _CarItem(
            finishPoint: _finishPoint,
            objectMessage: objectMessage,
            flex: 2,
          ),
        ],
      );
    }

    return _Wrapper(
      children: [
        _ShareItem(
          hasContactsAndHasEntrances: hasContactsAndHasEntrances,
          flex: 2,
          onTap: () => viewModel.share(objectMessage),
        ),
        if (hasEntrances)
          _EntranceItem(
            hasEntrances: hasEntrances,
            onEntranceTap: onEntranceTap,
          ),
        if (hasContacts)
          _PhoneItem(
            hasContacts: hasContacts,
            flex: 2,
            onTap: () => viewModel.callPhone(data: objectMessage),
          ),
        _FavouriveItem(
          objectMessage: data,
          objectId: model.directoryObjectMessage?.id?.objectId,
        ),
        _CarItem(
          finishPoint: _finishPoint,
          objectMessage: objectMessage,
          flex: carIconFlex,
        ),
      ],
    );
  }
}

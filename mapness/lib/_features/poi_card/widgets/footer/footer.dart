import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/favourites/domain/extensions/extensions.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/_features/favourites/providers/favourite_cache.dart';
import 'package:mapness/_features/happiness_map/domain/happiness_feedback.dart';
import 'package:mapness/_features/poi_card/extensions/geopoint_mapper.dart';
import 'package:mapness/_features/poi_card/widgets/footer/footer_style.dart';
import 'package:mapness/_features/poi_card/widgets/poi_favorite_dialog.dart';
import 'package:mapness/app/routes/routing.dart';
import 'package:mapness/features/routing/ui/brief_route_widgets.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';

part 'widgets/phone_item.dart';
part 'widgets/entrance_item.dart';
part 'widgets/car_item.dart';
part 'widgets/share_item.dart';
part 'widgets/favorite_item.dart';
part 'widgets/wrapper.dart';

class PoiCardFooter2 extends ConsumerWidget {
  final DirectoryObjectMessage data;
  final void Function() share;
  final void Function() callPhone;
  final void Function() onEntranceTap;
  late final RouteSearchPointMessage _finishPoint;

  PoiCardFooter2({
    required this.data,
    required this.share,
    required this.callPhone,
    required this.onEntranceTap,
    super.key,
  }) {
    _finishPoint = RouteSearchPointMessage(
      coordinates: data.markerPosition!.toGeoPointMessage(),
      objectId: data.id!,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final objectId = data.id?.objectId;

    final hasEntrances = data.entrances.isNotEmpty == true;
    final hasContacts = data.contactInfos.isNotEmpty == true;
    final hasContactsAndHasEntrances = hasContacts && hasEntrances;

    if (hasContactsAndHasEntrances) {
      return _Wrapper(
        children: [
          _FavoriteItem(
            objectMessage: data,
            objectId: objectId,
          ),
          _ShareItem(
            hasContactsAndHasEntrances: hasContactsAndHasEntrances,
            flex: 2,
            onTap: share,
          ),
          _CarItem(
            finishPoint: _finishPoint,
            objectMessage: data,
            flex: 2,
          ),
        ],
      );
    }

    final carIconFlex = (hasEntrances || hasContacts) ? 3 : 2;
    return _Wrapper(
      children: [
        _ShareItem(
          hasContactsAndHasEntrances: hasContactsAndHasEntrances,
          flex: 2,
          onTap: share,
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
            onTap: callPhone,
          ),
        _FavoriteItem(
          objectMessage: data,
          objectId: objectId,
        ),
        _CarItem(
          finishPoint: _finishPoint,
          objectMessage: data,
          flex: carIconFlex,
        ),
      ],
    );
  }
}

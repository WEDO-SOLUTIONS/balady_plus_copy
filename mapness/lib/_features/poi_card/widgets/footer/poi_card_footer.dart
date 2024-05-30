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
import 'package:mapness/entities/routing/route_search_point.dart';
import 'package:mapness/features/routing/ui/brief_route_widgets.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';

part 'widgets/car_item.dart';
part 'widgets/entrance_item.dart';
part 'widgets/favorite_item.dart';
part 'widgets/phone_item.dart';
part 'widgets/share_item.dart';
part 'widgets/wrapper.dart';

class PoiCardFooter extends ConsumerWidget {
  final DirectoryObjectMessage data;
  final VoidCallback share;
  final VoidCallback callPhone;
  final VoidCallback onEntranceTap;
  final RouteSearchPoint finishPoint;

  PoiCardFooter({
    required this.data,
    required this.share,
    required this.callPhone,
    required this.onEntranceTap,
    super.key,
  }) : finishPoint = RouteSearchPoint(
          coordinates: data.markerPosition!.toGeoPointMessage(),
          dgisObjectId: data.id!,
        );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final objectId = data.id?.objectId;

    final hasEntrances = data.entrances.isNotEmpty == true;
    final hasContacts = data.contactInfos.isNotEmpty == true;
    final hasContactsAndHasEntrances = hasContacts && hasEntrances;

    if (hasContactsAndHasEntrances) {
      return _Wrapper(
        children: [
          _CarItem(
            finishPoint: finishPoint,
            objectMessage: data,
            flex: 2,
          ),
          _FavoriteItem(
            objectMessage: data,
            objectId: objectId,
          ),
          _ShareItem(
            hasContactsAndHasEntrances: hasContactsAndHasEntrances,
            flex: 2,
            onTap: share,
          ),
        ],
      );
    }

    final carIconFlex = (hasEntrances || hasContacts) ? 3 : 2;
    return _Wrapper(
      children: [
        _CarItem(
          finishPoint: finishPoint,
          objectMessage: data,
          flex: carIconFlex,
        ),
        if (hasContacts)
        _PhoneItem(
          hasContacts: true,
          flex: 2,
          onTap: callPhone,
        ),
        if (hasEntrances)
          _EntranceItem(
            hasEntrances: true,
            onEntranceTap: onEntranceTap,
          ),
        _FavoriteItem(
          objectMessage: data,
          objectId: objectId,
        ),
        _ShareItem(
          hasContactsAndHasEntrances: hasContactsAndHasEntrances,
          flex: 2,
          onTap: share,
        ),
      ],
    );
  }
}

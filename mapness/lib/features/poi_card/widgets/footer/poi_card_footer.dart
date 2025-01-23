import 'package:balady_uikit/balady_uikit.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/_features/favourites/providers/favourite_cache.dart';
import 'package:mapness/entities/routing/route_search_point.dart';
import 'package:mapness/features/poi_card/enums/poi_card_bottom_sheet_state.dart';
import 'package:mapness/features/poi_card/extensions/geopoint_mapper.dart';
import 'package:mapness/shared/extensions/brief_route_info_message_ext.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/map/find_brief_route_info.dart';
import 'package:mapness/widgets/helpers/throttled_callback_widget.dart';

class PoiCardFooter extends ConsumerStatefulWidget {
  static const double height = 40;
  static const double padding = 8;

  final DirectoryObjectMessage data;
  final VoidCallback share;
  final VoidCallback callPhone;
  final VoidCallback onEntranceTap;
  final VoidCallback onTapCar;
  final void Function(FavouriteItem? favouriteItem) onTapFavorite;
  final RouteSearchPoint finishPoint;
  final StatefulBottomSheetController<PoiCardBottomSheetState> bottomSheetController;

  PoiCardFooter({
    required this.data,
    required this.share,
    required this.callPhone,
    required this.onEntranceTap,
    required this.onTapCar,
    required this.onTapFavorite,
    required this.bottomSheetController,
    super.key,
  }) : finishPoint = RouteSearchPoint(
          coordinates: data.markerPosition!.toGeoPointMessage(),
          dgisObjectId: data.id!,
        );

  @override
  ConsumerState<PoiCardFooter> createState() => _PoiCardFooterState();
}

class _PoiCardFooterState extends ConsumerState<PoiCardFooter> {
  bool displayShadow = true;

  @override
  void initState() {
    super.initState();
    widget.bottomSheetController.addListener(updateShadow);
  }

  @override
  void didUpdateWidget(covariant PoiCardFooter oldWidget) {
    if (widget.bottomSheetController != oldWidget.bottomSheetController) {
      oldWidget.bottomSheetController.removeListener(updateShadow);
      widget.bottomSheetController.addListener(updateShadow);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.bottomSheetController.removeListener(updateShadow);
    super.dispose();
  }

  void updateShadow() {
    final isHidden = widget.bottomSheetController.state == PoiCardBottomSheetState.hidden &&
        widget.bottomSheetController.interpolation == 0.0;
    if (!isHidden != displayShadow) {
      setState(() {
        displayShadow = !isHidden;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final briefInfo = ref.watch(
      briefRouteInfoProvider(
        finishPoint: widget.finishPoint,
        navType: RouteSearchOptionsMessage.car,
      ),
    );

    final objectId = widget.data.id?.objectId;

    ref.watch(favouriteCacheProvider).valueOrNull;
    final provider = ref.watch(favouriteCacheProvider.notifier);
    final isFavourite = objectId != null && provider.isFavourite(objectId);
    final favouriteItem = objectId != null ? provider.getFavouriteOrNull(objectId) : null;
    final iconData = isFavourite ? SystemIcons.bookmarkFill : SystemIcons.bookmark;

    final hasEntrances = widget.data.entrances.isNotEmpty == true;
    final hasContacts = widget.data.contactInfos.isNotEmpty == true;
    final hasContactsAndHasEntrances = hasContacts && hasEntrances;

    return ThrottledCallbackWidget(
      callback: widget.share,
      builder: (context, throttledShare) => BottomActionBar(
        displayShadow: displayShadow,
        items: [
          ItemActionBar(
            icon: TransportIcons.car,
            buttonType: BaladyButtonType.primary,
            label: hasContactsAndHasEntrances
                ? null
                : briefInfo?.firstOrNull?.getBriefRouteDescription(context.l10n) ?? '',
            onPressed: widget.onTapCar,
          ),
          if (hasContactsAndHasEntrances)
            ItemActionBar(
              icon: GeneralIcons.phoneLTR,
              buttonType: BaladyButtonType.secondary,
              label: hasContactsAndHasEntrances ? null : context.l10n.call,
              onPressed: widget.callPhone,
            ),
          if (hasEntrances)
            ItemActionBar(
              icon: SystemIcons.turnRight,
              buttonType: BaladyButtonType.secondary,
              onPressed: widget.onEntranceTap,
            ),
          ItemActionBar(
            icon: iconData,
            buttonType: BaladyButtonType.secondary,
            label: hasContactsAndHasEntrances ? null : context.l10n.save,
            onPressed: () => widget.onTapFavorite(favouriteItem),
          ),
          ItemActionBar(
            icon: SystemIcons.share,
            buttonType: BaladyButtonType.secondary,
            label: hasContactsAndHasEntrances ? null : context.l10n.share,
            onPressed: throttledShare,
          ),
        ],
      ),
    );
  }
}

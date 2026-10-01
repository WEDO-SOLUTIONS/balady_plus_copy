import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/features/app_analytics/models/datafinder_models.dart';
import 'package:mapness/features/city_event/active_city_event.dart';
import 'package:mapness/features/favorite_lists/providers/favorite_list_membership.dart';
import 'package:mapness/features/poi_card/domain/model/poi_content/src/poi_content_contacts.dart';
import 'package:mapness/features/poi_card/enums/contacts_info_type.dart';
import 'package:mapness/features/poi_card/extensions/poi_content/src/poi_content_contacts.dart';
import 'package:mapness/features/poi_card/provider/poi_card_actions_provider.dart';
import 'package:mapness/features/poi_card/widgets/poi_content/src/poi_content_contacts_card.dart';
import 'package:mapness/features/poi_card/widgets/phone_picker_sheet.dart';
import 'package:mapness/pages/poi_card/poi_card_widget_page.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/auth/auth_methods.dart';
import 'package:mapness/shared/providers/analytic/bss_service.dart';
import 'package:mapness/shared/providers/analytic/extension/bss_ext.dart';
import 'package:mapness/shared/providers/analytic/models/payload/bss_payload.dart';
import 'package:mapness/shared/ui/lifestyle_action_bar_style.dart';
import 'package:mapness/widgets/helpers/throttled_callback_widget.dart';
import 'package:mapness/features/special_themes/core/special_theme_mode.dart';

class SearchItemQuickActions extends HookConsumerWidget {
  final DirectoryObjectMessage directoryObject;

  /// DataFinder: reports a `search_results_click` with the matching action.
  final void Function(DataFinderClickAction action)? onResultAction;

  const SearchItemQuickActions({
    required this.directoryObject,
    this.onResultAction,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final objectId = directoryObject.id?.objectId;
    final isDGADark = context.read<ThemeController>().currentTheme == BaladyAppThemes.darkDGA;
    final isDGAlight = context.read<ThemeController>().currentTheme == BaladyAppThemes.lightDGA;

    final isFavourite = objectId != null && ref.watch(isPlaceFavoritedProvider(objectId.toString()));
    // todo(claude): set icon state instead of other icon
    final iconData = isFavourite ? SystemIcons.bookmarkFill : SystemIcons.bookmark;

    final poiActions = ref.read(poiCardActionsProvider.notifier);

    final phoneNumbers = directoryObject.getContactsInfoModels
        .where((e) => e.type == ContactsInfoType.phone && e.value != null)
        .toList();

    final website = directoryObject.getContactsInfoModels
        .firstWhereOrNull(
          (element) => element.type == ContactsInfoType.website,
        )
        ?.value;

    final socialMedia = directoryObject.contactInfos
        .map((e) {
          final type = ContactsInfoTypeExt.fromString(e.type);
          final v = type.poiContentSocialMediaType;
          if (v != null) {
            return PoiContentSocialMediaModel(type: v, link: e.value);
          }
          return null;
        })
        .nonNulls
        .toList()
        .firstOrNull;
    final isFoundingDay = ref.watch(activeCityEventProvider)?.isFoundingDay ?? false;
    final specialThemeMode = ref.watch(specialThemeModeProvider);
    final bool isBaseTheme = specialThemeMode == SpecialThemeMode.base || specialThemeMode == SpecialThemeMode.base;
    final useLifestyleStyle = !isFoundingDay;
    final lifestyleStyle = useLifestyleStyle ? LifestyleActionBarStyle.of(context) : null;
    final colorScheme = isFoundingDay ? ButtonColorScheme.accent : ButtonColorScheme.accentSecondary;

    final actions = [
      if (lifestyleStyle != null)
        lifestyleStyle.directions(
          context: context,
          onPressed: () {
            onResultAction?.call(DataFinderClickAction.initiateNavigation);
            BssService.instance.trackRouteTap(directoryObject);
            openRoutingRoutes(
              context,
              directoryObject.id!.objectId,
              directoryObject.title,
              RouteParamsPoint(
                latitude: directoryObject.markerPosition!.latitude,
                longitude: directoryObject.markerPosition!.longitude,
                objectId: directoryObject.id?.objectId,
                entranceId: directoryObject.id?.entranceId,
                levelId: directoryObject.levelId,
              ),
              ref,
            );
          },
        )
      else
        ItemActionBar(
          icon: TransportIcons.locationDirectionNavigator,
          buttonType: ButtonType.secondary,
          border: isBaseTheme ? BorderSide(color: context.colors.borderDefault) : null,
          borderRadius: 4,
          colorScheme: colorScheme,
          iconSize: 15,
          bgColor: context.colors.staticTiffany,
          labelColor: context.colors.accentSecondaryOnAccentSecondary,
          iconColor: context.colors.accentSecondaryOnAccentSecondary,
          label: context.l10n.poiCardDirections,
          innerPadding: const EdgeInsets.symmetric(vertical: Spacing.$2x, horizontal: Spacing.$3x),
          onPressed: () {
            onResultAction?.call(DataFinderClickAction.initiateNavigation);
            BssService.instance.trackRouteTap(directoryObject);
            openRoutingRoutes(
              context,
              directoryObject.id!.objectId,
              directoryObject.title,
              RouteParamsPoint(
                latitude: directoryObject.markerPosition!.latitude,
                longitude: directoryObject.markerPosition!.longitude,
                objectId: directoryObject.id?.objectId,
                entranceId: directoryObject.id?.entranceId,
                levelId: directoryObject.levelId,
              ),
              ref,
            );
          },
        ),
      if (lifestyleStyle != null)
        lifestyleStyle.secondary(
          icon: iconData,
          onPressed: () {
            onResultAction?.call(DataFinderClickAction.addToFavorites);
            _onFavoriteTap(
              context: context,
              ref: ref,
              data: directoryObject,
            );
          },
        )
      else
        ItemActionBar(
          icon: iconData,
          iconSize: 15,
          bgColor: isDGADark
              ? context.colors.neutralMuted
              : isDGAlight
              ? context.colors.neutralOnNeutral
              : null,
          border: isBaseTheme ? BorderSide(color: context.colors.borderDefault) : null,
          borderRadius: 4,
          buttonType: ButtonType.secondary,
          colorScheme: colorScheme,
          label: isFavourite ? context.l10n.removeFromFavorites : context.l10n.addToFavorite,
          onPressed: () {
            onResultAction?.call(DataFinderClickAction.addToFavorites);
            _onFavoriteTap(
              context: context,
              ref: ref,
              data: directoryObject,
            );
          },
        ),
      ThrottledCallbackWidget(
        callback: () {
          onResultAction?.call(DataFinderClickAction.sharePoi);
          final markerPosition = directoryObject.markerPosition;
          final latLng = markerPosition != null
              ? LatLng(latitude: markerPosition.latitude, longitude: markerPosition.longitude)
              : null;

          poiActions.share(
            objectId: objectId,
            markerCoords: latLng,
          );
        },
        resetAfterFutureCompleted: true,
        builder: (context, throttledShare) => lifestyleStyle != null
            ? lifestyleStyle.secondary(
                icon: SystemIcons.share,
                onPressed: throttledShare,
              )
            : ItemActionBar(
                bgColor: isDGADark
                    ? context.colors.neutralMuted
                    : isDGAlight
                    ? context.colors.neutralOnNeutral
                    : null,
                icon: SystemIcons.share,
                border: isBaseTheme ? BorderSide(color: context.colors.borderDefault) : null,
                borderRadius: 4,
                colorScheme: colorScheme,
                buttonType: ButtonType.secondary,
                label: context.l10n.share,
                onPressed: throttledShare,
              ),
      ),
      if (phoneNumbers.isNotEmpty)
        lifestyleStyle != null
            ? lifestyleStyle.secondary(
                icon: GeneralIcons.phoneLTR,
                onPressed: () {
                  if (phoneNumbers.length == 1) {
                    BssService.instance.trackCallTap(directoryObject, phoneNumbers.first.value!);
                    poiActions.callPhone(phoneNumbers.first.value!);
                  } else {
                    showPhonePickerSheet(context, phoneNumbers, (phone) {
                      BssService.instance.trackCallTap(directoryObject, phone);
                      poiActions.callPhone(phone);
                    });
                  }
                },
              )
            : ItemActionBar(
                bgColor: isDGADark
                    ? context.colors.neutralMuted
                    : isDGAlight
                    ? context.colors.neutralOnNeutral
                    : null,
                icon: GeneralIcons.phoneLTR,
                colorScheme: colorScheme,
                buttonType: ButtonType.secondary,
                label: context.l10n.call,
                border: isBaseTheme ? BorderSide(color: context.colors.borderDefault) : null,
                borderRadius: 4,
                onPressed: () {
                  if (phoneNumbers.length == 1) {
                    BssService.instance.trackCallTap(directoryObject, phoneNumbers.first.value!);
                    poiActions.callPhone(phoneNumbers.first.value!);
                  } else {
                    showPhonePickerSheet(context, phoneNumbers, (phone) {
                      BssService.instance.trackCallTap(directoryObject, phone);
                      poiActions.callPhone(phone);
                    });
                  }
                },
              ),
      if (website != null)
        lifestyleStyle != null
            ? lifestyleStyle.secondary(
                icon: GeneralIcons.web,
                onPressed: () {
                  BssService.instance.trackLinkTap(directoryObject, BssContactType.website, website);
                  poiActions.launch(website);
                },
              )
            : ItemActionBar(
                bgColor: isDGADark
                    ? context.colors.neutralMuted
                    : isDGAlight
                    ? context.colors.neutralOnNeutral
                    : null,
                icon: GeneralIcons.web,
                colorScheme: colorScheme,
                buttonType: ButtonType.secondary,
                border: isBaseTheme ? BorderSide(color: context.colors.borderDefault) : null,
                borderRadius: 4,
                label: context.l10n.feedbackWebsiteLabel,
                onPressed: () {
                  BssService.instance.trackLinkTap(directoryObject, BssContactType.website, website);
                  poiActions.launch(website);
                },
              ),
      if (website == null && socialMedia != null)
        lifestyleStyle != null
            ? lifestyleStyle.secondary(
                icon: PoiContentContactsCard.getIconData(socialMedia.type),
                onPressed: () {
                  BssService.instance.trackLinkTap(directoryObject, socialMedia.type.toBss(), socialMedia.link);
                  poiActions.launch(socialMedia.link);
                },
              )
            : ItemActionBar(
                bgColor: isDGADark
                    ? context.colors.neutralMuted
                    : isDGAlight
                    ? context.colors.neutralOnNeutral
                    : null,
                icon: PoiContentContactsCard.getIconData(socialMedia.type),
                colorScheme: ButtonColorScheme.accent,
                buttonType: ButtonType.secondary,
                label: context.l10n.feedbackWebsiteOrSocialMedia,
                border: isBaseTheme ? BorderSide(color: context.colors.borderDefault) : null,
                borderRadius: 4,
                onPressed: () {
                  BssService.instance.trackLinkTap(directoryObject, socialMedia.type.toBss(), socialMedia.link);
                  poiActions.launch(socialMedia.link);
                },
              ),
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.$3x),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: Spacing.$10x + Spacing.$3x),
        child: Padding(
          padding: const EdgeInsets.only(top: Spacing.$3x),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
            itemBuilder: (context, index) => actions.elementAt(index),
            separatorBuilder: (context, index) => Spacing.$2x.widthBox,
            itemCount: actions.length,
          ),
        ),
      ),
    );
  }

  Future<void> _onFavoriteTap({
    required BuildContext context,
    required WidgetRef ref,
    required DirectoryObjectMessage data,
  }) async {
    await ref
        .read(authMethodsProvider.notifier)
        .authOrOpen(
          context,
          callback: () async {
            BssService.instance.trackFavoriteTap(data);
            await toggleFavoriteDirectoryObject(
              context: context,
              ref: ref,
              data: data,
            );
          },
        );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/icons/places_16_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

@RoutePage()
class FavoriteListsPage extends StatelessWidget {
  const FavoriteListsPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: context.colors.backgroundSurface4,
    appBar: BaladyTopBar.iconAndText(
      systemUiOverlayStyle: context.read<ThemeController>().systemOverlayStyle,
      leading: ActionModel(icon: SystemIcons.arrowCornerLeftLarge, onPressed: () => context.router.pop()),
      title: context.l10n.favorites,
    ),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.$4x),
        child: Column(
          spacing: 27,
          children: [
            _Section(
              // TODO(claude): localize string
              title: 'My addresses',
              child: ContentWrapper(
                color: context.colors.backgroundSurface1,
                children: [
                  ContentRow(
                    leading: Icon(GeneralIcons.home, color: context.colors.foregroundSoft),
                    // TODO(claude): localize string and pass address
                    text: const ContentRowTextOptions(title: 'Home', subtitle: 'Address'),
                    isDividerEnabled: true,
                    trailing: ContentRowTextTrailingOptions(
                      icon: SystemIcons.ellipsis,
                      iconColor: context.colors.foregroundSoft,
                      onPressed: () {
                        // todo open menu
                      },
                    ),
                    onTap: () {
                      // todo open POI
                    },
                  ),
                  ContentRow(
                    // todo valid icon
                    leading: Icon(GeneralIcons.buildings, color: context.colors.foregroundSoft),
                    // TODO(claude): localize string and pass address
                    text: const ContentRowTextOptions(title: 'Work', subtitle: 'Address'),
                    trailing: ContentRowTextTrailingOptions(
                      icon: SystemIcons.ellipsis,
                      iconColor: context.colors.foregroundSoft,
                      onPressed: () {
                        // todo open menu
                      },
                    ),
                    onTap: () {
                      // todo open POI
                    },
                  ),
                ],
              ),
            ),
            _Section(
              // TODO(claude): localize string
              title: 'My Lists',
              child: ContentWrapper(
                color: context.colors.backgroundSurface1,
                children: [
                  ContentRow(
                    leading: Icon(SystemIcons.zoomPlus, color: context.colors.accentDefault),
                    // TODO(claude): localize string
                    text: ContentRowTextOptions(
                      title: 'Create a new list',
                      titleOptions: ContentRowTextOption(baseColor: context.colors.accentDefault),
                    ),
                    onTap: () {
                      // todo create new list
                    },
                  ),
                  ContentRow(
                    leading: Icon(SystemIcons.bookmarkAdd, color: context.colors.accentDefault),
                    text: ContentRowTextOptions(
                      title: context.l10n.addPlace,
                      titleOptions: ContentRowTextOption(baseColor: context.colors.accentDefault),
                    ),
                    isDividerEnabled: true,
                    onTap: () {
                      // todo create new list
                    },
                  ),
                  ...[
                        'Favorites',
                        'Favorites_restaurants',
                        'Favorites_coffee shops',
                      ]
                      .map(
                        (e) => ContentRow(
                          leading: Icon(SystemIcons.bookmarkFill, color: context.colors.accentDefault),
                          // TODO: pass data
                          text: ContentRowTextOptions(title: e, subtitle: 'Modified 27.07.26 • 3 places'),
                          trailing: ContentRowTextTrailingOptions(
                            icon: SystemIcons.arrowCornerRightSmall,
                            iconColor: context.colors.foregroundDefault,
                          ),
                          onTap: () {
                            // todo open POI
                          },
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: Spacing.$4x,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: Spacing.$1x),
        child: Text(title, style: context.textStyles.h4SemiBold.copyWith(color: context.colors.foregroundDefault)),
      ),
      child,
    ],
  );
}

class _MyAddressItem extends StatelessWidget {
  final Widget icon;
  final String title;
  final String? address;

  const _MyAddressItem({required this.icon, required this.title, this.address});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Icon(General16Icons.homeAltSolid),
      Column(
        children: [
          Text(title, style: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundDefault)),
          // TODO(claude): localize string
          Text(
            address ?? 'Address',
            style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
          ),
        ],
      ),
    ],
  );
}

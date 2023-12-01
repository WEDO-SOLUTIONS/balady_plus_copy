import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/favourites/providers/favourite_repository.dart';
import 'package:mapness/_features/poi_card/widgets/card_content.dart';
import 'package:mapness/_features/poi_card/widgets/style.dart';
import 'package:mapness/app/routes/favourites.dart';
import 'package:mapness/shared/config/package_config.dart';

import 'package:mapness/shared/extensions/build_context_ext.dart';

class Favourites extends ConsumerWidget {
  final DirectoryObjectMessage? data;

  const Favourites(this.data, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favouritesState = ref.watch(favouriteRepositoryProvider);

    return favouritesState.map(
      data: (result) {
        var value = result.value;

        final isFavourite = value.items.firstWhereOrNull(
          (element) {
            var objectId = data?.id?.objectId;
            return element.entity?.id == '$objectId';
          },
        );

        final isHome = value.home?.id == '${data?.id?.objectId}';

        return Column(
          children: [
            isHome
                ? CardContent(
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/svg/ic_home.svg',
                          package: PackageConfig.packageName,
                          height: 24,
                          width: 24,
                          color: colorPrimary.withAlpha(125),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          context.l10n.home,
                          style: const TextStyle(
                            color: colorPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
            isFavourite != null
                ? CardContent(
                    onTap: () => const FavouritesRoute().push(context),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/svg/ic_fav_solid.svg',
                          package: PackageConfig.packageName,
                          height: 24,
                          width: 24,
                          color: colorAccent,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          context.l10n.favourites,
                          style: Theme.of(context).extension<ThemeTextStyles>()!.textM.copyWith(color: colorPrimary),
                        ),
                        Spacer(),
                        SvgPicture.asset(
                          'assets/icons/svg/ic_chevron_left.svg',
                          package: PackageConfig.packageName,
                          height: 24,
                          width: 24,
                          color: colorPrimary,
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        );
      },
      error: (_) => const SizedBox.shrink(),
      loading: (_) => const SizedBox.shrink(),
    );
  }
}

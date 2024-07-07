import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/favourites/providers/favourite_cache.dart';
import 'package:mapness/_features/poi_card/widgets/card_content.dart';
import 'package:mapness/_features/poi_card/widgets/favorite_card.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class Favourites extends ConsumerWidget {
  const Favourites(this.data, {super.key});

  final DirectoryObjectMessage? data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favouritesState = ref.watch(favouriteCacheProvider);

    return favouritesState.map(
      data: (result) {
        final value = result.value;

        final isFavourite = value.items.firstWhereOrNull(
          (element) {
            final objectId = data?.id?.objectId;
            return element.entity?.id == '$objectId';
          },
        );

        final showHome = value.home?.id == '${data?.id?.objectId}';
        final showWork = value.work?.id == '${data?.id?.objectId}';

        return Column(
          children: [
            if (showHome) const HomeCard(),
            if (showWork) const WorkCard(),
            if (isFavourite != null) const FavoriteCard(),
          ],
        );
      },
      error: (_) => const SizedBox.shrink(),
      loading: (_) => const SizedBox.shrink(),
    );
  }
}

class WorkCard extends StatelessWidget {
  const WorkCard({super.key});

  @override
  Widget build(BuildContext context) => CardContent(
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/svg/ic_work.svg',
              package: PackageConfig.packageName,
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(
                context.color.textAndIconsBasePrimary.withAlpha(125),
                BlendMode.srcATop,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              context.l10n.work,
              style: context.textStyle.text.copyWith(
                color: context.color.textAndIconsBasePrimary,
              ),
            ),
          ],
        ),
      );
}

class HomeCard extends StatelessWidget {
  const HomeCard({super.key});

  @override
  Widget build(BuildContext context) => CardContent(
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/svg/ic_home.svg',
              package: PackageConfig.packageName,
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(
                context.color.textAndIconsBasePrimary.withAlpha(125),
                BlendMode.srcATop,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              context.l10n.home,
              style: TextStyle(
                color: context.color.textAndIconsBasePrimary,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );
}

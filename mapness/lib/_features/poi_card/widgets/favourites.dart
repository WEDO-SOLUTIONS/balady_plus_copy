import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/favourites/providers/favourite_repository.dart';
import 'package:mapness/_features/poi_card/widgets/card_content.dart';
import 'package:mapness/_features/poi_card/widgets/favorite_card.dart';
import 'package:mapness/_features/poi_card/widgets/style.dart';
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
  const WorkCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardContent(
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/svg/ic_work.svg',
            package: PackageConfig.packageName,
            height: 24,
            width: 24,
            colorFilter: ColorFilter.mode(
              colorPrimary.withAlpha(125),
              BlendMode.srcATop,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            context.l10n.work,
            style: const TextStyle(
              color: colorPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
class HomeCard extends StatelessWidget {
  const HomeCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardContent(
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/svg/ic_home.svg',
            package: PackageConfig.packageName,
            height: 24,
            width: 24,
            colorFilter: ColorFilter.mode(
              colorPrimary.withAlpha(125),
              BlendMode.srcATop,
            ),
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
    );
  }
}

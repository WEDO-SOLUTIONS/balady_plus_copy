import 'dart:math';

import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/app/routes/search.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class PlacesForCart extends ConsumerWidget {
  final String title;
  final String svgAsset;

  const PlacesForCart({required this.title, required this.svgAsset, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: GestureDetector(
          onTap: () {
            ref.read(goRouterProvider).push(const SearchRoute(requestFocus: false).location);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(searchProvider(SearchScopeEnum.map.value).notifier).searchByText(
                    title.replaceAll('\n', '').replaceAll('Places for', '').replaceAll('أماكن', ''),
                  );
            });
          },
          child: SizedBox(
            height: 118,
            child: ColoredBox(
              color: context.colorsV2.backgroundSurface1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                    child: Transform(
                      alignment: Alignment.center,
                      transform: context.isLTR ? Matrix4.identity() : Matrix4.rotationY(pi),
                      child: SvgPicture.asset(
                        svgAsset,
                        height: 32,
                        width: 32,
                        package: PackageConfig.packageName,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                    child: Text(title, style: context.textStyleV3.bodyLargeMedium),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

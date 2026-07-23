import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/location.dart';

class QiblaCard extends ConsumerWidget {
  const QiblaCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => ClipRRect(
    borderRadius: BorderRadius.circular(RadiusBorder.xl),
    child: GestureDetector(
      onTap: () async {
        final location = ref.read(locationProvider.notifier);

        await location.checkLocationPermission().then((allowed) {
          if (allowed) {
            context.router.push(const KiblahRoute());
          }
        });
      },
      child: SizedBox(
        height: 118,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF525252),
                Color(0xFF1B1B1B),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(top: Spacing.$3x, start: Spacing.$4x),
                    child: Text(
                      context.l10n.qibla,
                      style: context.textStyles.h2Medium.copyWith(
                        color: context.colors.staticWhite,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(bottom: Spacing.$4x, start: Spacing.$4x),
                    child: Text(
                      context.l10n.showDirection,
                      style: context.textStyles.captionLargeRegular.copyWith(
                        color: context.colors.staticWhite,
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Transform(
                  alignment: Alignment.center,
                  transform: context.isLTR ? Matrix4.identity() : Matrix4.rotationY(pi),
                  child: Image.asset(
                    Assets.images.qibla.keyName,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

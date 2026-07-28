import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/pages/landing/landing_page.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class MapAttributionLabel extends StatelessWidget {
  const MapAttributionLabel({super.key});

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: StrokeText(
      context.l10n.baladyMaps,
    ),
  );
}

class StrokeText extends StatelessWidget {
  final String text;

  const StrokeText(
    this.text, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final base = context.textStyles.bodyLargeRegular;
    const fontFamily = 'packages/balady_uikit/Golos';

    return Padding(
      padding: const EdgeInsets.all(2),
      child: Stack(
        children: [
          Text(
            text,
            style: base.copyWith(
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 3
                ..strokeJoin = StrokeJoin.round
                ..strokeCap = StrokeCap.round
                ..color = context.colors.onMapSurfaceOnMap,
              fontFamily: fontFamily,
            ),
          ),
          Text(
            text,
            style: base.copyWith(color: context.colors.foregroundDefault, fontFamily: fontFamily),
          ),
        ],
      ),
    );
  }
}

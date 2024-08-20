import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class RoadPanel extends ConsumerWidget {
  final bool isLoading;
  final VoidCallback onEndTrip;
  final VoidCallback onOpenSheet;

  const RoadPanel({required this.isLoading, required this.onEndTrip, required this.onOpenSheet, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Directionality(
        textDirection: TextDirection.ltr,
        child: Padding(
          padding: const EdgeInsets.all(Spacing.$4x),
          child: SizedBox(
            height: 56,
            width: double.infinity,
            child: Material(
              color: Colors.transparent,
              child: isLoading
                  ? DecoratedBox(
                      decoration: BoxDecoration(
                        color: context.colorsV2.backgroundSurface1,
                        borderRadius: BorderRadius.circular(RadiusBorder.xl),
                      ),
                      child: Center(child: Loading.small()))
                  : Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: onEndTrip,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: context.colorsV2.backgroundSurface1,
                                borderRadius: BorderRadius.circular(RadiusBorder.xl),
                              ),
                              child: Center(
                                child: Text(context.l10n.endTrip, style: context.textStyleV3.h4Medium),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: Spacing.$2x),
                        GestureDetector(
                          onTap: onOpenSheet,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: context.colorsV2.backgroundSurface1,
                              borderRadius: BorderRadius.circular(RadiusBorder.xl),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(Spacing.$4x),
                              child: Icon(SystemIcons.menu),
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

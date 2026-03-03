import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/pages/free_roam/free_roam_page.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class RoadPanel extends ConsumerWidget {
  final bool isLoading;
  final VoidCallback onEndTrip;
  final VoidCallback onOpenSheet;
  final VoidCallback? onSearch;

  const RoadPanel({
    required this.isLoading,
    required this.onEndTrip,
    required this.onOpenSheet,
    this.onSearch,
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
    padding: const EdgeInsets.all(Spacing.$4x),
    child: SizedBox(
      height: 56,
      width: MediaQuery.orientationOf(context) == Orientation.portrait ? double.infinity : FreeRoamPage.landscapeWidth,
      child: Material(
        color: Colors.transparent,
        child: isLoading
            ? DecoratedBox(
                decoration: BoxDecoration(
                  color: context.colors.backgroundSurface1,
                  borderRadius: BorderRadius.circular(RadiusBorder.xl),
                ),
                child: Center(child: Loading.small()),
              )
            : Row(
                children: [
                  if (onSearch != null)
                    GestureDetector(
                      onTap: onSearch,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: context.colors.onmapSurfaceOnMap,
                          borderRadius: BorderRadius.circular(RadiusBorder.xl),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(Spacing.$4x),
                          child: Icon(SystemIcons.search, color: context.colors.foregroundDefault),
                        ),
                      ),
                    ),
                  if (onSearch != null) const SizedBox(width: Spacing.$2x),
                  Expanded(
                    child: GestureDetector(
                      onTap: onEndTrip,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: context.colors.onmapSurfaceOnMap,
                          borderRadius: BorderRadius.circular(RadiusBorder.xl),
                        ),
                        child: Center(
                          child: Text(
                            context.l10n.endTrip,
                            style: context.textStyles.h4Medium.copyWith(color: context.colors.foregroundDefault),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: Spacing.$2x),
                  GestureDetector(
                    onTap: onOpenSheet,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: context.colors.onmapSurfaceOnMap,
                        borderRadius: BorderRadius.circular(RadiusBorder.xl),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(Spacing.$4x),
                        child: Icon(SystemIcons.menu, color: context.colors.foregroundDefault),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    ),
  );
}

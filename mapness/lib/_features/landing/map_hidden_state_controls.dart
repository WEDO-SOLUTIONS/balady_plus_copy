import 'dart:ui';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/_features/landing/providers/quick_filter_request_source_screen.dart';
import 'package:mapness/_features/landing/widgets/map_quick_filters.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/app/routes/free_roam.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/widgets/quick_filters/models/filter_item.dart';

class MapHiddenStateControls extends BottomSheetComponentWidget<ThreeStateBottomSheet> {
  const MapHiddenStateControls({super.key, super.defaultState = ThreeStateBottomSheet.hidden});

  @override
  Widget build(BuildContext context, ThreeStateBottomSheet state, double interpolation) => Consumer(
        builder: (context, ref, child) {
          final delta = clampDouble(1 - interpolation * 3, 0, 1);
          return Visibility(
            visible: state == ThreeStateBottomSheet.hidden,
            child: SizedOverflowBox(
              size: Size(double.infinity, 64 * delta),
              child: Directionality(
                textDirection: ref.watch(uiDirectionProvider),
                child: MapQuickFilters(
                  forMap: true,
                  id: QuickFilterScreen.controls,
                  customFilters: [
                    FilterItemBuilder(
                      filterType: FilterType.custom,
                      builder: (context, {required isDashboard, required isSelected}) => Material(
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            FreeRoamRoute.open(ref.watch(goRouterProvider));
                          },
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(minWidth: 52),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 9,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/svg/quick_filters/free_roam.svg',
                                    height: 24,
                                    width: 24,
                                    package: PackageConfig.packageName,
                                    colorFilter: ColorFilter.mode(
                                      isSelected ? Colors.white : context.color.textAndIconsBasePrimary,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
}

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/widgets/dragger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/pages/map_search/ui/map_search_bar.dart';
import 'package:sheetify/sheetify.dart';

class NaviSearchHeader extends SheetAnimatedWidget<ThreeStateSheet> {
  final bool requestFocus;
  final VoidCallback onClose;
  final Color backgroundColor;
  final bool showLeadingBackButton;
  final VoidCallback? onLeadingBackPressed;

  const NaviSearchHeader({
    required this.requestFocus,
    required this.onClose,
    required this.backgroundColor,
    this.showLeadingBackButton = false,
    this.onLeadingBackPressed,
    super.key,
  }) : super(defaultState: ThreeStateSheet.open);

  @override
  Widget build(BuildContext context, ThreeStateSheet state, double interpolation) {
    final bottomPadding = interpolation == 0.0 && state == ThreeStateSheet.hidden ? (Spacing.$8x) : (Spacing.$4x);

    return Consumer(
      builder: (context, ref, child) => Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(16),
            topLeft: Radius.circular(16),
          ),
        ),
        child: Column(
          children: [
            ColoredBox(
              color: backgroundColor,
              child: const SizedBox(
                height: 24,
                width: double.infinity,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: Spacing.$2x),
                    child: Dragger(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x).copyWith(bottom: bottomPadding),
              child: MapSearchBar(
                requestFocus: requestFocus,
                onClose: onClose,
                isCloseButton: interpolation == 0.0 && state == ThreeStateSheet.hidden,
                showLeadingBackButton: showLeadingBackButton,
                onLeadingBackPressed: onLeadingBackPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

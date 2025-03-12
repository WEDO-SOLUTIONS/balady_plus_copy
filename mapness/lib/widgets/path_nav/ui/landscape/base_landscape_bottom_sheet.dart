import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:mapness/widgets/path_nav/ui/landscape/path_nav_orientation_redirect_wrapper.dart';

const _landscapeWidth = 370.0;

class BaseLandscapeBottomSheet extends StatefulWidget {
  final List<Widget> content;

  const BaseLandscapeBottomSheet({
    required this.content,
    super.key,
  });

  @override
  State<BaseLandscapeBottomSheet> createState() => _BaseLandscapeBottomSheetState();
}

class _BaseLandscapeBottomSheetState extends State<BaseLandscapeBottomSheet> {
  late final controller = StatelessBottomSheetController(
    onClose: (_) {
      context.router.popForced();
    },
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PathNavOrientationRedirectWrapper(
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  context.router.popForced();
                },
                child: const SizedBox.expand(),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.only(top: Spacing.$3x),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: _landscapeWidth),
                    child: StatelessBottomSheet(
                      scrollController: controller,
                      content: widget.content,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

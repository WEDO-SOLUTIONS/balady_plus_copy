import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mapness/shared/hooks/stateless_botomsheet_controller_hook.dart';
import 'package:mapness/widgets/path_nav/ui/landscape/path_nav_orientation_redirect_wrapper.dart';

const landscapeWidth = 370.0;

class BaseLandscapeBottomSheet extends HookWidget {
  final List<Widget> content;

  const BaseLandscapeBottomSheet({
    required this.content,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useStatelessBottomsheetController(onClose: (_) => context.router.popForced());

    return PathNavOrientationRedirectWrapper(
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: context.router.popForced,
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
                  constraints: const BoxConstraints(maxWidth: landscapeWidth),
                  child: StatelessBottomSheet(
                    scrollController: controller,
                    content: content,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

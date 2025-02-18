import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mapness/features/profile/widgets/slide_to_log_out.dart';
import 'package:mapness/shared/hooks/stateless_botomsheet_controller_hook.dart';

class LogoutSheet extends HookWidget {
  final VoidCallback onLogout;

  const LogoutSheet({required this.onLogout, super.key});

  @override
  Widget build(BuildContext context) {
    final statelessBottomSheetController =
        useStatelessBottomsheetController(onClose: (controller) => Navigator.of(context).pop());
    return StatelessBottomSheet(
      header: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
        child: ContentRowV2(
          crossAxisAlignment: CrossAxisAlignment.start,
          text: ContentRowTextOptions(
            titleOptions: ContentRowTextOption(
                builder: (_) => Text(
                      'Sign out',
                      style: context.textStyleV3.h4SemiBold.copyWith(
                        color: context.colorsV2.foregroundDefault,
                      ),
                    )),
            subtitle: 'Are you sure you want to log out of your\naccount?',
            subtitleOptions: const ContentRowTextOption(
              maxLines: 2,
            ),
          ),
          trailing: ContentRowCustomTrailingOptions(
            builder: (context) =>
                Align(alignment: Alignment.topCenter, child: AppButton.close(onTap: () => Navigator.of(context).pop())),
          ),
        ),
      ),
      content: [
        const SizedBox(
          height: Spacing.$3x,
        ),
        SafeArea(
          top: false,
          left: false,
          right: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x).copyWith(
              bottom: Spacing.$4x,
            ),
            child: SlideToLogout(
              onLogout: onLogout,
            ),
          ),
        ),
      ],
      scrollController: statelessBottomSheetController,
    );
  }
}

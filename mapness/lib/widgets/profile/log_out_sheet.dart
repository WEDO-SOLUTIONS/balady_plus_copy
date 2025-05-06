import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mapness/shared/hooks/stateless_botomsheet_controller_hook.dart';
import 'package:mapness/widgets/profile/slide_to_log_out.dart';

class LogoutSheet extends HookWidget {
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onLogout;

  const LogoutSheet({
    required this.onLogout,
    required this.title,
    required this.description,
    required this.buttonText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final statelessBottomSheetController = useStatelessBottomsheetController(
      onClose: (_) => Navigator.of(context).pop(),
    );
    return StatelessBottomSheet(
      header: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
        child: ContentRowV2(
          crossAxisAlignment: CrossAxisAlignment.start,
          text: ContentRowTextOptions(
            titleOptions: ContentRowTextOption(
                builder: (_) => Text(
                      title,
                      style: context.textStyleV3.h4SemiBold.copyWith(
                        color: context.colorsV2.foregroundDefault,
                      ),
                    )),
            subtitle: description,
            subtitleOptions: const ContentRowTextOption(
              maxLines: 2,
            ),
          ),
          trailing: ContentRowCustomTrailingOptions(
            builder: (context) => Align(
              alignment: Alignment.topCenter,
              child: AppButton.close(
                onTap: Navigator.of(context).pop,
              ),
            ),
          ),
        ),
      ),
      content: [
        Spacing.$3x.heightBox,
        SafeArea(
          top: false,
          left: false,
          right: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x).copyWith(
              bottom: Spacing.$4x,
            ),
            child: SlideToLogout(onLogout: onLogout, buttonText: buttonText),
          ),
        ),
      ],
      scrollController: statelessBottomSheetController,
    );
  }
}

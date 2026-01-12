import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/dark_mode.dart';

class DarkMapModeRowWidget extends ConsumerWidget {
  final DarkMapStateEnum currentMode;

  const DarkMapModeRowWidget({
    required this.currentMode,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darModeState = ref.watch(darkModeProvider);

    return ContentRow(
      onTap: () {
        ref.read(darkModeProvider.notifier).changeDarkModeState(currentMode);
      },
      options: ContentRowOptions(
        padding: const EdgeInsets.symmetric(
          vertical: Spacing.$2x,
          horizontal: Spacing.$4x,
        ),
        wrapperColor: context.colors.backgroundSurface1,
        wrapperEnabled: true,
        title: _getTitleFromDarkModeState(context),
        titleStyle: context.textStyles.bodyLargeRegular.copyWith(
          color: context.colors.foregroundDefault,
        ),
        customActionWidget: darModeState.value?.currentMapMode == currentMode
            ? Padding(
                padding: const EdgeInsetsDirectional.only(end: Spacing.$4x),
                child: Icon(
                  SystemIcons.checkmark,
                  color: context.colors.successDefault,
                ),
              )
            : Spacing.$6x.heightBox,
      ),
    );
  }

  String _getTitleFromDarkModeState(BuildContext context) => switch (currentMode) {
        DarkMapStateEnum.asInASystem => context.l10n.darkModeAsInASystem,
        DarkMapStateEnum.alwaysEnabled => context.l10n.darkModeAlwaysEnabled,
        DarkMapStateEnum.off => context.l10n.darkModeOff,
      };
}

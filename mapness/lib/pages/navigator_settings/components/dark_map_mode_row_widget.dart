import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/dark_mode.dart';

class DarkMapModeRowWidget extends ConsumerWidget {
  final DarkMapStateEnum currentMode;
  final bool dividerEnabled;

  const DarkMapModeRowWidget({required this.dividerEnabled, required this.currentMode, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darModeState = ref.watch(darkModeProvider);

    return ContentRow(
      onTap: () {
        ref.read(darkModeProvider.notifier).changeDarkModeState(currentMode);
      },
      constraints: const BoxConstraints(minHeight: 66),
      options: ContentRowOptions(
        padding: EdgeInsets.zero,
        wrapperColor: context.colors.backgroundSurface1,
        dividerEnabled: dividerEnabled,
        title: _getTitleFromDarkModeState(context),
        subtitle: _getSubtitle(context),
        titleStyle: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundDefault),
        customActionWidget: darModeState.value?.currentMapMode == currentMode
            ? Padding(
                padding: const EdgeInsetsDirectional.only(end: Spacing.$4x),
                child: Icon(
                  SystemIcons.checkmark,
                  color: context.colors.successDefault,
                  size: 24,
                ),
              )
            : Spacing.$6x.heightBox,
      ),
    );
  }

  String _getTitleFromDarkModeState(BuildContext context) => switch (currentMode) {
    DarkMapStateEnum.asInASystem => context.l10n.darkModeAsInASystemTitle,
    DarkMapStateEnum.autoSunDependent => context.l10n.darkModeSunDependentTitle,
    DarkMapStateEnum.alwaysEnabled => context.l10n.darkModeOnTitle,
    DarkMapStateEnum.off => context.l10n.darkModeOff,
  };

  String? _getSubtitle(BuildContext context) => switch (currentMode) {
    DarkMapStateEnum.asInASystem => context.l10n.darkModeAsInASystemSubtitle,
    DarkMapStateEnum.autoSunDependent => context.l10n.darkModeSunDependentSubtitle,
    DarkMapStateEnum.alwaysEnabled => null,
    DarkMapStateEnum.off => null,
  };
}

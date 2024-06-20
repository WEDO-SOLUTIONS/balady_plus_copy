import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/dark_mode.dart';

class DarkModeCell extends ConsumerWidget {
  const DarkModeCell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(darkModeProvider);

    return Directionality(
      textDirection: ref.watch(uiDirectionProvider),
      child: Material(
        borderRadius: BorderRadius.circular(8),
        color: context.color.surfaceBaseSecondary,
        child: InkWell(
          onTap: () {
            ref.read(darkModeProvider.notifier).toggle();
          },
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 48,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  AppIcons(
                    iconData: GeneralIcons.darkMode,
                    color: context.color.textAndIconsStatusAccent,
                    size: 24,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2.0),
                    child: Text(
                      context.l10n.darkMap,
                      style: context.textStyle.text.copyWith(color: context.color.textAndIconsBasePrimary),
                    ),
                  ),
                  const Spacer(),
                  IgnorePointer(
                    child: CupertinoSwitch(
                      activeColor: context.color.textAndIconsStatusAccent,
                      onChanged: (bool value) {},
                      value: darkMode,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

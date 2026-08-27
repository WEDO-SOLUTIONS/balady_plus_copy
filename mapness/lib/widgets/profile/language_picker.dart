import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/shared/providers/app_language.dart';

class LanguagePicker extends StatelessWidget {
  const LanguagePicker({super.key});

  @override
  Widget build(BuildContext context) => const Column(
    children: [
      LanguageRow(language: Language.arabic, border: false),
      LanguageRow(language: Language.english, border: true),
    ],
  );
}

class LanguageRow extends ConsumerWidget {
  // According to task BALADY-416 to hide flags we temporary hide it with boolean flag
  // We don't delete it because this goes against the design of this feature
  static const showFlags = false;

  const LanguageRow({required this.language, required this.border, super.key});

  final Language language;
  final bool border;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(appLanguageProvider);

    const radius12 = Radius.circular(12);
    const radiusZero = Radius.circular(0);
    return Directionality(
      textDirection: ref.watch(uiDirectionProvider),
      child: Material(
        color: context.colors.backgroundSurface1,
        borderRadius: BorderRadius.only(
          bottomLeft: border ? radius12 : radiusZero,
          bottomRight: border ? radius12 : radiusZero,
        ),
        child: InkWell(
          borderRadius: BorderRadius.only(
            bottomLeft: border ? radius12 : radiusZero,
            bottomRight: border ? radius12 : radiusZero,
          ),
          onTap: () {
            ref.read(appLanguageProvider.notifier).update(language);
          },
          child: Semantics(
            label: language == Language.arabic ? 'Arabic' : 'English',
            button: true,
            selected: currentLanguage == language,
            child: ExcludeSemantics(
              child: ContentRowV2(
                leading: leadingIcon,
                isDividerEnabled: !border,
                text: ContentRowTextOptions(title: language.title),
                trailing: ContentRowTextTrailingOptions(
                  icon: currentLanguage == language ? GeneralIcons.bulletCircleSolid : GeneralIcons.circleNull,
                  iconColor: currentLanguage == language ? context.colors.accentDefault : context.colors.foregroundMuted,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget? get leadingIcon => showFlags
      ? SvgPicture.asset(
          switch (language) {
            Language.arabic => Assets.icons.svg.saFlag.keyName,
            Language.english => Assets.icons.svg.ukFlag.keyName,
          },
          height: 16,
          width: 22,
        )
      : null;
}

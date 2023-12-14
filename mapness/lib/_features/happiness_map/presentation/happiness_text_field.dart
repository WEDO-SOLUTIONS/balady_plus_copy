import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mapness/_features/happiness_map/data/happines_manager.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class HappinessTextField extends ConsumerWidget {
  const HappinessTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final happinessManager = ref.watch(happinessManagerProvider.notifier);

    final border = OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(8),
    );

    return TextField(
      enabled: false,
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
      textInputAction: TextInputAction.done,
      // controller: model.searchController,
      onSubmitted: happinessManager.updateComment,
      onChanged: happinessManager.updateComment,
      // focusNode: model.searchFocusNode,
      decoration: InputDecoration(
        hintText: context.l10n.shareYourFeedback,
        enabledBorder: border,
        fillColor: const Color(0xfff4f4f5),
        filled: true,
        border: border,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        focusedBorder: border,
        isDense: true,
        hintStyle: Theme.of(context).extension<ThemeTextStyles>()!.textM.copyWith(color: const Color(0x7F1E2A36)),
      ),
    );
  }
}

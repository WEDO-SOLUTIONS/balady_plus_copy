import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/pages/navigator_settings/components/dark_map_mode_row_widget.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:urbi_utils/urbi_utils.dart';

class DarkMapPageContent extends ConsumerWidget {
  const DarkMapPageContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = ref.watch(darkModeProvider);

    return Padding(
      padding: const EdgeInsets.all(Spacing.$4x).copyWith(bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(RadiusBorder.xl),
              child: Image.asset(
                dark.valueOrNull?.isDark ?? false
                    ? Assets.images.darkMapPreview.keyName
                    : Assets.images.lightMapPreview.keyName,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
                height: switch (MediaQuery.of(context).orientation) {
                  Orientation.portrait => null,
                  Orientation.landscape => 100,
                },
              ),
            ),
          ),
          ContentWrapper(
            color: context.colors.backgroundSurface1,
            children: DarkMapStateEnum.values
                .map<Widget>(
                  (e) => DarkMapModeRowWidget(
                    currentMode: e,
                  ),
                )
                .insertBetween(
                  Divider(
                    height: 0.5,
                    color: context.colors.borderSoft,
                    thickness: 1,
                    indent: Spacing.$4x,
                    endIndent: 0,
                  ),
                )
                .toList(),
          ),
        ].insertBetween(Spacing.$4x.heightBox).toList(),
      ),
    );
  }
}

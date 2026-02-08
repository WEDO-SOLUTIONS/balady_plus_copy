import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/gen/assets/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: '15. Stories',
  type: Widget,
)
Widget storiesDemo(BuildContext context) {
  final isWatched = context.knobs.boolean(label: 'Watched');
  final title = context.knobs.string(label: 'Title', initialValue: 'Al - Riaz');

  return ColoredBox(
    color: context.colors.backgroundSurface2,
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        height: 312,
        width: 210,
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  'Viewed',
                  style: context.textStyles.h3SemiBold.copyWith(color: context.colors.foregroundDefault),
                ),
                const SizedBox(height: 20),
                Expanded(
                    child: Center(
                        child: Text(
                  isWatched ? 'Yes' : 'No',
                  style: context.textStyles.h3SemiBold.copyWith(color: context.colors.foregroundDefault),
                ))),
                Expanded(
                    child: Center(
                        child: Text(
                  'Loading',
                  style: context.textStyles.h3SemiBold.copyWith(color: context.colors.foregroundDefault),
                ))),
              ],
            ),
            const SizedBox(width: 20),
            Column(
              children: [
                Text(
                  Directionality.of(context).name,
                  style: context.textStyles.h3SemiBold.copyWith(color: context.colors.foregroundDefault),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Stories(
                    onTap: () {},
                    title: title,
                    isWatched: isWatched,
                    assetImage: Assets.images.imgTestStories.path,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Stories(
                    onTap: () {},
                    title: title,
                    isWatched: isWatched,
                    networkImage: 'invalid url',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

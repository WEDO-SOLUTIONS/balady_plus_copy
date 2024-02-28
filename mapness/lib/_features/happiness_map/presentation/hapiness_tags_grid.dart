import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/happiness_map/data/happines_manager.dart';
import 'package:mapness/_features/happiness_map/data/happiness_tags.dart';
import 'package:mapness/_features/happiness_map/domain/happiness_tag.dart';
import 'package:mapness/_features/happiness_map/presentation/happiness_tag_widget.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class HappinessTagsGrid extends ConsumerWidget {
  HappinessTagsGrid({super.key});
  final sizeGroup = AutoSizeGroup();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tags = ref.watch(happinessTagsWithIconsProvider);
    final happinessManager = ref.watch(happinessManagerProvider.notifier);
    final happinessState = ref.watch(happinessManagerProvider);

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 78 / 90,
      padding: EdgeInsets.zero,
      children: [
        ...tags.map(
          (tag) {
            final isSelected = happinessState.tags.contains(tag.code);
            return HappinessTagWidget(
              title: tag.titleOrFallback(context.l10n),
              iconAsset: tag.iconAsset,
              onPressed: () => isSelected
                  ? happinessManager.removeTag(tag.code)
                  : happinessManager.addTag(tag.code),
              isSelected: isSelected,
              tagSizeGroup: sizeGroup,
            );
          },
        ),
      ],
    );
  }
}

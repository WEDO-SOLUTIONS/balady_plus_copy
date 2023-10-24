import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/happiness_map/data/happiness_tags.dart';
import 'package:mapness/features/happiness_map/presentation/happiness_tag_widget.dart';

import '../data/happines_manager.dart';

class HappinessTagsGrid extends ConsumerWidget {
  const HappinessTagsGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tags = ref.watch(happinessTagsWithIconsProvider);
    final happinessManager = ref.watch(happinessManagerProvider.notifier);
    final happinessState = ref.watch(happinessManagerProvider);

    return Material(
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: [
          ...tags.map(
            (e) {
              final (icon, tag) = e;
              final isSelected = happinessState.tags.contains(tag);
              return HappinessTagWidget(
                tag: tag,
                icon: icon,
                onPressed: () => isSelected
                    ? happinessManager.removeTag(tag)
                    : happinessManager.addTag(tag),
                isSelected: isSelected,
              );
            },
          ),
          HappinessTagWidget(
            tag: 'add',
            icon: Icons.add,
            onPressed: () {},
            isSelected: false,
          ),
        ],
      ),
    );
  }
}

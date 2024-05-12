import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/happiness_map/data/happines_manager.dart';
import 'package:mapness/_features/happiness_map/data/happiness_tags.dart';
import 'package:mapness/_features/happiness_map/domain/happiness_tag.dart';
import 'package:mapness/_features/happiness_map/presentation/happiness_tag_widget.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class HappinessTagsGrid extends ConsumerStatefulWidget {
  const HappinessTagsGrid({Key? key}) : super(key: key);

  @override
  _HappinessTagsGridState createState() => _HappinessTagsGridState();
}

class _HappinessTagsGridState extends ConsumerState<HappinessTagsGrid>
    with SingleTickerProviderStateMixin {
  final sizeGroup = AutoSizeGroup();

  late final AnimationController _animationController = AnimationController(
    duration: const Duration(milliseconds: 250),
    vsync: this,
  );
  late final _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
    CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ),
  );

  @override
  void initState() {
    super.initState();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tags = ref.watch(happinessTagsWithIconsProvider);
    final happinessManager = ref.watch(happinessManagerProvider.notifier);
    final happinessState = ref.watch(happinessManagerProvider);

    return FadeTransition(
      opacity: _opacityAnimation,
      child: GridView.count(
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
      ),
    );
  }
}

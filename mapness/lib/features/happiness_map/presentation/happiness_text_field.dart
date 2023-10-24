import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/happiness_map/data/happines_manager.dart';

class HappinessTextField extends ConsumerWidget {
  const HappinessTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final happinessManager = ref.watch(happinessManagerProvider.notifier);

    return TextField(
      textAlign: TextAlign.end,
      textInputAction: TextInputAction.done,
      // controller: model.searchController,
      onSubmitted: happinessManager.updateComment,
      onChanged: happinessManager.updateComment,
      // focusNode: model.searchFocusNode,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 13,
        ),
        isDense: true,
        suffixIconConstraints: BoxConstraints(
          maxHeight: 24,
          maxWidth: 24,
        ),
        border: InputBorder.none,
      ),
    );
  }
}

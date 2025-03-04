import 'package:balady_uikit/core/colors/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/color_scheme.dart';

class ColorschemeToggler extends ConsumerWidget {
  const ColorschemeToggler({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nextShemeIndex = (ref.watch(colorSchemeProvider).index + 1) % AppColorScheme.values.length;

    return ElevatedButton(
      onPressed: () => ref
          .read(colorSchemeProvider.notifier)
          // do not do this in logic, for debug purposes only
          // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
          .state = AppColorScheme.values[nextShemeIndex],
      child: const Text('cycle colorscheme'),
    );
  }
}

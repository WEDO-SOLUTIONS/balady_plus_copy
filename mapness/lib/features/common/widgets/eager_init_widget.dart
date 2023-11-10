import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/common/providers/eager_init.dart';

/// widget that preload all startup required providers.
class EagerInitWidget extends ConsumerWidget {
  final Widget child;
  const EagerInitWidget({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(eagerInitProvider);
    return state.map(
      error: (error) => const Center(child: Text("Eager init error")),
      loading: (loading) => const Center(child: CircularProgressIndicator()),
      data: (data) => child,
    );
  }
}

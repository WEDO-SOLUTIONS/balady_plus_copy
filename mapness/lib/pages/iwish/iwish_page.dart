import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/routes/home_shell.dart';
import 'package:mapness/features/iwish/providers/iwish_markers.dart';

class IwishPage extends ConsumerWidget {
  const IwishPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(iwishMarkersProvider.notifier).focusMarkersOnMap();
      if (context.mounted) {
        const LandingRoute().replace(context);
      }
    });

    return const SizedBox.shrink();
  }
}

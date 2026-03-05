import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

class LinkChecker extends HookConsumerWidget {
  const LinkChecker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final linkController = useTextEditingController(text: '/landing');

    const pages = [
      '/landing',
      '/routing',
      '/services',
      '/profile',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutofillGroup(
          child: TextField(
            autofillHints: ref.read(appRouterProvider).routes.map((e) => e.path),
            controller: linkController,
            decoration: const InputDecoration(labelText: 'Link'),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            try {
              final text = linkController.text;

              if (pages.contains(text)) {
                // Do not have thi method in autorouter
                context.router.navigatePath(text);
              } else {
                context.router.pushPath(text);
              }
            } catch (e) {
              logger.log('Error navigating to link: ${e.toString()}');
            }
          },
          child: const Text('Go to'),
        ),
      ],
    );
  }
}

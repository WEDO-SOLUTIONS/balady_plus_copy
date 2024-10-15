import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/app/routes/routes.dart';

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
          autofillHints: $appRoutes.map((r) => (r as GoRoute).path),
          controller: linkController,
          decoration: const InputDecoration(
            labelText: 'Link',
          ),
        )),
        ElevatedButton(
          onPressed: () {
            try {
              final goRouter = ref.read(goRouterProvider);
              final text = linkController.text;

              if (pages.contains(text)) {
                goRouter.go(text);
              } else {
                goRouter.push(text);
              }
            } catch (e) {
              debugPrint(e.toString());
            }
          },
          child: const Text('Go to'),
        ),
      ],
    );
  }
}

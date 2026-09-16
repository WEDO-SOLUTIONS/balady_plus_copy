import 'dart:async';

import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/friends_on_map/models/shared_list.dart';
import 'package:mapness/features/friends_on_map/providers/shared_lists_controller.dart';
import 'package:mapness/features/friends_on_map/ui/friends_on_map_error_dialog.dart';
import 'package:mapness/features/share_eta/ui/eta_share_control_sheet/eta_share_sheet.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// R-71's "create a list, name it" step — a sheet, since name entry is the
/// only input. On success, pops then pushes straight into the new list's
/// detail page.
Future<void> showCreateSharedListSheet(BuildContext context) => showModalBottomSheet<void>(
  backgroundColor: Colors.transparent,
  context: context,
  isScrollControlled: true,
  builder: (context) => const _CreateSharedListSheetContent(),
);

class _CreateSharedListSheetContent extends StatefulWidget {
  const _CreateSharedListSheetContent();

  @override
  State<_CreateSharedListSheetContent> createState() => _CreateSharedListSheetContentState();
}

class _CreateSharedListSheetContentState extends State<_CreateSharedListSheetContent> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    // EtaShareSheet itself never accounts for the keyboard — every other
    // caller only shows static/confirm content, this is the first one that
    // opens a TextField inside it.
    padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
    child: EtaShareSheet(
      title: context.l10n.createSharedListTitle,
      confirmBtnTitle: context.l10n.createSharedListCta,
      onConfirmTap: () {
        final name = _controller.text.trim();
        if (name.isEmpty) {
          return;
        }
        Navigator.of(context).pop();
        unawaited(_createAndOpen(name));
      },
      contentBuilder: (context) => [
        TextField(
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(hintText: context.l10n.createSharedListNameHint),
        ),
      ],
    ),
  );
}

// Runs off the root navigator's context/container, not this widget's own —
// by the time the user taps confirm, this sheet may already be popped, same
// lesson every other confirm sheet in this feature has already hit.
Future<void> _createAndOpen(String name) async {
  final rootContext = rootNavigatorKey.currentContext!;
  final container = ProviderScope.containerOf(rootContext, listen: false);
  SharedList? created;
  await runFriendsOnMapAction(rootContext, () async {
    created = await container.read(sharedListsControllerProvider.notifier).create(name);
  });
  final list = created;
  if (list != null) {
    await container.read(appRouterProvider).push(SharedListDetailRoute(listId: list.id));
  }
}

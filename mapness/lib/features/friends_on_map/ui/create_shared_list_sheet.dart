import 'dart:async';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/friends_on_map/models/shared_list.dart';
import 'package:mapness/features/friends_on_map/providers/shared_lists_controller.dart';
import 'package:mapness/features/friends_on_map/ui/friends_on_map_error_dialog.dart';
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
  static const _maxNameLength = 64;

  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isTooLong => _controller.text.trim().length > _maxNameLength;

  @override
  Widget build(BuildContext context) {
    final isTooLong = _isTooLong;
    final borderColor = isTooLong ? context.colors.errorDefault : context.colors.accentDefault;
    OutlineInputBorder border(Color color) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(RadiusBorder.m),
      borderSide: BorderSide(color: color, width: 1.5),
    );

    return Padding(
      // The sheet itself never accounts for the keyboard — this is the first
      // sheet in this feature that opens a TextField.
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.backgroundSurface4,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(RadiusBorder.xl),
            topRight: Radius.circular(RadiusBorder.xl),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Spacing.$4x).copyWith(top: 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(child: SheetDragger()),
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: Spacing.$2x),
                        child: Icon(SystemIcons.arrowCornerLeftLarge, color: context.colors.foregroundDefault),
                      ),
                    ),
                  ),
                  Text(
                    context.l10n.createSharedListTitle,
                    style: context.textStyles.bodyLargeSemiBold.copyWith(color: context.colors.foregroundDefault),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.$4x),
              TextField(
                controller: _controller,
                autofocus: true,
                minLines: 1,
                maxLines: 3,
                onChanged: (_) => setState(() {}),
                style: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundDefault),
                decoration: InputDecoration(
                  hintText: context.l10n.createSharedListNameHint,
                  hintStyle: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundSoft),
                  filled: true,
                  fillColor: context.colors.backgroundSurface1,
                  enabledBorder: border(borderColor),
                  focusedBorder: border(borderColor),
                  suffixIcon: _controller.text.isEmpty
                      ? null
                      : GestureDetector(
                          onTap: () => setState(_controller.clear),
                          behavior: HitTestBehavior.opaque,
                          child: Icon(SystemIcons.close, color: context.colors.foregroundMuted),
                        ),
                ),
              ),
              const SizedBox(height: Spacing.$2x),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.$2x),
                child: Text(
                  isTooLong ? context.l10n.createSharedListNameTooLong : context.l10n.createSharedListNameLimitHint,
                  style: context.textStyles.bodySmallRegular.copyWith(
                    color: isTooLong ? context.colors.errorDefault : context.colors.foregroundSoft,
                  ),
                ),
              ),
              const SizedBox(height: Spacing.$6x),
              if (isTooLong)
                AppButton(
                  buttonColorScheme: ButtonColorScheme.accentSecondary,
                  buttonType: ButtonType.secondary,
                  size: ButtonSize.large,
                  primaryLabel: context.l10n.createSharedListCloseWithoutSaving,
                  onTap: () => Navigator.of(context).pop(),
                )
              else
                AppButton(
                  buttonColorScheme: ButtonColorScheme.accentSecondary,
                  size: ButtonSize.large,
                  primaryLabel: context.l10n.createSharedListCta,
                  onTap: () {
                    final name = _controller.text.trim();
                    if (name.isEmpty) {
                      return;
                    }
                    Navigator.of(context).pop();
                    unawaited(_createAndOpen(name));
                  },
                ),
              const SizedBox(height: Spacing.$4x),
            ],
          ),
        ),
      ),
    );
  }
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

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:sheetify/sheetify.dart';

@RoutePage()
class EditMyAddressesPage extends HookConsumerWidget {
  const EditMyAddressesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useToggleSheetController(onClose: (_) => context.router.pop());

    return ToggleSheet(
      scrollController: scrollController,
      backgroundColor: context.colors.backgroundSurface4,
      safeAreaColor: context.colors.backgroundSurface4,
      dragger: SheetDragger(draggerColor: context.colors.backgroundSurface5),
      outside: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => context.router.pop(),
        child: const SizedBox.expand(),
      ),
      contentPadding: const EdgeInsets.all(Spacing.$4x),
      content: [
        ContentWrapper(
          color: context.colors.backgroundSurface1,
          children: [
            ContentRow(
              leading: Icon(SystemIcons.edit, color: context.colors.foregroundMuted),
              text: ContentRowTextOptions(
                title: context.l10n.edit,
                titleOptions: ContentRowTextOption(baseColor: context.colors.foregroundDefault),
              ),
              isDividerEnabled: true,
              onTap: () {
                // todo edit somehow
              },
            ),
            ContentRow(
              leading: Icon(GeneralIcons.trash, color: context.colors.errorDefault),
              text: ContentRowTextOptions(
                title: context.l10n.delete,
                titleOptions: ContentRowTextOption(baseColor: context.colors.errorDefault),
              ),
              onTap: () {
                // todo delete
              },
            ),
          ],
        ),
      ],
    );
  }
}

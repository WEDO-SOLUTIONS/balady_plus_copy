import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/friends_on_map/providers/shared_lists.dart';
import 'package:mapness/features/friends_on_map/ui/create_shared_list_sheet.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/shared_list_row.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/shared_lists_empty_state.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// R-96: the lists the current user owns or is a member of.
@RoutePage()
class SharedListsPage extends ConsumerWidget {
  const SharedListsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listsAsync = ref.watch(sharedListsProvider);

    return Directionality(
      textDirection: ref.watch(uiDirectionProvider),
      child: Material(
        color: context.colors.backgroundSurface4,
        child: Scaffold(
          appBar: BaladyTopBar.iconAndText(
            title: context.l10n.sharedListsTitle,
            colorEnabled: context.colors.accentDefault,
            leading: ActionModel(onPressed: () => context.router.pop(), icon: SystemIcons.arrowCornerLeftLarge),
            trailing: ActionModel(
              onPressed: () => showCreateSharedListSheet(context),
              icon: SystemIcons.plusCircleFilled,
            ),
          ),
          body: SafeArea(
            child: listsAsync.when(
              data: (lists) => lists.isEmpty
                  ? SharedListsEmptyState(onCreate: () => showCreateSharedListSheet(context))
                  : ListView.builder(
                      itemCount: lists.length,
                      itemBuilder: (context, index) {
                        final list = lists[index];
                        return SharedListRow(
                          list: list,
                          onTap: () => context.router.push(SharedListDetailRoute(listId: list.id)),
                        );
                      },
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}

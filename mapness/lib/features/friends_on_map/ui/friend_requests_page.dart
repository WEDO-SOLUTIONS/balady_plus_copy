import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/friends_on_map/models/friend_request.dart';
import 'package:mapness/features/friends_on_map/providers/friend_requests.dart';
import 'package:mapness/features/friends_on_map/ui/friends_on_map_error_dialog.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/friend_confirm_sheet.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/friend_request_item.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// R-36 (Received) + R-37 (Sent), stacked in one scrollable screen — no
/// camera-lifecycle reason to lazy-build these as tabs the way
/// `AddFriendPage` does for Scan.
@RoutePage()
class FriendRequestsPage extends ConsumerStatefulWidget {
  const FriendRequestsPage({super.key});

  @override
  ConsumerState<FriendRequestsPage> createState() => _FriendRequestsPageState();
}

class _FriendRequestsPageState extends ConsumerState<FriendRequestsPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final incomingAsync = ref.watch(incomingFriendRequestsProvider);
    final outgoingAsync = ref.watch(outgoingFriendRequestsProvider);

    return Directionality(
      textDirection: ref.watch(uiDirectionProvider),
      child: Material(
        color: context.colors.backgroundSurface4,
        child: Scaffold(
          appBar: BaladyTopBar.iconAndText(
            title: context.l10n.friendRequestsTitle,
            colorEnabled: context.colors.accentDefault,
            leading: ActionModel(onPressed: () => context.router.pop(), icon: SystemIcons.arrowCornerLeftLarge),
          ),
          body: SafeArea(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(Spacing.$4x, Spacing.$3x, Spacing.$4x, Spacing.$3x),
                  child: Text(
                    context.l10n.friendListTitle,
                    style: context.textStyles.h4SemiBold.copyWith(color: context.colors.foregroundDefault),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
                  child: BaladyTextInput.search(
                    config: BaladyInputConfig(
                      hintText: context.l10n.friendListSearchHint,
                      hintColor: context.colors.foregroundSoft,
                      onChanged: (value) => setState(() => _query = value.trim().toLowerCase()),
                    ),
                  ),
                ),
                const SizedBox(height: Spacing.$3x),
                _Section(
                  query: _query,
                  title: (count) => context.l10n.friendRequestsWaitingTitle(count),
                  emptyText: context.l10n.friendRequestsReceivedEmpty,
                  requestsAsync: incomingAsync,
                  itemBuilder: (request) => FriendRequestItem(
                    request: request,
                    onAccept: () => runFriendsOnMapAction(
                      context,
                      () => ref.read(friendRequestsControllerProvider.notifier).accept(request.id),
                    ),
                    onDecline: () => runFriendsOnMapAction(
                      context,
                      () => ref.read(friendRequestsControllerProvider.notifier).decline(request.id),
                    ),
                    onBlock: () => showFriendConfirmSheet(
                      context,
                      title: context.l10n.friendRequestBlockConfirmTitle,
                      body: context.l10n.friendRequestBlockConfirmBody(request.displayName),
                      confirmLabel: context.l10n.friendRequestBlockCta,
                      // Reads via a container from the root navigator's
                      // context rather than this page's own `ref`, in case
                      // the page is ever navigated away from while the
                      // confirm sheet is still pending — see the fix note
                      // in friend_card_sheet.dart for the bug this avoids.
                      onConfirm: () => runFriendsOnMapAction(
                        rootNavigatorKey.currentContext!,
                        () => ProviderScope.containerOf(
                          rootNavigatorKey.currentContext!,
                          listen: false,
                        ).read(friendRequestsControllerProvider.notifier).blockIncoming(request),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: Spacing.$4x),
                _Section(
                  query: _query,
                  title: (_) => context.l10n.friendRequestsSentTitle,
                  emptyText: context.l10n.friendRequestsSentEmpty,
                  requestsAsync: outgoingAsync,
                  itemBuilder: (request) => FriendRequestItem(
                    request: request,
                    onCancel: () => runFriendsOnMapAction(
                      context,
                      () => ref.read(friendRequestsControllerProvider.notifier).cancel(request.id),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String query;
  final String Function(int count) title;
  final String emptyText;
  final AsyncValue<List<FriendRequest>> requestsAsync;
  final Widget Function(FriendRequest) itemBuilder;

  const _Section({
    required this.query,
    required this.title,
    required this.emptyText,
    required this.requestsAsync,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) => requestsAsync.when(
    data: (all) {
      final requests = query.isEmpty ? all : all.where((r) => r.displayName.toLowerCase().contains(query)).toList();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
            child: Text(
              title(requests.length),
              style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
            ),
          ),
          const SizedBox(height: Spacing.$1x),
          if (requests.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x, vertical: Spacing.$2x),
              child: Text(
                emptyText,
                style: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundSoft),
              ),
            )
          else
            Column(children: requests.map(itemBuilder).toList()),
        ],
      );
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, _) => const SizedBox.shrink(),
  );
}

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/friends_on_map/models/friend.dart';
import 'package:mapness/features/friends_on_map/providers/friend_requests.dart';
import 'package:mapness/features/friends_on_map/providers/friend_search_query.dart';
import 'package:mapness/features/friends_on_map/providers/friends_list.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/friend_list_empty_state.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/friend_list_item.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// R-41/R-42/R-46: the friend list — header + count, search, empty state.
/// R-36's requests entry point (below) is the first of BR-05's hub rows to
/// actually land here — the rest (activity, shared lists, privacy,
/// notifications) still don't exist. See `friends_on_map/AGENTS.md`.
@RoutePage()
class FriendListPage extends ConsumerWidget {
  const FriendListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsAsync = ref.watch(friendsListProvider);
    final query = ref.watch(friendSearchQueryProvider);
    final incomingRequestsAsync = ref.watch(incomingFriendRequestsProvider);

    return Directionality(
      textDirection: ref.watch(uiDirectionProvider),
      child: Material(
        color: context.colors.backgroundSurface4,
        child: Scaffold(
          appBar: BaladyTopBar.iconAndText(
            title: context.l10n.friendListTitle,
            colorEnabled: context.colors.accentDefault,
            leading: ActionModel(onPressed: () => context.router.pop(), icon: SystemIcons.arrowCornerLeftLarge),
            // Persistent add-friend entry — the empty state's own CTA only
            // reaches this once the list has zero friends; once it doesn't,
            // this is the only way back in.
            trailing: ActionModel(
              onPressed: () => context.router.push(const AddFriendRoute()),
              icon: SystemIcons.plusCircleFilled,
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                // R-36: reachable regardless of whether the friend list
                // itself is empty — pending requests are independent of
                // current friend count. Shown only when any exist.
                incomingRequestsAsync.maybeWhen(
                  data: (requests) => requests.isEmpty
                      ? const SizedBox.shrink()
                      : ContentWrapper(
                          color: context.colors.backgroundSurface1,
                          children: [
                            ContentRow(
                              onTap: () => context.router.push(const FriendRequestsRoute()),
                              text: ContentRowTextOptions(
                                title: context.l10n.friendListRequestsRow(requests.length),
                              ),
                            ),
                          ],
                        ),
                  orElse: () => const SizedBox.shrink(),
                ),
                // R-45: always reachable, unlike the requests row above,
                // since a privacy-adjacent entry point shouldn't depend on
                // whether anyone is currently blocked.
                ContentWrapper(
                  color: context.colors.backgroundSurface1,
                  children: [
                    ContentRow(
                      onTap: () => context.router.push(const BlockedUsersRoute()),
                      text: ContentRowTextOptions(title: context.l10n.friendListBlockedUsersRow),
                    ),
                  ],
                ),
                Expanded(
                  child: friendsAsync.when(
                    data: (friends) =>
                        friends.isEmpty ? const FriendListEmptyState() : _buildList(context, ref, friends, query),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (_, _) => const FriendListEmptyState(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, WidgetRef ref, List<Friend> friends, String query) {
    final normalizedQuery = query.trim().toLowerCase();
    final filtered = normalizedQuery.isEmpty
        ? friends
        : friends.where((f) => f.displayName.toLowerCase().contains(normalizedQuery)).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x, vertical: Spacing.$3x),
          child: Text(
            context.l10n.friendListCount(friends.length),
            style: context.textStyles.h4SemiBold.copyWith(color: context.colors.foregroundDefault),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
          child: TextField(
            onChanged: (value) => ref.read(friendSearchQueryProvider.notifier).query = value,
            decoration: InputDecoration(
              hintText: context.l10n.friendListSearchHint,
              filled: true,
              fillColor: context.colors.backgroundSurface1,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(RadiusBorder.l),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(height: Spacing.$2x),
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Text(
                    context.l10n.friendListNoSearchResults,
                    style: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundMuted),
                  ),
                )
              : ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) => FriendListItem(friend: filtered[index]),
                ),
        ),
      ],
    );
  }
}

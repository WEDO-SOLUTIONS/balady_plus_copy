import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/features/friends_on_map/friend_elapsed_time.dart';
import 'package:mapness/features/friends_on_map/models/friend.dart';
import 'package:mapness/features/friends_on_map/providers/friends_list.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/friend_marker_avatar.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// S-17: pick one or more friends to share a place with (R-69's "one or more
/// friends" is why this is multi-select, unlike
/// `pages/favourites/favourites_picker.dart`'s single-tap-to-pop shape,
/// which this otherwise copies exactly — push, pick, pop-with-result).
@RoutePage()
class MeetupFriendPickerPage extends ConsumerStatefulWidget {
  const MeetupFriendPickerPage({super.key});

  @override
  ConsumerState<MeetupFriendPickerPage> createState() => _MeetupFriendPickerPageState();
}

class _MeetupFriendPickerPageState extends ConsumerState<MeetupFriendPickerPage> {
  final Set<String> _selectedIds = {};

  @override
  Widget build(BuildContext context) {
    final friendsAsync = ref.watch(friendsListProvider);

    return Directionality(
      textDirection: ref.watch(uiDirectionProvider),
      child: Material(
        color: context.colors.backgroundSurface4,
        child: Scaffold(
          appBar: BaladyTopBar.iconAndText(
            title: context.l10n.meetupFriendPickerTitle,
            colorEnabled: context.colors.accentDefault,
            leading: ActionModel(onPressed: () => context.router.pop(), icon: SystemIcons.arrowCornerLeftLarge),
          ),
          body: SafeArea(
            child: friendsAsync.when(
              data: (friends) => friends.isEmpty ? const _EmptyState() : _buildList(context, friends),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<Friend> friends) => Column(
    children: [
      Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.only(top: Spacing.$2x),
          itemCount: friends.length,
          itemBuilder: (context, index) {
            final friend = friends[index];
            return _FriendPickerRow(
              friend: friend,
              selected: _selectedIds.contains(friend.id),
              onChanged: (selected) => setState(() {
                if (selected) {
                  _selectedIds.add(friend.id);
                } else {
                  _selectedIds.remove(friend.id);
                }
              }),
            );
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(Spacing.$4x),
        child: SizedBox(
          width: double.infinity,
          child: AppButton(
            buttonColorScheme: ButtonColorScheme.accentSecondary,
            size: ButtonSize.large,
            primaryLabel: context.l10n.done,
            onTap: _selectedIds.isEmpty
                ? null
                : () => context.router.pop(friends.where((f) => _selectedIds.contains(f.id)).toList()),
          ),
        ),
      ),
    ],
  );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(Spacing.$4x),
      child: Text(
        context.l10n.meetupFriendPickerEmpty,
        textAlign: TextAlign.center,
        style: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundSoft),
      ),
    ),
  );
}

class _FriendPickerRow extends StatelessWidget {
  final Friend friend;
  final bool selected;
  final ValueChanged<bool> onChanged;

  const _FriendPickerRow({required this.friend, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final lastPositionAt = friend.lastPositionAt;

    return Padding(
      padding: const EdgeInsets.fromLTRB(Spacing.$4x, 0, Spacing.$4x, Spacing.$3x),
      child: ContentWrapper(
        color: context.colors.backgroundSurface1,
        children: [
          ContentRow(
            onTap: () => onChanged(!selected),
            leading: FriendMarkerAvatar(friendId: friend.id),
            text: ContentRowTextOptions(
              title: friend.displayName,
              subtitle: lastPositionAt == null
                  ? null
                  : context.l10n.friendLastSeen(friendElapsedTimeLabel(context.l10n, lastPositionAt)),
            ),
            trailing: ContentRowToggleTrailingOptions(value: selected, onChanged: onChanged),
          ),
        ],
      ),
    );
  }
}

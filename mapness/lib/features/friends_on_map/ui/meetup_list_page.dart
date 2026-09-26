import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/features/friends_on_map/models/meetup.dart';
import 'package:mapness/features/friends_on_map/providers/meetups_controller.dart';
import 'package:mapness/features/friends_on_map/providers/meetups_list.dart';
import 'package:mapness/features/friends_on_map/ui/friends_on_map_error_dialog.dart';
import 'package:mapness/features/friends_on_map/ui/open_meetup_on_map.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/meetup_list_item.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// R-69: places friends have shared, newest first. Tap opens the place on
/// the map; swipe dismisses the current user's own copy (`onDismiss`).
@RoutePage()
class MeetupListPage extends ConsumerStatefulWidget {
  const MeetupListPage({super.key});

  @override
  ConsumerState<MeetupListPage> createState() => _MeetupListPageState();
}

class _MeetupListPageState extends ConsumerState<MeetupListPage> {
  // Optimistic local hide for swipe-to-dismiss: `Dismissible` requires the
  // item gone from the tree by the next frame, but the real removal is a
  // network round-trip (`MeetupsController.dismiss`). Hiding synchronously
  // here satisfies that contract; `_dismiss` below reconciles against the
  // real list once the call resolves either way.
  final Set<String> _dismissedIds = {};

  @override
  Widget build(BuildContext context) {
    final meetupsAsync = ref.watch(receivedMeetupsProvider);

    return Directionality(
      textDirection: ref.watch(uiDirectionProvider),
      child: Material(
        color: context.colors.backgroundSurface4,
        child: Scaffold(
          appBar: BaladyTopBar.iconAndText(
            title: context.l10n.meetupListTitle,
            colorEnabled: context.colors.accentDefault,
            leading: ActionModel(onPressed: () => context.router.pop(), icon: SystemIcons.arrowCornerLeftLarge),
          ),
          body: SafeArea(
            child: meetupsAsync.when(
              data: (meetups) {
                final visible = meetups.where((m) => !_dismissedIds.contains(m.id)).toList();
                return visible.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(Spacing.$4x),
                          child: Text(
                            context.l10n.meetupListEmpty,
                            textAlign: TextAlign.center,
                            style: context.textStyles.bodyLargeRegular.copyWith(
                              color: context.colors.foregroundMuted,
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: visible.length,
                        itemBuilder: (context, index) {
                          final meetup = visible[index];
                          return MeetupListItem(
                            meetup: meetup,
                            onTap: () => openMeetupOnMap(ref, meetup),
                            onDismiss: () => _dismiss(meetup),
                          );
                        },
                      );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }

  void _dismiss(Meetup meetup) {
    setState(() => _dismissedIds.add(meetup.id));
    runFriendsOnMapAction(
      context,
      () => ref.read(meetupsControllerProvider.notifier).dismiss(meetup.id),
    ).then((_) {
      // Success: redundant, the item is already gone from the source list.
      // Failure (error dialog already shown by runFriendsOnMapAction):
      // reveals the item again so the user can retry, instead of it staying
      // hidden despite the dismiss never actually happening server-side.
      if (mounted) {
        setState(() => _dismissedIds.remove(meetup.id));
      }
    });
  }
}

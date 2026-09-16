import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/friends_on_map/models/friend.dart';
import 'package:mapness/features/friends_on_map/models/shared_list_detail.dart';
import 'package:mapness/features/friends_on_map/models/shared_list_item.dart';
import 'package:mapness/features/friends_on_map/models/shared_list_member.dart';
import 'package:mapness/features/friends_on_map/providers/shared_list_detail.dart';
import 'package:mapness/features/friends_on_map/providers/shared_lists_controller.dart';
import 'package:mapness/features/friends_on_map/ui/friends_on_map_error_dialog.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/friend_confirm_sheet.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/meetup_place_picker_sheet.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/shared_list_item_row.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/shared_list_member_row.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// One shared list's members + items. Trailing app-bar action is
/// role-conditional: owner deletes the list (R-75/AC-10), a plain member
/// leaves it (R-75).
@RoutePage()
class SharedListDetailPage extends ConsumerWidget {
  final String listId;

  const SharedListDetailPage({@PathParam('listId') required this.listId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(sharedListDetailProvider(listId));

    return Directionality(
      textDirection: ref.watch(uiDirectionProvider),
      child: Material(
        color: context.colors.backgroundSurface4,
        child: Scaffold(
          appBar: BaladyTopBar.iconAndText(
            title: detailAsync.value?.name ?? '',
            colorEnabled: context.colors.accentDefault,
            leading: ActionModel(onPressed: () => context.router.pop(), icon: SystemIcons.arrowCornerLeftLarge),
            trailing: detailAsync.maybeWhen(
              data: (detail) => detail.isOwner
                  ? ActionModel(onPressed: () => _confirmDelete(context, ref, detail), icon: GeneralIcons.trash)
                  : ActionModel(onPressed: () => _confirmLeave(context, ref, detail), icon: GeneralIcons.doorEntrance),
              orElse: () => null,
            ),
          ),
          body: SafeArea(
            child: detailAsync.when(
              data: (detail) => _buildBody(context, ref, detail),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, SharedListDetail detail) => ListView(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x, vertical: Spacing.$2x),
        child: Text(
          context.l10n.sharedListDetailMembersSectionTitle(detail.members.length),
          style: context.textStyles.h4SemiBold.copyWith(color: context.colors.foregroundDefault),
        ),
      ),
      if (detail.isOwner)
        ContentRow(
          onTap: () => _inviteMembers(context, ref, detail),
          leading: Icon(GeneralIcons.plusCircle, color: context.colors.foregroundDefault),
          text: ContentRowTextOptions(title: context.l10n.sharedListDetailInviteCta),
        ),
      ...detail.members.map(
        (member) => SharedListMemberRow(member: member, onRemove: () => _confirmRemoveMember(context, ref, member)),
      ),
      const SizedBox(height: Spacing.$4x),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x, vertical: Spacing.$2x),
        child: Text(
          context.l10n.sharedListDetailPlacesSectionTitle(detail.items.length),
          style: context.textStyles.h4SemiBold.copyWith(color: context.colors.foregroundDefault),
        ),
      ),
      ContentRow(
        onTap: () => _addPlace(context, ref),
        leading: Icon(GeneralIcons.pin, color: context.colors.foregroundDefault),
        text: ContentRowTextOptions(title: context.l10n.sharedListDetailAddPlaceCta),
      ),
      ...detail.items.map(
        (item) => SharedListItemRow(item: item, onRemove: () => _confirmRemoveItem(context, ref, item)),
      ),
    ],
  );

  // Reuses S-17's friend picker as-is, filtered client-side to exclude
  // whoever is already a member — the page stays mounted throughout (no pop
  // happens before the mutation), so using this page's own context/ref
  // directly, unlike the pop-first confirm-sheet flows below, is safe.
  Future<void> _inviteMembers(BuildContext context, WidgetRef ref, SharedListDetail detail) async {
    final currentMemberIds = detail.members.map((m) => m.accountId).toSet();
    final picked = await context.router.push<List<Friend>>(const MeetupFriendPickerRoute());
    if (picked == null || picked.isEmpty || !context.mounted) {
      return;
    }
    final newIds = picked.map((f) => f.id).where((id) => !currentMemberIds.contains(id)).toList();
    if (newIds.isEmpty) {
      return;
    }
    await runFriendsOnMapAction(
      context,
      () => ref.read(sharedListsControllerProvider.notifier).addMembers(listId, newIds),
    );
  }

  Future<void> _addPlace(BuildContext context, WidgetRef ref) async {
    final pick = await showMeetupPlacePickerSheet(context);
    if (pick == null || !context.mounted) {
      return;
    }
    await runFriendsOnMapAction(
      context,
      () => ref
          .read(sharedListsControllerProvider.notifier)
          .addItem(listId, latitude: pick.latitude, longitude: pick.longitude, label: pick.label),
    );
  }

  void _confirmRemoveMember(BuildContext context, WidgetRef ref, SharedListMember member) {
    showFriendConfirmSheet(
      context,
      title: context.l10n.sharedListRemoveMemberConfirmTitle,
      body: context.l10n.sharedListRemoveMemberConfirmBody(member.displayName),
      confirmLabel: context.l10n.sharedListRemoveCta,
      onConfirm: () => unawaited(
        runFriendsOnMapAction(
          context,
          () => ref.read(sharedListsControllerProvider.notifier).removeMember(listId, member.accountId),
        ),
      ),
    );
  }

  void _confirmRemoveItem(BuildContext context, WidgetRef ref, SharedListItem item) {
    showFriendConfirmSheet(
      context,
      title: context.l10n.sharedListRemoveItemConfirmTitle,
      body: context.l10n.sharedListRemoveItemConfirmBody,
      confirmLabel: context.l10n.sharedListRemoveCta,
      onConfirm: () => unawaited(
        runFriendsOnMapAction(
          context,
          () => ref.read(sharedListsControllerProvider.notifier).removeItem(listId, item.id),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, SharedListDetail detail) {
    showFriendConfirmSheet(
      context,
      title: context.l10n.sharedListDeleteConfirmTitle,
      body: context.l10n.sharedListDeleteConfirmBody(detail.name),
      confirmLabel: context.l10n.sharedListDeleteCta,
      onConfirm: () => unawaited(_deleteAndPop(context, ref)),
    );
  }

  void _confirmLeave(BuildContext context, WidgetRef ref, SharedListDetail detail) {
    showFriendConfirmSheet(
      context,
      title: context.l10n.sharedListLeaveConfirmTitle,
      body: context.l10n.sharedListLeaveConfirmBody(detail.name),
      confirmLabel: context.l10n.sharedListLeaveCta,
      onConfirm: () => unawaited(_leaveAndPop(context, ref)),
    );
  }

  // Delete/leave pop this page afterward — unlike remove-member/remove-item,
  // there's nothing left here worth showing once either succeeds. The
  // confirm sheet above pops only itself; this page is still mounted when
  // onConfirm runs, so its own context/ref are still safe to use here too.
  Future<void> _deleteAndPop(BuildContext context, WidgetRef ref) async {
    await runFriendsOnMapAction(context, () => ref.read(sharedListsControllerProvider.notifier).delete(listId));
    if (context.mounted) {
      context.router.pop();
    }
  }

  Future<void> _leaveAndPop(BuildContext context, WidgetRef ref) async {
    await runFriendsOnMapAction(context, () => ref.read(sharedListsControllerProvider.notifier).leave(listId));
    if (context.mounted) {
      context.router.pop();
    }
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/friends_on_map/models/conversation.dart';
import 'package:mapness/features/friends_on_map/providers/conversations.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/conversation_list_item.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// R-105: the conversation list, most recent activity first, reached from the
/// friend list.
@RoutePage()
class ConversationsPage extends ConsumerWidget {
  const ConversationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationsAsync = ref.watch(conversationsProvider);

    return Directionality(
      textDirection: ref.watch(uiDirectionProvider),
      child: Material(
        color: context.colors.backgroundSurface4,
        child: Scaffold(
          appBar: BaladyTopBar.iconAndText(
            title: context.l10n.chatConversationsTitle,
            colorEnabled: context.colors.accentDefault,
            leading: ActionModel(onPressed: () => context.router.pop(), icon: SystemIcons.arrowCornerLeftLarge),
          ),
          body: SafeArea(
            // Last known list while a refetch is in flight (see chat_page.dart).
            child: _buildBody(context, conversationsAsync),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AsyncValue<ConversationList> conversationsAsync) {
    final list = conversationsAsync.value;
    if (list == null) {
      return conversationsAsync.hasError ? const SizedBox.shrink() : const Center(child: CircularProgressIndicator());
    }
    return list.items.isEmpty
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(Spacing.$4x),
              child: Text(
                context.l10n.chatConversationsEmpty,
                textAlign: TextAlign.center,
                style: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundMuted),
              ),
            ),
          )
        : ListView.builder(
            itemCount: list.items.length,
            itemBuilder: (context, index) {
              final conversation = list.items[index];
              return ConversationListItem(
                conversation: conversation,
                onTap: () => context.router.push(
                  ChatRoute(friendId: conversation.friendId, displayName: conversation.displayName),
                ),
              );
            },
          );
  }
}

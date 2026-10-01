import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/friends_on_map/providers/chat_presence.dart';

/// Opens the conversation with [friendId]. If another chat is already open it
/// is *replaced* (not stacked under a new one), so tapping notices one after
/// another doesn't grow the back stack.
///
/// Resolves the nested `MapRoute` router from the root — see
/// `open_meetup_on_map.dart` for why a widget's own `context.router` can't be
/// trusted to reach the stack the chat route lives in.
void openChat(WidgetRef ref, {required String friendId, required String displayName}) => openChatWith(
  router: ref.read(appRouterProvider),
  openChatFriendId: ref.read(chatPresenceProvider).chatFriendId,
  friendId: friendId,
  displayName: displayName,
);

/// [openChat] for callers that must read the router/presence *before* their
/// own widget goes away (the friend card pops itself first).
void openChatWith({
  required RootStackRouter router,
  required String? openChatFriendId,
  required String friendId,
  required String displayName,
}) {
  final mapRouter = router.innerRouterOf<StackRouter>(MapRoute.name);
  if (mapRouter == null) {
    return;
  }
  final route = ChatRoute(friendId: friendId, displayName: displayName);
  if (openChatFriendId != null) {
    // Drop anything stacked above the open chat (a picker, a sheet route),
    // then swap the chat itself.
    mapRouter.popUntil((r) => r.settings.name == ChatRoute.name);
    unawaited(mapRouter.replace(route));
  } else {
    unawaited(mapRouter.push(route));
  }
}

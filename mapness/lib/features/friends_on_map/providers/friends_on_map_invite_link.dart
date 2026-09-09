import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/features/friends_on_map/providers/invite_link_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friends_on_map_invite_link.g.dart';

const String _prefsKey = 'friends_on_map_invite_link';

/// R-25: a persistent invite link that stays the same until reset. The real
/// backend remembers the current code server-side; this mocked repository
/// is stateless (see `FakeInviteLinkRepository`), so persistence has to
/// happen here instead — read the cached link on build, only calling the
/// repository to mint one the first time there isn't one yet.
@Riverpod(keepAlive: true)
class FriendsOnMapInviteLink extends _$FriendsOnMapInviteLink {
  @override
  Future<String> build() async {
    final sharedPrefs = ref.read(sharedPrefsProvider);
    final cached = sharedPrefs.getString(_prefsKey);
    if (cached != null) {
      return cached;
    }
    final link = await ref.read(inviteLinkRepositoryProvider).getInviteLink();
    await sharedPrefs.setString(_prefsKey, link);
    return link;
  }

  /// R-27: invalidates the previous link and mints a new one.
  Future<void> reset() async {
    final link = await ref.read(inviteLinkRepositoryProvider).resetInviteLink();
    await ref.read(sharedPrefsProvider).setString(_prefsKey, link);
    state = AsyncData(link);
  }
}

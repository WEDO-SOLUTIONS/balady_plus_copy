import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/features/friends_on_map/providers/friends_on_map_service_token.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friends_on_map_account_id.g.dart';

/// This device's own account id on the Friends on Map backend — the exact
/// value a friend's device receives as `Friend.id` for this account (see
/// `friends_on_map_service_token.dart`'s doc comment: it's neither the auth
/// token nor the raw device UUID sent as `username`, all three are distinct
/// strings). Used to show this device's own themed marker-illustration
/// avatar (`ui/widgets/invite_card.dart`) consistently with what friends
/// actually see, instead of a locally-computed id that would hash to a
/// different illustration than the one friends see.
@Riverpod(keepAlive: true)
class FriendsOnMapAccountId extends _$FriendsOnMapAccountId {
  @override
  Future<String> build() async {
    await ref.watch(friendsOnMapServiceTokenProvider.future);
    final prefs = ref.watch(sharedPrefsProvider);
    return prefs.getString(friendsOnMapAccountIdPrefsKey)!;
  }
}

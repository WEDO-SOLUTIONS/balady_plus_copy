import 'package:mapness/features/friends_on_map/data/meetup_repository.dart';
import 'package:mapness/features/friends_on_map/data/remote_meetup_repository.dart';
import 'package:mapness/features/friends_on_map/providers/friends_on_map_network.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'meetups_repository.g.dart';

/// keepAlive: same reasoning as `friendsRepositoryProvider` — a created or
/// dismissed meetup must survive the list screen being unmounted/remounted.
@Riverpod(keepAlive: true)
MeetupRepository meetupRepository(Ref ref) => RemoteMeetupRepository(ref.watch(friendsOnMapNetworkProvider));

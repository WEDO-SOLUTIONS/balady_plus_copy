import 'package:mapness/features/friends_on_map/models/meetup.dart';
import 'package:mapness/features/friends_on_map/providers/meetups_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'meetups_list.g.dart';

/// Places friends have shared with the current user, newest first.
@riverpod
Future<List<Meetup>> receivedMeetups(Ref ref) => ref.watch(meetupRepositoryProvider).getReceivedMeetups();

import 'package:mapness/features/friends_on_map/models/shared_list.dart';
import 'package:mapness/features/friends_on_map/providers/shared_list_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shared_lists.g.dart';

/// R-96: the lists the current user owns or is a member of.
@riverpod
Future<List<SharedList>> sharedLists(Ref ref) => ref.watch(sharedListRepositoryProvider).getLists();

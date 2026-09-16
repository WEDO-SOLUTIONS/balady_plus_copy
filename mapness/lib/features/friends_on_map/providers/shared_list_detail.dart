import 'package:mapness/features/friends_on_map/models/shared_list_detail.dart';
import 'package:mapness/features/friends_on_map/providers/shared_list_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shared_list_detail.g.dart';

/// One list's members + items, for the detail screen. A family provider —
/// riverpod_generator auto-families on the extra [listId] argument.
@riverpod
Future<SharedListDetail> sharedListDetail(Ref ref, String listId) =>
    ref.watch(sharedListRepositoryProvider).getList(listId);

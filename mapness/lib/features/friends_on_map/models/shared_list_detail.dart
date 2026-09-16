import 'package:mapness/features/friends_on_map/models/shared_list_item.dart';
import 'package:mapness/features/friends_on_map/models/shared_list_member.dart';

enum SharedListRole { owner, member }

/// The full detail view of one [SharedList] — its members and items,
/// plus [callerRole] so the UI can gate owner-only actions (delete the
/// list, invite members) without needing an account id of its own.
class SharedListDetail {
  final String id;
  final String ownerId;
  final String name;
  final DateTime createdAt;
  final SharedListRole callerRole;
  final List<SharedListMember> members;
  final List<SharedListItem> items;

  const SharedListDetail({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.createdAt,
    required this.callerRole,
    required this.members,
    required this.items,
  });

  bool get isOwner => callerRole == SharedListRole.owner;
}

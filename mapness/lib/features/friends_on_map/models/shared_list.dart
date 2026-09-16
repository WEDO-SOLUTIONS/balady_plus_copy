/// S-18: a list, collaboratively maintained by an owner + members — the
/// R-96 index row shape (name + live member/entry counts). See
/// `shared_list_detail.dart` for the full list (members + items).
class SharedList {
  final String id;
  final String ownerId;
  final String name;
  final DateTime createdAt;
  final int memberCount;
  final int itemCount;

  const SharedList({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.createdAt,
    required this.memberCount,
    required this.itemCount,
  });
}

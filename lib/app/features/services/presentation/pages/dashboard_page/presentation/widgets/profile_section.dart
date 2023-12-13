import '../../dashboard_page_exports.dart' show ProfileItem;

class ProfileSection {
  final String title;
  final List<ProfileItem> items;

  ProfileSection({
    required this.title,
    required this.items,
  });
}

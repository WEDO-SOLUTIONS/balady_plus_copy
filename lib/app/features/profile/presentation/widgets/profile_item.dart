class ProfileItem {
  final String title;
  final String icon;
  final String route;
  final bool beta;

  ProfileItem({
    required this.title,
    required this.icon,
    required this.route,
     this.beta = false,
  });
}

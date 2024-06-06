import 'package:go_router/go_router.dart';

extension RouterExtension on GoRouter {
  bool isCurrentRoute(String path) {
    final matches = routerDelegate.currentConfiguration.matches;
    return matches.last.matchedLocation == path;
  }
}
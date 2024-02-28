import 'package:flutter/widgets.dart';
import 'package:mapness/features/search/models/search_scope.dart' as models;
import 'package:provider/provider.dart';

class SearchScope extends StatelessWidget {
  const SearchScope({required this.child, required this.named, super.key});

  final String named;
  final Widget child;

  @override
  Widget build(BuildContext context) => Provider<models.SearchScope>(
        create: (_) => models.SearchScope(named),
        child: child,
      );
}

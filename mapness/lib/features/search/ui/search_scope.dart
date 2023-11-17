import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../models/search_scope.dart' as models;

class SearchScope extends StatelessWidget {
  const SearchScope({super.key, required this.child, required this.named});

  final String named;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Provider<models.SearchScope>(
      create: (_) => models.SearchScope(named),
      child: child,
    );
  }
}

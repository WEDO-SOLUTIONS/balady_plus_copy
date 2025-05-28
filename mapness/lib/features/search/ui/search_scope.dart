import 'package:flutter/widgets.dart';
import 'package:mapness/features/search/models/search_scope.dart' as models;
import 'package:provider/provider.dart';

enum SearchScopeEnum {
  map('MapSearch'),
  favourites('FavouritesSearch'),
  routes('RoutingSearch'),
  feedback('FeedbackSearch'),
  navi('NaviSearch');

  final String value;
  const SearchScopeEnum(this.value);
}

class SearchScope extends StatelessWidget {
  const SearchScope({required this.child, required this.named, super.key});

  final SearchScopeEnum named;
  final Widget child;

  @override
  Widget build(BuildContext context) => Provider<models.SearchScope>(
        create: (_) => models.SearchScope(value: named.value),
        child: child,
      );
}

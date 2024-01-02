import 'package:flutter/widgets.dart';
import 'package:mapness/app/routes/poi_map.dart';
import 'package:mapness/features/search/ui/search_history.dart';

class MapSearchHistory extends StatelessWidget {
  const MapSearchHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return SearchHistory(
      onTap: (item) {
        PoiMapRoute.open(context,item.objectId!);
      },
    );
  }
}

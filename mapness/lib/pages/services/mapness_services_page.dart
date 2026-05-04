import 'package:auto_route/annotations.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/mini_apps_list_pages.dart';
import 'package:flutter/material.dart';

@RoutePage()
class MapnessServicesPage extends StatelessWidget {
  final String? groupId;

  const MapnessServicesPage({super.key, @QueryParam('groupId') this.groupId});

  @override
  Widget build(BuildContext context) => Material(
      child: HomeMiniAppsListPages(
        key: ValueKey(Theme.of(context).brightness),
        groupId: groupId,
      ),
    );
}

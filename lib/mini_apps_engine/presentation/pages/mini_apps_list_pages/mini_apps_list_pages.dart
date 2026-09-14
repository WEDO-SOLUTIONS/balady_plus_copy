import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/cubit/new_mini_app_logic_cubit.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/mini_apps_home_screen.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/apps_group_page/apps_group_page.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/mini_apps_search_page/mini_apps_search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final GlobalKey<NavigatorState> servicesNavigatorKey = GlobalKey<NavigatorState>();

class HomeMiniAppsListPages extends StatefulWidget {
  final String? groupId;

  const HomeMiniAppsListPages({super.key, this.groupId});

  @override
  State<HomeMiniAppsListPages> createState() => _HomeMiniAppsListPagesState();
}

class _HomeMiniAppsListPagesState extends State<HomeMiniAppsListPages> {
  NewMiniAppLogicCubit get _miniAppsCubit => sl<NewMiniAppLogicCubit>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider<NewMiniAppLogicCubit>.value(value: _miniAppsCubit)],
      child: Theme(
        data: Theme.of(NavigationService.navigatorKey.currentState!.context),
        child: Navigator(
          key: servicesNavigatorKey,
          initialRoute: '/',
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/':
                debugPrint("initialRoute //////");
                return MaterialPageRoute(builder: (_) => const MiniAppsHomeScreen());

              case '/search':
                return MaterialPageRoute(builder: (_) => const MiniAppsSearchPage(), fullscreenDialog: true);

              case '/group':
                final args = settings.arguments as Map<String, dynamic>;
                return PageRouteBuilder(
                  opaque: false,
                  barrierColor: Colors.transparent,
                  pageBuilder: (_, __, ___) => AppsGroupPage(groupId: args['groupId'] as String),
                );

              default:
                return MaterialPageRoute(builder: (_) => const HomeMiniAppsListPages());
            }
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'routing/app_router.dart';

class MapnessEntryPoint extends StatelessWidget {
  final List<Widget> navigationRoutes;
  const MapnessEntryPoint(
    this.navigationRoutes, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ProviderScope(child: MapnessRoot(navigationRoutes));
  }
}

class MapnessRoot extends ConsumerWidget {
  final List<Widget> navigationRoutes;
  const MapnessRoot(this.navigationRoutes, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider(navigationRoutes));
    return Directionality(
      textDirection: TextDirection.rtl,
      child: MaterialApp.router(
        routerConfig: goRouter,
        theme: ThemeData(
          primarySwatch: Colors.green,
          unselectedWidgetColor: Colors.grey,
          appBarTheme: const AppBarTheme(
            elevation: 2.0,
            centerTitle: true,
          ),
          scaffoldBackgroundColor: Colors.grey[200],
          dividerColor: Colors.grey[400],
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

import 'package:balady_plus/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: MaterialApp.router(
        routerConfig: goRouter,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
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

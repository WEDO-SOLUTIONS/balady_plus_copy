import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocProvider, MultiBlocProvider;

import '../../../../core/services/services_exports.dart' show NavigationService;
import '../../../../core/utils/utils_exports.dart' show BottomNavBar;
import '../../bottom_navigation_exports.dart'
    show BottomNavBarCubit, BottomNavBarWidget;

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({super.key});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  late PageController _pageViewController;

  @override
  void initState() {
    super.initState();
    _pageViewController =
        PageController(initialPage: 0 /*BottomNavBar.home.index*/);
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BottomNavBarCubit>(
          create: (_) => BottomNavBarCubit(initialNavBar: 0),
        ),
      ],
      child: Scaffold(
        key: NavigationService.bottomNavKey,
        body: PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageViewController,
          itemCount: BottomNavBar.values.length,
          itemBuilder: (BuildContext context, int itemIndex) {
            return BottomNavBar.values[itemIndex].page;
          },
        ),
        bottomNavigationBar: BottomNavBarWidget(
          onSelectedBottomNavBar: (index) {
            _pageViewController.jumpToPage(index);
          },
        ),
      ),
    );
  }
}

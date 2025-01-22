import 'package:balady_plus/app/features/services/core/home_services_routes/home_services_route_names.dart';
import 'package:balady_plus/app/features/services/presentation/pages/dynamic_cards_services_screen.dart';
import 'package:balady_plus/app/features/services/presentation/pages/sub_services_screen.dart';
import 'package:flutter/widgets.dart';


class HomeServicesRoutes {

  static Map<String, Widget Function(BuildContext)> routes = {

    HomeServicesRouteName.subServicesScreen: (context) => const SubServicesScreen(),
    HomeServicesRouteName.dynamicCardsServicesScreen: (context) => const DynamicCardsServicesScreen(),

  };


}

import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/constants/app_config.dart';
import 'package:balady_plus/app/features/services/core/home_services_routes/home_services_route_names.dart';
import 'package:balady_plus/app/features/services/domain/entities/services_entity.dart';
import 'package:balady_plus/app/features/services/presentation/widgets/network_icon_based_type_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class CategoryServiceItem extends StatelessWidget {
  final ServicesCategory servicesCategory;

  const CategoryServiceItem({super.key, required this.servicesCategory});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        NavigationService.navigatorKey.currentState!.pushNamed(
          HomeServicesRouteName.subServicesScreen,
          arguments: servicesCategory.listOfServices,
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageIconBasedTypeWidget(
                icon: servicesCategory.icon,
                iconSize: 30,
              ),
              const SizedBox(height: 8),
              Text(
                servicesCategory.title,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: AppConfig.appFontType,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                "${servicesCategory.listOfServices.length} ${(servicesCategory.listOfServices.length > 10 ? "service_lase_teen" : "servicesDirectoryServicesWord").tr()}",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontFamily: AppConfig.appFontType,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

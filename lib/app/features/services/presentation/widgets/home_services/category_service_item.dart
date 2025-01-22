import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/services/core/home_services_routes/home_services_route_names.dart';
import 'package:balady_plus/app/features/services/domain/entities/services_entity.dart';
import 'package:balady_plus/app/features/services/presentation/pages/sub_services_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class CategoryServiceItem extends StatelessWidget {
  final ServicesCategory servicesCategory;
  const CategoryServiceItem({super.key, required  this.servicesCategory});

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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                IconPath.profile,
                height: 50,
              ),
              const SizedBox(height: 8),
              Text(
                servicesCategory.title,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                "${servicesCategory.listOfServices.length} ${"servicesDirectoryServicesWord".tr()}",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

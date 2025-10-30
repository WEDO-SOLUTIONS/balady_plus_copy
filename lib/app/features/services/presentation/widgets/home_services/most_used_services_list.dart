import 'package:balady_plus/app/app.dart';
import 'package:balady_plus/app/core/utils/constants/app_config.dart';
import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/features/services/domain/entities/services_entity.dart';
import 'package:balady_plus/app/features/services/presentation/widgets/home_services/most_used_service_item.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class FeatureServicesList extends StatelessWidget {
  final List<Service> mostUsedServices;

  const FeatureServicesList({
    super.key,
    required this.mostUsedServices,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "feature_services".tr(),
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontFamily: AppConfig.appFontType,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.29,
          child: Row(
            children: [
              FeatureServiceItem(
                service: Service(
                  id: "111",
                  title: 'dashboard'.tr(),
                  icon: '',
                  label: '',
                  image: ImagePath.featureServiceImage,
                  isNew: false,
                  requireLogin: true,
                  levelLogin: LevelLogin.sso,
                  order: 0,
                  actionType: ActionType.page,
                  actionValue: RouteName.DashbordDataPage,
                  subServices: [],
                  serviceId: null,
                  eventName: '',
                  requireSelectedDelegator: false,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: mostUsedServices
                        .map(
                          (service) => FeatureServiceItem(service: service),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

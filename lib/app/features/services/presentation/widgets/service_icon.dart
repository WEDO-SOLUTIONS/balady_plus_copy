import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart'
    show AppStyle, IconPath, RouteName, ServiceAction;
import '../../../_shared_feature_/shared_feature_exports.dart'
    show DrawIconBasedTypeWidget;
import '../../services_exports.dart';

class ServiceIcon extends StatelessWidget {
  final ServiceEntity service;

  const ServiceIcon({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (service.action.type == ServiceAction.cardsPage) {
          Navigator.pushNamed(
            context,
            RouteName.serviceCards,
            arguments: service,
          );
        } else if (service.action.type == ServiceAction.pageRoute) {
          Navigator.pushNamed(
            context,
            service.action.value,
          );
        }
      },
      child: Column(
        children: [
          Card(
            elevation: 4,
            shape: const CircleBorder(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  height: constraints.maxWidth - 24,
                  padding: const EdgeInsets.all(8),
                  width: double.infinity,
                  child: Center(
                    child: DrawIconBasedTypeWidget(
                      icon: IconPath.serviceIcon(service.iconName),
                      iconSize: 28,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 4),
          Text(
            service.title,
            style: AppStyle.serviceIconTextStyle,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

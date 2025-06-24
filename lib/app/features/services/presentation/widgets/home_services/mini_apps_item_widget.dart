import 'package:balady_plus/app/core/utils/constants/app_config.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/features/services/core/help_function.dart';
import 'package:balady_plus/app/features/services/domain/entities/services_entity.dart';
import 'package:balady_plus/app/features/services/presentation/widgets/network_icon_based_type_widget.dart';
import 'package:flutter/material.dart';

class MiniAppsItemWidget extends StatelessWidget {
  final Service service;

  const MiniAppsItemWidget({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
          onTap: () {
            if (service.actionValue == "smart_advisor") {
              checkIfLogin(
                context,
                service.copyWith(
                  actionValue: RouteName.chatbot,
                ),
              );
            } else {
              checkIfLogin(context, service);
            }
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ImageIconBasedTypeWidget(
                    icon: service.icon,
                    iconSize: 48,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    service.title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily:
                      AppConfig.appFontType,
                      overflow: TextOverflow.ellipsis
                    ),
                    textScaler: TextScaler.noScaling,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ),
        );
    }
}

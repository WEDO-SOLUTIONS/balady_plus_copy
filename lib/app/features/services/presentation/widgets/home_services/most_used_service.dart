import 'package:balady_plus/app/core/utils/constants/app_config.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/features/services/core/help_function.dart';
import 'package:balady_plus/app/features/services/domain/entities/services_entity.dart';
import 'package:balady_plus/app/features/services/presentation/widgets/network_icon_based_type_widget.dart';
import 'package:flutter/material.dart';

class MostUsedService extends StatelessWidget {
  final MostUsedServiceModel mostUsedService;

  const MostUsedService({
    super.key,
    required this.mostUsedService,
  });

  @override
  Widget build(BuildContext context) {
    return mostUsedService.service != null
        ? InkWell(
            onTap: () {
              if (mostUsedService.service!.actionValue == "smart_advisor") {
                checkIfLogin(
                  context,
                  mostUsedService.service!.copyWith(
                    actionValue: RouteName.chatbot,
                  ),
                );
              } else {
                checkIfLogin(context, mostUsedService.service!);
              }
            },
            child: Card(
              color: Color(int.parse("0xff${mostUsedService.color}")),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    ImageIconBasedTypeWidget(
                      icon: mostUsedService.service!.icon,
                      iconSize: 60,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      fit: FlexFit.tight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            mostUsedService.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: Colors.white,
                              fontFamily: AppConfig.appFontType,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            mostUsedService.label,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Colors.white,
                              fontFamily: AppConfig.appFontType,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}

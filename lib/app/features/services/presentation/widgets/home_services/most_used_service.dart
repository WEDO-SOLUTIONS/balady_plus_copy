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
    return InkWell(
      onTap: () {
        if(mostUsedService.service.actionValue == "smart_advisor") {
          checkIfLogin(context, mostUsedService.service);
        } else {
          checkIfLogin(context, mostUsedService.service.copyWith(
            actionValue: RouteName.chatbot,
          ));
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
                icon: mostUsedService.service.icon,
                iconSize: 50,
              ),
              const SizedBox(width: 16),
              Flexible(
                fit: FlexFit.tight,
                child: Column(
                  children: [
                    Text(
                      mostUsedService.title,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      mostUsedService.label,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}

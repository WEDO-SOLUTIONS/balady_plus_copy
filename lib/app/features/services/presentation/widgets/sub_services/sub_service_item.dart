import 'package:balady_plus/app/core/utils/constants/app_config.dart';
import 'package:balady_plus/app/features/services/core/help_function.dart';
import 'package:balady_plus/app/features/services/domain/entities/services_entity.dart';
import 'package:balady_plus/app/features/services/presentation/widgets/network_icon_based_type_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SubServiceItem extends StatelessWidget {
  final Service service;

  const SubServiceItem({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => checkIfLogin(context, service),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        margin: const EdgeInsetsDirectional.only(top: 12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              ImageIconBasedTypeWidget(
                icon: service.icon,
                iconSize: 30,
              ),
              const SizedBox(width: 16),
              Flexible(
                fit: FlexFit.tight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      service.title.tr(),
                      maxLines: 2,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w500,
                            fontFamily: AppConfig.appFontType,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      service.label.isNotEmpty
                          ? service.label.tr()
                          : service.title,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: const Color(0xff898989),
                            fontFamily: AppConfig.appFontType,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xffB2B2B2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

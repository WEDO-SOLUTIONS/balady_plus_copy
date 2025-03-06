import 'package:balady_plus/app/core/utils/constants/app_config.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/draw_icon_based_type_widget.dart';
import 'package:balady_plus/app/features/services/core/help_function.dart';
import 'package:balady_plus/app/features/services/domain/entities/services_entity.dart';
import 'package:balady_plus/app/features/services/presentation/widgets/network_icon_based_type_widget.dart';
import 'package:flutter/material.dart';

class FeatureServiceItem extends StatelessWidget {
  final Service service;

  const FeatureServiceItem({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        checkIfLogin(context, service);
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.30,
        height: double.maxFinite,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          child: Stack(
            children: [
              ImageIconBasedTypeWidget(
                icon: service.image,
                iconSize: double.maxFinite,
                fit: BoxFit.fill,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                child: Text(
                  service.title,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppConfig.appFontType,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart' show AppStyle, RouteName;
import '../../services_exports.dart' show ServiceEntity, ServiceIcon;
import 'header_with_all.dart';

class ServicesList extends StatelessWidget {
  final String title;
  final List<ServiceEntity> services;
  final int crossAxisCount;

  const ServicesList({
    super.key,
    required this.title,
    required this.services,
    this.crossAxisCount = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xffF5F7FA),
        // borderRadius: BorderRadius.all(
        //   Radius.circular(16),
        // ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderWithAll(
            text: title,
            margin: EdgeInsets.only(top: 16),
            onPressAll: () {
              NavigationService.navigatorKey.currentState!.pushNamed(
                  RouteName.SpecificServicePage,
                  arguments: (services, title));
            },
          ),
          const SizedBox(height: 16),
          Container(
            height: 100,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: services
                    .map((e) => ServiceIcon(
                          service: e,
                        ))
                    .toList(),
              ),
            ),
          ),
          /* ListView.builder(
            itemCount: services.length,
            itemBuilder: (context, index) {
              return ServiceIcon(
                service: services[index],
              );
            },
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
          ),*/
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

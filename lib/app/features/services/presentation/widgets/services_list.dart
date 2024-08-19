import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/chatbot/presentation/mvvm/chatboot_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/utils_exports.dart'
    show AppStyle, CommonFunctions, RouteName;
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
    Color backgroundColor = CommonFunctions.isFoundationDay()
        ? Color(0xffFBF8F7)
        : Color(0xffF5F7FA);

    Color? titleColor =
        CommonFunctions.isFoundationDay() ? Color(0xff1E2A36) : null;

    Color? showAllColor =
        CommonFunctions.isFoundationDay() ? Color(0xff231F20) : null;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        // borderRadius: BorderRadius.all(
        //   Radius.circular(16),
        // ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          HeaderWithAll(
            text: title,
            titleColor: titleColor,
            showAllColor: showAllColor,
            margin: EdgeInsets.only(top: 16),
            onPressAll: () {
              NavigationService.navigatorKey.currentState!.pushNamed(
                  RouteName.SpecificServicePage,
                  arguments: (services, title));
            },
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: services
                  .map(
                    (e) => e.iconName == "chat_bot"
                        ? Selector<ChatBotProvider, bool>(
                            selector: (_, provider) =>
                                provider.isEnabled,
                            builder: (_, isLoading, __) {
                              return isLoading
                                  ? ServiceIcon(service: e)
                                  : const SizedBox();
                            },
                          )
                        : ServiceIcon(service: e),
                  )
                  .toList(),
            ),
          ),

          /*  Container(
           // height: 110,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: services.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return ServiceIcon(
                    service: services[index],
                  );
                }),
          ),*/

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

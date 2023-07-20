import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/utils_exports.dart'
    show
        AppStyle,
        CommonFunctions,
        CommonProperties,
        ContextConversion,
        IconPath,
        RouteName,
        ServiceAction;
import '../../../_shared_feature_/presentation/dialogs/need_login_dialog.dart';
import '../../../_shared_feature_/shared_feature_exports.dart'
    show BottomSheetDialog, BottomSheetWithActions, DrawIconBasedTypeWidget;
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
      onTap: () async {},
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

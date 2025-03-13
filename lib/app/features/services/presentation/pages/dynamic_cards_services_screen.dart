import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/dialog_names.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/not_authorized_indivivisual.dart';
import 'package:balady_plus/app/features/services/core/home_services_routes/home_services_route_names.dart';
import 'package:balady_plus/app/features/services/domain/entities/services_entity.dart';
import 'package:balady_plus/app/features/services/presentation/mvvm/service_data_view_model.dart';
import 'package:balady_plus/app/features/services/presentation/widgets/service_cards_dynamic/service_card_desc_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DynamicCardsServicesScreen extends StatelessWidget {
  const DynamicCardsServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Service service = ModalRoute.of(context)!.settings.arguments as Service;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => ServiceDataViewModel(
            webService: sl(),
            serviceId: service.serviceId!,
          ),
        ),
      ],
      child: Scaffold(
        body: Column(
          children: [
            const Expanded(child: ServiceCardDescDynamicWidget()),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36),
                  topRight: Radius.circular(36),
                ),
                color: Colors.white,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 26),
              child: ElevatedButtonWidget.startService(
                onPressed: () async {
                  if (service.requireSelectedDelegator &&
                      CommonProperties.selectedDelegator == null) {
                    await BottomSheetDialog.showDraggableSheet(
                      context,
                      isFullHeight: false,
                      dialogKeyName: DialogName.notAuthorizedIndivisualDialog,
                      currentRouteName:
                          HomeServicesRouteName.dynamicCardsServicesScreen,
                      child:  NotAuthorizedIndivisualDialog(),
                    );
                    return;
                  } else {
                    NavigatorState navigator = Navigator.of(context);
                    navigator.pushNamed(service.actionValue);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

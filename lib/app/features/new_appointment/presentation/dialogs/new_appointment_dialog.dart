import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/features/new_appointment/data/appointment_types.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/constants.dart';
import '../widgets/image_text_container.dart';

class NewAppointmentDialog extends StatelessWidget {
  const NewAppointmentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(
              bottom: Constants.mediumPadding,
              left: Constants.semiMediumPadding,
              right: Constants.semiMediumPadding,
              top: Constants.smallPadding),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 19.0,
            mainAxisSpacing: 18.0,
          ),
          itemCount: appointmnetTypes.length,
          itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  NavigationService.navigatorKey.currentState!
                      .pushNamed(RouteName.NewAppointmentPage, arguments: null);
                },
                child: ImageTextContainer(
                    icon: appointmnetTypes[index].icon,
                    name: appointmnetTypes[index].name.tr()),
              )),
    );
  }
}

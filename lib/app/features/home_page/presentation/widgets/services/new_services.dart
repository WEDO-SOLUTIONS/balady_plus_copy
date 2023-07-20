import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../services/services_exports.dart'
    show ServicesCubit, ServicesState;
import '../../../home_exports.dart' show HomeSection, ServiceCard;

class NewServices extends StatelessWidget {
  const NewServices({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeSection(
      title: "newServices".tr(),
      isNew: true,
      child: BlocBuilder<ServicesCubit, ServicesState>(
        builder: (context, state) {
          return Column(
            children: List.generate(state.newServices.length, (index) {
              return ServiceCard(
                service: state.newServices[index],
                fullWidth: true,
              );
            }),
          );
        },
      ),
    );
  }
}

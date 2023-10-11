import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../services/services_exports.dart'
    show ServicesCubit, ServicesState;
import '../../../home_exports.dart' show HomeSection, ServiceCard;

class ImportantServices extends StatelessWidget {
  const ImportantServices({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeSection(
      title: "importantServices".tr(),
      child: SizedBox(
        height: 120,
        child: BlocBuilder<ServicesCubit, ServicesState>(
          builder: (context, state) {
            return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: state.importantServices.length,
              itemBuilder: (context, index) {
                return ServiceCard(
                  service: state.importantServices[index],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

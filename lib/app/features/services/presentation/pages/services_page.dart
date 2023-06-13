import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../_shared_feature_/shared_feature_exports.dart'
    show TabPageContainer, DefaultAppBarWidget;
import '../../services_exports.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBarWidget(
        title: "services".tr(),
        hideCloseButton: true,
      ),
      body: TabPageContainer(
        child: BlocBuilder<ServicesCubit, ServicesState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  ServicesList(
                    title: "public_services".tr(),
                    services: state.publicServices,
                    crossAxisCount: 5,
                  ),
                  const SizedBox(height: 16),
                  ServicesList(
                    title: "municipal_services".tr(),
                    services: state.municipalServices,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

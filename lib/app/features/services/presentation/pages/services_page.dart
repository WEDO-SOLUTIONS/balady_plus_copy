import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/utils_exports.dart' show AppColor, IconPath;
import '../../../_shared_feature_/shared_feature_exports.dart'
    show TabPageContainer, DefaultAppBarWidget;
import '../../../home_page/home_exports.dart' show CircleIcon;
import '../../services_exports.dart'
    show SearchServicesTextField, ServicesCubit, ServicesList, ServicesState;

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesCubit, ServicesState>(
      buildWhen: (previous, current) =>
          previous.showSearchField != current.showSearchField,
      builder: (context, state) {
        return Scaffold(
          appBar: DefaultAppBarWidget(
            title: "services".tr(),
            actions: state.showSearchField
                ? null
                : [
                    InkWell(
                      onTap: () {
                        context.read<ServicesCubit>().toggleSearchField();
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: CircleIcon(
                          backgroundColor: AppColor.primary50Light,
                          icon: IconPath.appBarSearch,
                          circleSize: 48.0,
                          iconSize: 30.0,
                        ),
                      ),
                    ),
                  ],
            bottom:
                state.showSearchField ? const SearchServicesTextField() : null,
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
      },
    );
  }
}

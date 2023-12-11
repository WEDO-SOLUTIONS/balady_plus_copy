import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/utils_exports.dart' show AppColor, IconPath;
import '../../../_shared_feature_/shared_feature_exports.dart'
    show TabPageContainer, DefaultAppBarWidget;
import '../../../home_page/home_exports.dart' show CircleIcon;
import '../../services_exports.dart'
    show SearchServicesTextField, ServicesCubit, ServicesList, ServicesState;

class NewServicesPage extends StatefulWidget {
  const NewServicesPage({super.key});

  @override
  State<NewServicesPage> createState() => _NewServicesPageState();
}

class _NewServicesPageState extends State<NewServicesPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<ServicesCubit>().checkEkramServices();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesCubit, ServicesState>(
      buildWhen: (previous, current) =>
          previous.showSearchField != current.showSearchField,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColor.white,
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
                        padding: EdgeInsetsDirectional.only(end: 20),
                        child: CircleIcon(
                          backgroundColor: AppColor.white,
                          icon: IconPath.appBarSearch,
                          circleSize: 48.0,
                          iconSize: 26,
                        ),
                      ),
                    ),
                  ],
            bottom:
                state.showSearchField ? const SearchServicesTextField() : null,
          ),
          body: BlocBuilder<ServicesCubit, ServicesState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Expanded(
                  child: Column(
                    children: [
                      if (state.islamicServices.isNotEmpty)
                        ServicesList(
                          title: "islamic_services".tr(),
                          services: state.islamicServices,
                        ),
                      if (state.customerVoiceServices.isNotEmpty)
                        ServicesList(
                          title: "customer_voice_services".tr(),
                          services: state.customerVoiceServices,
                        ),
                      if (state.municipalServicee.isNotEmpty)
                        ServicesList(
                          title: "municipal_services".tr(),
                          services: state.municipalServicee,
                        ),
                      if (state.businessLicenseServices.isNotEmpty)
                        ServicesList(
                          title: "business_license_services".tr(),
                          services: state.businessLicenseServices,
                        ),
                      ServicesList(
                        title: "honoring_the_dead_services".tr(),
                        services: state.honoringTheDeadServices,
                      ),
                      /*ServicesList(
                        title: "health_certificates_services".tr(),
                        services: state.healthCertificatesServices,
                      ),*/
                      if (state.helpServices.isNotEmpty)
                        ServicesList(
                          title: "help_services".tr(),
                          services: state.helpServices,
                        ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

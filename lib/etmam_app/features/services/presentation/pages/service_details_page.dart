import 'package:balady_plus/etmam_app/core/dependency_injection/injection_container.dart'
    show sl;
import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show AppEvents;
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show AuthStatus, CommonFunctions;
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart'
    show AuthStatus, BlocStatus;

import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show CustomLoadingWidget, CustomVerticalSpace;
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services_exports.dart'
    show
        PreviousWorksWidgets,
        ProviderDetailsHeader,
        ServiceDetailsBloc,
        ServiceDetailsResponse,
        ServiceDetailsState,
        ServiceFaqSection,
        ServiceInfoWidget,
        ServiceProviderMainInfo;
import '../widgets/service_provider_details_widgets/service_details_buttons.dart';

class ServiceDetailsPage extends StatefulWidget {
  ServiceDetailsResponse serviceDetailsResponse;

  ServiceDetailsPage({Key? key, required this.serviceDetailsResponse})
      : super(key: key);

  @override
  State<ServiceDetailsPage> createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  @override
  void initState() {
    super.initState();
    //CommonFunctions.sendEventToAnalytics(AppEvents.ServiceDetails);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
      create: (context) => ServiceDetailsBloc(
          response: widget.serviceDetailsResponse, getRelations: sl()),
      child: BlocConsumer<ServiceDetailsBloc, ServiceDetailsState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Column(children: [
                // ProviderDetailsHeader(
                //   imageUrl: state.response.provider?.logoUrl ?? "",
                //   providerName: state.response.provider?.name ?? "",
                // ),
                const Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ServiceProviderMainInfo(),
                        // CustomVerticalSpace(height: 12),
                        ServiceInfoWidget(),
                        ServiceFaqSection(),
                        PreviousWorksWidgets(),
                        CustomVerticalSpace(height: 24),
                      ],
                    ),
                  ),
                ),
                const ServiceDetailsButton(),
              ]),
              BlocBuilder<EntryPointCubit, EntryPointState>(
                  bloc: sl(),
                  builder: (context, authState) {
                    return (state.status == BlocStatus.loading ||
                            authState.status == AuthStatus.loading)
                        ? const CustomLoadingWidget()
                        : Container();
                  })
            ],
          );
        },
      ),
    ));
  }
}

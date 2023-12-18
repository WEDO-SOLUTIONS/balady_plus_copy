import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';

import 'package:balady_plus/app/core/utils/enums/enums.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';

import 'package:balady_plus/app/features/services/services_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/constants/dialog_names.dart';
import '../../../_shared_feature_/presentation/dialogs/need_login_dialog.dart';
import '../../../_shared_feature_/presentation/dialogs/not_authorized_indivivisual.dart';
import '../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../commercial_license_details/data/models/commercial_licence_details.dart';
import '../../data/models/service_card.dart';
import '../blocs/permit_tobacco_bloc.dart';

class PermitsTobaccoLicenseStartService extends StatefulWidget {
  const PermitsTobaccoLicenseStartService({Key? key}) : super(key: key);

  @override
  State<PermitsTobaccoLicenseStartService> createState() =>
      _PermitsTobaccoLicenseStartServiceState();
}

class _PermitsTobaccoLicenseStartServiceState
    extends State<PermitsTobaccoLicenseStartService> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // CommonFunctions.sendEventToAnalytics(AppEvents.renewCommercialLicenseOpen);
  }

  @override
  Widget build(BuildContext context) {
    ServiceEntity service = permitsTobaccoModel();
    CommercialLicenceDetails? commercialLicenceDetails =
        ModalRoute.of(context)!.settings.arguments as CommercialLicenceDetails;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ServiceCardsCubit(service),
        ),
        BlocProvider(
          create: (context) => PermitTobaccoLicenseBloc(
              licenseId: commercialLicenceDetails.licenseInfo?.licenseId,
              commercialLicenceDetails: commercialLicenceDetails),
        ),
      ],
      child: BlocConsumer<PermitTobaccoLicenseBloc, PermitTobaccoLicenseState>(
          listener: (context, state) {
        if (state.status == BlocStatus.failure) {
          CommonFunctions.showError(state.error ?? "");
        }
      }, builder: (context, state) {
        return Scaffold(
          appBar: DefaultAppBarWidget(
            title: service.title,
            bottom: ServiceCardsList(
              cards: service.cards,
            ),
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  const Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 16),
                        ServiceCardDescription(),
                      ],
                    ),
                  ),
                  SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButtonWidget.startService(
                        onPressed: () async {
                          if (CommonProperties.isLoggedIn) {
                            context
                                .read<PermitTobaccoLicenseBloc>()
                                .add(const ValidatePermitEvent());
                          } else {
                            showDialog(
                                context: context,
                                builder: (ctx) => NeedLoginDialog(
                                        onSuccessLogin:
                                            (bool? isSuccess) async {
                                      if (isSuccess ?? false) {
                                        context
                                            .read<PermitTobaccoLicenseBloc>()
                                            .add(const ValidatePermitEvent());
                                      }
                                    }));
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
              if (state.status == BlocStatus.loading)
                const CustomCircularLoadingWidget(),
            ],
          ),
        );
      }),
    );
  }
}

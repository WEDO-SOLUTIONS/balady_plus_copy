import 'package:balady_plus/app/commercial_model/features/comercial_license_renew/presentation/commercial_license/widgets/cr_header_desc.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../blocs/posters_license_bloc.dart';
import '../../widgets/license_widgets/license_item_widget.dart';
import '../../widgets/previous_next_button.dart';

class PostersStep1Page extends StatelessWidget {
  const PostersStep1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostersLicenseBloc, PostersLicenseState>(
        builder: (context, state) {
      return Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (state.alertsStatus == BlocStatus.failure)
                          ReloadWidget(onTab: () {
                            context
                                .read<PostersLicenseBloc>()
                                .add(const GetPostersAlertsEvent());
                          }),
                        ...[
                          CRHeaderDesc(
                            header: "posters_licenses_list".tr(),
                            desc: state
                                    .ALERT_CALCULATION_DEPENDS_ON_MUNICIPALITY() ??
                                "",
                            maxLines: 3,
                          ),
                          const SizedBox(height: 12),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.selectedLicenses?.length ?? 0,
                              itemBuilder: (ctx, index) {
                                return PostersLicenseItemWidget(
                                  onDelete:
                                      (state.selectedLicenses?.length ?? 0) > 1
                                          ? () {
                                              context
                                                  .read<PostersLicenseBloc>()
                                                  .add(
                                                      DeleteLicenseFromRequestEvent(
                                                          index: index));
                                            }
                                          : null,
                                  licenseNo: state
                                      .selectedLicenses?[index].licenseId
                                      .toString(),
                                  location:
                                      "${state.selectedLicenses?[index].subMunicipalityName.toString()}, ${state.selectedLicenses?[index].municipalityName.toString()}",
                                  status:
                                      state.selectedLicenses?[index].statusName,
                                  expiryDate: state.selectedLicenses?[index]
                                      .licenseExpirationDate,
                                );
                              }),
                        ]
                      ],
                    ),
                  ),
                ),
              ),
              PostersPreviousNextButtons(
                isBtnDisabled: false,
                onPressed: () {
                  if (state.licenseId != null) {
                    context
                        .read<PostersLicenseBloc>()
                        .add(const GoToNextPageEvent());
                  } else {
                    context
                        .read<PostersLicenseBloc>()
                        .add(const AddIndividualRequestsEvent());
                  }
                },
              ),
            ],
          ),
          if (state.status.isSubmissionLoading ||
              state.alertsStatus.isSubmissionLoading)
            const CustomCircularLoadingWidget(),
        ],
      );
    });
  }
}

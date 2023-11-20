import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../comercial_license_renew/presentation/commercial_license/widgets/cr_header_desc.dart';
import '../../../../vd/presentation/widgets/details_widgets/incident_desc_widgets/vd_create_incident_addetional_fields.dart';
import '../../blocs/posters_license_bloc.dart';

class PostersStep2Page extends StatelessWidget {
  const PostersStep2Page({super.key});

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
                        CRHeaderDesc(
                            header: "posters_data",
                            desc: state.getPosterDataDesc()),
                        const SizedBox(height: 12),
                        HijriCalendarAddetionalField(
                          fieldName: "posters_permit_start_date".tr(),
                          isMandatory: true,
                          onChanged: (value) {
                            context
                                .read<PostersLicenseBloc>()
                                .add(ChangePermitStartDate(date: value));
                          },
                        ),
                        CustomTextFieldWidget(
                          label: "posters_permit_duration".tr(),
                          onChanged: (String? value) {
                            context
                                .read<PostersLicenseBloc>()
                                .add(ChangePermitDurationEvent(value: value));
                          },
                        ),
                        /* ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.selectedLicenses?.length ?? 0,
                            itemBuilder: (ctx, index) {
                              return PostersLicenseItemWidget();
                            })*/
                      ],
                    ),
                  ),
                ),
              ),
              /*  PostersPreviousNextButtons(
                isBtnDisabled: false,
                onPressed: () {
                  //  context.read<MapBloc>().add(const SaveLocationDataEvent());
                },
              ),*/
            ],
          ),
          // if (state.status.isSubmissionLoading)
          //   const CustomCircularLoadingWidget(),
        ],
      );
    });
  }
}

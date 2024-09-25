import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/vd/presentation/widgets/details_widgets/incident_desc_widgets/vd_create_incident_addetional_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:hijri/hijri_calendar.dart';

import '../../../../../../features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import 'package:balady_plus/app/commercial_model/features/comercial_license_renew/presentation/commercial_license/widgets/cr_header_desc.dart';
import '../../../domain/entities/poster_item.dart';
import '../../blocs/posters_license_bloc.dart';
import '../../widgets/previous_next_button.dart';
import '../../widgets/steps/step2/add_poster_dialog.dart';
import '../../widgets/steps/step2/poster_area_count_widget.dart';
import '../../widgets/steps/step2/poster_item_widget.dart';

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
                            header: "posters_data".tr(),
                            maxLines: 10,
                            desc: state.ALERT_SERVICE_USAGE_GUIDANCE()),
                        const SizedBox(height: 12),
                        HijriCalendarAddetionalField(
                          fieldName: "posters_permit_start_date".tr(),
                          isMandatory: true,
                          currentVlaue: state.startDate,
                          minValue: HijriCalendar.now(),
                          onChanged: (value) {
                            context
                                .read<PostersLicenseBloc>()
                                .add(ChangePermitStartDate(date: value));
                          },
                        ),
                        CustomTextFieldWidget(
                          label: "posters_permit_duration".tr(),
                          initialValue: state.duration,
                          isDigitsOnly: true,
                          suffixIcon: Text("lbl_day".tr()),
                          keyboardType: TextInputType.number,
                          onChanged: (String? value) {
                            context
                                .read<PostersLicenseBloc>()
                                .add(ChangePermitDurationEvent(value: value));
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        PosterAreaCountWidget(
                          area: state.totalPostersArea(),
                          count: state.totalPostersCount(),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.posters?.length ?? 0,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (ctx, index) {
                              return PosterItemWidget(
                                index: index + 1,
                                item: state.posters![index],
                                onDelete: () {
                                  context
                                      .read<PostersLicenseBloc>()
                                      .add(DeletePosterEvent(index: index));
                                },
                                onEdit: () async {
                                  await BottomSheetDialog.showDraggableSheet(
                                      context,
                                      isFullHeight: true,
                                      child: BlocProvider.value(
                                          value: context
                                              .read<PostersLicenseBloc>(),
                                          child: AddPosterDialog(
                                            item: state.posters![index],
                                            onAdd: (PosterItem item) {
                                              context
                                                  .read<PostersLicenseBloc>()
                                                  .add(AddPosterItemEvent(
                                                      index: index,
                                                      item: item));
                                            },
                                          )));
                                },
                              );
                            }),
                        ElevatedButtonWidget.primaryCustomBorder(
                            onPressed: () async {
                              await BottomSheetDialog.showDraggableSheet(
                                  context,
                                  isFullHeight: true,
                                  child: BlocProvider.value(
                                      value: context.read<PostersLicenseBloc>(),
                                      child: AddPosterDialog(
                                        onAdd: (PosterItem item) {
                                          context
                                              .read<PostersLicenseBloc>()
                                              .add(AddPosterItemEvent(
                                                  item: item));
                                        },
                                      )));
                            },
                            text: "posters_add".tr())
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              PostersPreviousNextButtons(
                isBtnDisabled: !state.isStep2Valid(),
                onPressed: () {
                  context
                      .read<PostersLicenseBloc>()
                      .add(const SavePostersInfo());
                },
              ),
            ],
          ),
          if (state.status.isSubmissionLoading)
            const CustomCircularLoadingWidget(),
        ],
      );
    });
  }
}

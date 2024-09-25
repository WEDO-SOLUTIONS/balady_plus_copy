import 'package:balady_plus/app/commercial_model/features/commercial_license/presentation/step3/widgets/map_widgets/cr_header_desc_widget.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_cancel/presentation/commercial_license_cancel/widgets/widget_title_invoice.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/summery_widgets/field_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../../features/_shared_feature_/presentation/cards/expandable_card.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/undertaking_widget.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/summery_widgets/field_data.dart';
import '../../../data/models/poster_request_details_model.dart';
import '../../widgets/license_widgets/license_item_widget.dart';
import '../../widgets/previous_next_button.dart';
import 'package:collection/collection.dart';

import '../../../../../../features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../blocs/posters_license_bloc.dart';
import '../../widgets/steps/step2/poster_view_item_widget.dart';

class PostersStep3Page extends StatefulWidget {
  const PostersStep3Page({super.key});

  @override
  State<PostersStep3Page> createState() => _PostersStep3PageState();
}

class _PostersStep3PageState extends State<PostersStep3Page> {
  @override
  void initState() {
    super.initState();

    context
        .read<PostersLicenseBloc>()
        .add(const GetPosterRequestDetailsEvent());
  }

  bool isAgreement = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostersLicenseBloc, PostersLicenseState>(
      builder: (context, state) {
        return Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 24, left: 16, right: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VdHeaderDesc(
                      header: ("review_request").tr(),
                    ),
                    const Step1SummeryWidget(),
                    const CustomVerticalSpace(height: 16),
                    const Step2SummeryWidget(),
                    const CustomVerticalSpace(height: 16),
                    UndertakingWidget(
                      text: "posters_agreement_title".tr(),
                      desc: "posters_agreement_desc".tr(),
                      onChange: (value) {
                        context
                            .read<PostersLicenseBloc>()
                            .add(ToggleAgreementEvent(agreement: value));
                      },
                      initialValue: state.agreement ?? false,
                    ),
                    CustomVerticalSpace(height: 250),
                  ],
                ),
              ),
            ),
            const Align(
                alignment: Alignment.bottomCenter, child: CalcualtorWidget()),
            if (state.status.isSubmissionLoading ||
                state.detailsStatus == BlocStatus.loading)
              const CustomCircularLoadingWidget(),
          ],
        );
      },
    );
  }
}

class Step1SummeryWidget extends StatelessWidget {
  const Step1SummeryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostersLicenseBloc, PostersLicenseState>(
      builder: (context, state) {
        return ExpandableCard(
          title: ("posters_licenses_list").tr(),
          icon: IconPath.vdSummuryDesc,
          children: [
            const CustomVerticalSpace(height: 16),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.selectedLicenses?.length ?? 0,
                itemBuilder: (ctx, index) {
                  return PostersLicenseItemWidget(
                    backgroundColor: Color(0x80E6EFEF),
                    onDelete: (state.selectedLicenses?.length ?? 0) > 1
                        ? () {
                            context.read<PostersLicenseBloc>().add(
                                DeleteLicenseFromRequestEvent(index: index));
                          }
                        : null,
                    licenseNo:
                        state.selectedLicenses?[index].licenseId.toString(),
                    location:
                        "${state.selectedLicenses?[index].subMunicipalityName.toString()}, ${state.selectedLicenses?[index].municipalityName.toString()}",
                    status: state.selectedLicenses?[index].statusName,
                    expiryDate:
                        state.selectedLicenses?[index].licenseExpirationDate,
                  );
                }),
          ],
        );
      },
    );
  }
}

class Step2SummeryWidget extends StatelessWidget {
  const Step2SummeryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostersLicenseBloc, PostersLicenseState>(
      builder: (context, state) {
        List<Widget> posters = [
          const CustomVerticalSpace(
            height: 16,
          ),
          FieldData(
            title: "posters_permit_start_date".tr(),
            subTitle: state.startDate,
          ),
          const CustomVerticalSpace(
            height: 16,
          ),
          FieldData(
            title: "posters_permit_duration".tr(),
            subTitle: state.duration,
          ),
          const CustomVerticalSpace(
            height: 16,
          )
        ];

        posters.addAll((state.posters ?? []).mapIndexed((i, e) {
          return PosterViewItemWidget(
            index: i + 1,
            showTitle: true,
            item: Poster(
                posterName: e.name,
                width: e.width,
                length: e.length,
                typeName: e.posterType?.name,
                typeId: e.posterType?.id,
                area: ((e.length ?? 0) * (e.width ?? 0)),
                attachments: e.attachedDocuments
                    ?.map((e) => Attachment(
                        id: e.id,
                        typeId: e.posterTypeId,
                        key: e.key,
                        name: e.name,
                        originFileName: e.fileName,
                        attachUrl: e.filePath))
                    .toList()),
            showChangeImage: false,
          );
        }).toList());
        return ExpandableCard(
          title: ("posters_data").tr(),
          icon: IconPath.vdSummuryDesc,
          children: posters,
        );
      },
    );
  }
}

class CalcualtorWidget extends StatefulWidget {
  const CalcualtorWidget({super.key});

  @override
  State<CalcualtorWidget> createState() => _CalcualtorWidgetState();
}

class _CalcualtorWidgetState extends State<CalcualtorWidget> {
  bool showCostsInfo = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostersLicenseBloc, PostersLicenseState>(
      builder: (context, state) {
        return Container(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.darkSlateBlue6,
                      offset: Offset(0, -4),
                      blurRadius: 32,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          child: CustomTextWidget(
                            "lbl_total_price".tr(),
                            fontColor: AppColor.blackModern900Light,
                            fontSize: 16,
                            fontWeight: AppFontWeight.bold,
                          ),
                        ),
                        CustomTextButtonWidget(
                          text: showCostsInfo
                              ? "hide_info".tr()
                              : "show_details".tr(),
                          btnTextSize: 14,
                          onPressed: () {
                            setState(() {
                              showCostsInfo = !showCostsInfo;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        CustomTextWidget(
                          state.requestDetails?.costCalculationInfo?.totalCost
                                  .toString() ??
                              "",
                          textStyle: AppStyle.boardingTitle
                              .copyWith(color: AppColor.primary900Light),
                        ),
                        const SizedBox(width: 3),
                        CustomTextWidget(
                          "sar_text".tr(),
                          textStyle: AppStyle.tagTextStyle,
                        ),
                      ],
                    ),
                    if (showCostsInfo == true) ...[
                      /////////////////////////////////////////////////////////
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: WidgetTitleInvoice(
                          money:
                              '${state.requestDetails?.costCalculationInfo?.licensesCount}',
                          title:
                              '${state.requestDetails?.costCalculationInfo?.licensesCountDescription}',
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: WidgetTitleInvoice(
                          money:
                              '${state.requestDetails?.costCalculationInfo?.postersCount}',
                          title:
                              '${state.requestDetails?.costCalculationInfo?.postersCountDescription}',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: WidgetTitleInvoice(
                          money:
                              '${state.requestDetails?.costCalculationInfo?.postersAreaSum} ${"poster_cm2".tr()}',
                          title:
                              '${state.requestDetails?.costCalculationInfo?.postersAreaSumDescription}',
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: WidgetTitleInvoice(
                          money:
                              '${state.requestDetails?.costCalculationInfo?.durationInDays ?? 0}',
                          title:
                              '${state.requestDetails?.costCalculationInfo?.durationInDaysDescription}',
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: ShapeDecoration(
                          color: AppColor.primary100Light,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: CustomTextWidget(
                          "posters_desc".tr(),
                          fontColor: Color(0xFF52525B),
                          fontSize: 12,
                          height: 1.4,
                          fontWeight: AppFontWeight.bold,
                          maxLines: 10,
                        ),
                      ),
                    ],
                    /* */
                  ],
                ),
              ),
              Container(
                color: AppColor.white,
                child: PostersPreviousNextButtons(
                  isBtnDisabled: !(state.agreement ?? false),
                  onPressed: () {
                    context
                        .read<PostersLicenseBloc>()
                        .add(const SubmitPosterEvent());
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

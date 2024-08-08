import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/ekram/presentation/widgets/ekram_book_cemetry/pledges_summury_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/services/local/helpers.dart';
import '../../../../_shared_feature_/presentation/cards/expandable_card.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/radio_buttons/custom_check_box_widget.dart';
import '../../../../new_appointment/presentation/core/models/lookup_list_model.dart';
import '../../../../vd/presentation/widgets/summery_widgets/field_data.dart';
import '../../../../vd/presentation/widgets/vd_header_desc_widget.dart';
import '../../blocs/ekram_book_cemetry/ekram_book_cemetry_bloc.dart';
import 'cemetry_previous_next_buttons.dart';

class AgreementSection extends StatelessWidget {
  const AgreementSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkramBookCemetryBloc, EkramBookCemetryState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                // controller: _scrollController,
                child: Container(
                  margin: EdgeInsets.only(top: 24, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VdHeaderDesc(
                        header: ("review_request").tr(),
                      ),
                      const ApplicationInfo(),
                      const CustomVerticalSpace(
                        height: 16,
                      ),
                      const DeceasedInfo(),
                      const CustomVerticalSpace(
                        height: 16,
                      ),
                      const PledgesSummuryWidget()
                    ],
                  ),
                ),
              ),
            ),
            CemetryreviousNextButtons(
              isBtnDisabled: !state.isNextButtonEnabled(),
              onPressed: () {
                context.read<EkramBookCemetryBloc>().add(SubmitRequestEvent());
              },
            )
          ],
        );
      },
    );
  }
}

class ApplicationInfo extends StatelessWidget {
  const ApplicationInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkramBookCemetryBloc, EkramBookCemetryState>(
        builder: (context, state) {
      return ExpandableCard(
        title: Helpers.translatingWord("ApplicantInfo"),
        icon: IconPath.vdSummuryUserInfo,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomVerticalSpace(
                height: 16,
              ),
              FieldData(
                title: Helpers.translatingWord("ekramFullName"),
                subTitle: state.fullName,
              ),
              const CustomVerticalSpace(
                height: 16,
              ),
              FieldData(
                title: Helpers.translatingWord("ekramMobile"),
                subTitle: state.mobileNumber,
              ),
              const CustomVerticalSpace(
                height: 16,
              ),
              FieldData(
                title: Helpers.translatingWord("ekramRelationShip"),
                subTitle: state.relation,
              ),

/*CustomTitleSubtitleCardWidget(
                    horizontalPadding: Constants.smallPadding,
                    title: Helpers.translatingWord("ekramRelationShip"),
                    subtitle: relation,
                  ),*/
            ],
          )
        ],
      );
    });
  }
}

class DeceasedInfo extends StatelessWidget {
  const DeceasedInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkramBookCemetryBloc, EkramBookCemetryState>(
        builder: (context, state) {
      return ExpandableCard(
        title: Helpers.translatingWord("deceasedInfo"),
        icon: IconPath.vdSummurySPL,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomVerticalSpace(
                height: 16,
              ),
              FieldData(
                title: Helpers.translatingWord("is_dead_fetus"),
                subTitle: state.isFetus == true ? "yes".tr() : "no".tr(),
              ),
              const CustomVerticalSpace(
                height: 16,
              ),
              if (state.isFetus == false) ...[
                FieldData(
                  title: Helpers.translatingWord("cemetry_national_type"),
                  subTitle: state.selectedNationalType?.name,
                ),
                const CustomVerticalSpace(
                  height: 16,
                ),
                FieldData(
                  title: Helpers.translatingWord("cemetry_national_id"),
                  subTitle: state.deceassedId,
                ),
                const CustomVerticalSpace(
                  height: 16,
                ),
                FieldData(
                  title: Helpers.translatingWord("cemetry_dob_hijri"),
                  subTitle: state.deceassedDOBHijri,
                ),
                const CustomVerticalSpace(
                  height: 16,
                ),
                FieldData(
                  title: Helpers.translatingWord("cemetry_dob_gorgian"),
                  subTitle: state.deceassedDOBGorgian,
                ),
                const CustomVerticalSpace(
                  height: 16,
                ),
              ],
              FieldData(
                title: Helpers.translatingWord("ekram_first_name"),
                subTitle: state.firstName,
              ),
              const CustomVerticalSpace(height: 16),
              FieldData(
                title: Helpers.translatingWord("ekram_second_name"),
                subTitle: state.secondName,
              ),
              const CustomVerticalSpace(height: 16),
              FieldData(
                title: Helpers.translatingWord("ekram_third_name"),
                subTitle: state.thirdName,
              ),
              const CustomVerticalSpace(height: 16),
              FieldData(
                title: Helpers.translatingWord("ekram_fourth_name"),
                subTitle: state.fourthName,
              ),
              const CustomVerticalSpace(height: 16),
              FieldData(
                title: Helpers.translatingWord("nationality"),
                subTitle: state.selectedNationality?.name,
              ),
              const CustomVerticalSpace(height: 16),
              FieldData(
                title: Helpers.translatingWord("ekramReligion"),
                subTitle: state.isMuslim == false
                    ? ("non_muslim").tr()
                    : ("muslim").tr(),
              ),
              const CustomVerticalSpace(height: 16),
              FieldData(
                title: ("sex").tr(),
                subTitle: state.gender == 'FEMALE' ? ("female").tr() : ("male").tr(),
              ),
              const CustomVerticalSpace(height: 16),
              FieldData(
                title: Helpers.translatingWord("ekram_death_country"),
                subTitle: state.selectedCountry?.name,
              ),
              if (state.selectedCountry?.localCountry == true) ...[
                const CustomVerticalSpace(height: 16),
                FieldData(
                  title: Helpers.translatingWord("ekram_death_city"),
                  subTitle: state.selectedDeathCity?.name,
                ),
              ],
              if (state.selectedCountry?.localCountry == false) ...[
                const CustomVerticalSpace(height: 16),
                FieldData(
                  title: Helpers.translatingWord("ekram_death_city"),
                  subTitle: state.otherDeathCity,
                ),
              ],
              const CustomVerticalSpace(height: 16),
              FieldData(
                title: Helpers.translatingWord("cemetry_deceassed_burial_city"),
                subTitle: state.selectedCity?.name,
              ),
              const CustomVerticalSpace(height: 16),
              FieldData(
                title: Helpers.translatingWord(
                    "cemetry_deceassed_burial_date_hijri"),
                subTitle: state.burialDateHijri,
              ),
              const CustomVerticalSpace(height: 16),
              FieldData(
                title: Helpers.translatingWord(
                    "cemetry_deceassed_burial_date_gorgian"),
                subTitle: state.burialDateGorgian,
              ),
              const CustomVerticalSpace(height: 16),
              FieldData(
                title: Helpers.translatingWord("cemetry_deceassed_burial_time"),
                subTitle: state.selectedTime?.name,
              ),
              const CustomVerticalSpace(height: 16),
              FieldData(
                title: Helpers.translatingWord("cemetry_deceassed_epidamic"),
                subTitle:
                    state.isPandemicDeath == true ? "yes".tr() : "no".tr(),
              ),
              const CustomVerticalSpace(height: 16),
              FieldData(
                title: Helpers.translatingWord("cemetry_type"),
                subTitle: state.selectedCemetryType?.name,
              ),
              const CustomVerticalSpace(height: 16),
              FieldData(
                title: Helpers.translatingWord("cemetry_name"),
                subTitle: state.selectedCemetry?.name,
              ),
            ],
          )
        ],
      );
    });
  }
}

class BurialInfo extends StatelessWidget {
  const BurialInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkramBookCemetryBloc, EkramBookCemetryState>(
        builder: (context, state) {
      return ExpandableCard(
        title: Helpers.translatingWord("burialInfo"),
        icon: IconPath.vdSummuryDesc,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomVerticalSpace(
                height: 16,
              ),
              FieldData(
                title: Helpers.translatingWord("burialDate"),
                subTitle: state.burialDateHijri,
              ),
              const CustomVerticalSpace(
                height: 16,
              ),
              FieldData(
                title: Helpers.translatingWord("burialTime"),
                subTitle: state.selectedTime?.name,
              ),
              const CustomVerticalSpace(
                height: 16,
              ),
            ],
          )
        ],
      );
    });
  }
}

class CemetryInfo extends StatelessWidget {
  final String? type;
  final String? size;
  final String? name;

  const CemetryInfo({Key? key, this.type, this.size, this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      title: Helpers.translatingWord("cemetry_info"),
      icon: IconPath.vdSummuryDesc,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FieldData(
              title: Helpers.translatingWord("cemetry_type"),
              subTitle: type,
            ),
            /* CustomTitleSubtitleCardWidget(
                horizontalPadding: Constants.smallPadding,
                title: Helpers.translatingWord("cemetry_size"),
                subtitle: size,
              ),
            CustomTitleSubtitleCardWidget(
                horizontalPadding: Constants.smallPadding,
                title: Helpers.translatingWord("cemetry_name"),
                subtitle: name,
              ),*/ /*
CustomTitleSubtitleCardWidget(
                horizontalPadding: Constants.smallPadding,
                title: Helpers.translatingWord("ekramReligion"),
                subtitle: religion,
              ), */
          ],
        )
      ],
    );
  }
}

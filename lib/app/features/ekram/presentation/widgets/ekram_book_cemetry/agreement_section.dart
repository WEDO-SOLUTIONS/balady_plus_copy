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
                      ApplicationInfo(),
                      const CustomVerticalSpace(
                        height: 16,
                      ),
                      DeceasedInfo(),
                      const CustomVerticalSpace(
                        height: 16,
                      ),
                      BurialInfo(),
                      const CustomVerticalSpace(
                        height: 16,
                      ),
                      PledgesSummuryWidget()
                    ],
                  ),
                ),
              ),
            ),
            CemetryreviousNextButtons(
              isBtnDisabled: !state.isNextButtonEnabled(),
              onPressed: () {
                context.read<EkramBookCemetryBloc>().add(GoToNextPageEvent());
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
              if (state.isFetus == false) ...[
                FieldData(
                  title: Helpers.translatingWord("deceasedName"),
                  subTitle: state.userInfoResponse?.fullName,
                ),
                const CustomVerticalSpace(
                  height: 16,
                ),
                FieldData(
                  title: Helpers.translatingWord("ekramGender"),
                  subTitle: state.userInfoResponse?.genderDescription,
                ),
                const CustomVerticalSpace(
                  height: 16,
                ),
                FieldData(
                  title: Helpers.translatingWord("ekramNationality"),
                  subTitle: state.userInfoResponse?.nationalityDescription,
                ),
                const CustomVerticalSpace(
                  height: 16,
                ),
                FieldData(
                  title: Helpers.translatingWord("ekramReligion"),
                  subTitle: state.userInfoResponse?.religionDescription,
                )
              ],
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

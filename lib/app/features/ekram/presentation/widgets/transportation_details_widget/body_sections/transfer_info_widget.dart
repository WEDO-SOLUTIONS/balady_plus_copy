import 'package:balady_plus/app/features/ekram/presentation/blocs/driver_extra_data_bloc/extra_data_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../_shared_feature_/presentation/widgets/custom_enhanced_expansion_panel_widget.dart';

class TransferInfoWidget extends StatelessWidget {
  const TransferInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExtraDataBloc, ExtraDataState>(
      builder: (context, state) {
        return CustomEnhancedExpansionPanelWidget(
          expanded: true,
          underline: false,
          title: "ekram_order_info".tr(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*CustomTitleSubtitleCardWidget(
                horizontalPadding: Constants.smallPadding,
                title: Helpers.translatingWord("ekramDate"),
                subtitle: ' 2021 / 1 / 5',
              ),*/
              /*  CustomTitleSubtitleCardWidget(
                horizontalPadding: Constants.smallPadding,
                title: Helpers.translatingWord("ekramOrderDate"),
                subtitle: getFormattedDateEkramCard(state.details.requestDate),
              ),
              CustomTitleSubtitleCardWidget(
                horizontalPadding: Constants.smallPadding,
                title: Helpers.translatingWord("transportationStatus"),
                subtitle: state.details.deathTransferStatusDesc,
              ),
              CustomTitleSubtitleCardWidget(
                horizontalPadding: Constants.smallPadding,
                title: Helpers.translatingWord("burialCity"),
                subtitle: state.details.deathCityName,
              ),
              CustomTitleSubtitleCardWidget(
                horizontalPadding: Constants.smallPadding,
                title: Helpers.translatingWord("ekramHospital"),
                subtitle: (state.details.hospitalName?.isNotEmpty ?? false)
                    ? state.details.hospitalName
                    : state.details.hospitalOtherName,
              ),
              if (state.details.locationAddress?.isNotEmpty ?? false)
                CustomTitleSubtitleCardWidget(
                  horizontalPadding: Constants.smallPadding,
                  title: Helpers.translatingWord("deathLocation"),
                  subtitle: state.details.locationAddress,
                ),
              if (state.details.requestStatusId == 6 &&
                  state.details.cancelReason != null)
                CustomTitleSubtitleCardWidget(
                  horizontalPadding: Constants.smallPadding,
                  title: Helpers.translatingWord("order_cancel_purpose"),
                  subtitle: state.details.cancelReason,
                ),*/

              /*  CustomTitleSubtitleCardWidget(
                horizontalPadding: Constants.smallPadding,
                title: Helpers.translatingWord("transportationDestination"),
                subtitle: 'المنزل',
              ),*/
              /* CustomTitleSubtitleCardWidget(
                horizontalPadding: Constants.smallPadding,
                title: Helpers.translatingWord("nextTransferDestination"),
                subtitle: 'المستشفي',
              ),
              CustomTitleSubtitleCardWidget(
                horizontalPadding: Constants.smallPadding,
                title: Helpers.translatingWord("transferDestination"),
                subtitle: 'جمعية إكرام',
              ),
              CustomTitleSubtitleCardWidget(
                horizontalPadding: Constants.smallPadding,
                title: Helpers.translatingWord("ekramSideType"),
                subtitle: 'جمعية خيرية',
              ),*/
            ],
          ),
        );
      },
    );
  }
}

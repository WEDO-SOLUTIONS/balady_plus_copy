import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:balady_plus/app/features/ekram/presentation/blocs/request_details_bloc/request_details_bloc_bloc.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../../../core/utils/enums/bloc_status.dart';
import '../../../../../_shared_feature_/presentation/cards/expandable_card.dart';
import '../../../../../_shared_feature_/presentation/widgets/custom_enhanced_expansion_panel_widget.dart';
import '../../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../../_shared_feature_/shared_feature_exports.dart';

class DeceasedInfoWidget_new extends StatelessWidget {
  const DeceasedInfoWidget_new({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestDetailsBloc, RequestDetailsState>(
      builder: (context, state) {
        return

          Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomVerticalSpace(height: 10),
            CustomTextWidget(
              "deceasedData".tr(),
              fontSize: 20.0,
              fontWeight: AppFontWeight.bold,
              fontColor: AppColor.blackModern700Light,
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
            ),
            ListView.builder(
              padding: EdgeInsets.zero,
              itemCount:
                  state.details.deceasedInfoResponseDtoList?.length ??
                      0,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (ctx, index) {
                return

                  ExpandableCard(
                      title: "${("cemetry_deceassed_info").tr()} ${index+1}",
                      icon: null,
                    children:
                    [
                      IdenticalDeceasedCardWidget(
                    item: state.details.deceasedInfoResponseDtoList![index],
                    isDriver: state.isDriver,
                    showLogTrip: state.details.requestStatusId != 5 &&
                        state.details.requestStatusId != 6,),
                  ]);
              },
            ),


              ElevatedButtonWidget.primaryCustom(
                onPressed: () {
                  context
                      .read<RequestDetailsBloc>()
                      .add(GetTripsEvent(index: 0));

                },
                text: ('startTrip').tr(),
              ),




            if (state.status == BlocStatus.loading) const CustomLoadingWidget()
          ],
        );
      },
    );
  }
}

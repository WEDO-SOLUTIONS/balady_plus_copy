import 'package:balady_plus/app/features/report_damaged_car/presentation/widgets/create_dc_request/details_widgets/incident_photo_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../../_shared_feature_/presentation/components/texts/label_icon_subtitle_component.dart';
import '../../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../../vd/presentation/widgets/details_widgets/location_warning_widget.dart';
import '../../../../../../core/utils/common_functions.dart';

import '../../../../../vd/presentation/widgets/vd_header_desc_widget.dart';
import '../../../../damaged_cars_exports.dart';
import '../../../blocs/create_dc_request/create_dc_details_bloc/create_dc_bloc.dart';

class LocationPhotoSection extends StatelessWidget {
  const LocationPhotoSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateDCBloc, CreateDCState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(top: 24, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VdHeaderDesc(
                        header: ("vd_confirm_location_photo").tr(),
                      ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColor.white,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: IncidentPhotoWidget(
                            image: state.getImagePath() ?? "",
                            width: 300,
                          ),
                        ),
                      ),
                      const CustomVerticalSpace(height: 20),
                      LocationSection(),
                      const CustomVerticalSpace(height: 8),
                      LocationWarningWidget()
                    ],
                  ),
                ),
              ),
            ),
            PreviousNextButtons()
          ],
        );
      },
    );
  }
}

class LocationSection extends StatelessWidget {
  bool? hideAutomaticLocationdetected;
  bool showOnly;
  LocationSection({this.hideAutomaticLocationdetected, this.showOnly = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateDCBloc, CreateDCState>(
      builder: (context, state) {
        return LabelIconSubtitleComponent(
          text: ("vd_location").tr(),
          subWidget: GestureDetector(
            onTap: () {
              if (!showOnly)
                context.read<CreateDCBloc>().add(ChangeAddressEvent());
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        CustomSvgIconWidget(IconPath.qrLocationIcon),
                        CustomHorizontalSpace(width: 8),
                        Flexible(
                          child: CustomTextWidget(
                            state.gisResponse?.getFullAddress() ??
                                ("lbl_locate_report_from_here").tr(),
                            fontColor: AppColor.blackModern500Light,
                            fontSize: 14,
                            textAlign: TextAlign.start,
                            height: 1.3,
                            maxLines: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!showOnly)
                    RotatedBox(
                        quarterTurns: CommonFunctions.isAppAR ? 0 : 2,
                        child: CustomSvgIconWidget(IconPath.arrowLeft)),
                ]),
          ),
        );
      },
    );
  }
}

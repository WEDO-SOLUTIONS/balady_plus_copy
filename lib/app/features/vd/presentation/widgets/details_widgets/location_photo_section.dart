import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/vd/vd_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/enums/enums.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';

class LocationPhotoSection extends StatelessWidget {
  const LocationPhotoSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateVDBloc, CreateVDState>(
      builder: (context, state) {
        // print("LocationPhotoSection build");
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
                        child: IncidentPhotoWidget(
                          image: state.getImagePath() ?? "",
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

  LocationSection({this.hideAutomaticLocationdetected});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateVDBloc, CreateVDState>(
      builder: (context, state) {
        return CustomHeaderAndDescOnTapWidget(
          label: ("vd_location").tr(),
          hintText: ("lbl_locate_report_from_here").tr(),
          textValue: state.gisResponse?.getFullAddress(),
          borderRadius: 16,
          borderType: BORDER_TYPE.none,
          materialIconDirection: CommonFunctions.isAppAR
              ? MATERIAL_ICON_DIRECTION.left
              : MATERIAL_ICON_DIRECTION.right,
          onTap: () {
            context.read<CreateVDBloc>().add(ChangeAddressEvent());
          },
          icon: const Icon(Icons.location_on, color: AppColor.primary700Light),
        );
      },
    );
  }
}

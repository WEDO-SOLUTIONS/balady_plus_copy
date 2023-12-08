import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/retrive_car/presentation/widgets/create_retrive_car/previous_next_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../vd/presentation/widgets/summery_widgets/field_data.dart';
import '../../../../vd/presentation/widgets/vd_header_desc_widget.dart';
import '../../blocs/create_retrive_bloc/create_retrive_bloc.dart';

class RetreiveCarInformationSection extends StatelessWidget {
  const RetreiveCarInformationSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateRetriveCarBloc, CreateRetriveCarState>(
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
                        header: ("dc_vc_details").tr(),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      FieldData(
                        title: ("dc_vc_type").tr(),
                        subTitle:
                            state.vehicleItem?.vehicleDetails?.vehicleType,
                      ),
                      CustomVerticalSpace(height: 8),
                      FieldData(
                        title: ("dc_vc_model").tr(),
                        subTitle:
                            state.vehicleItem?.vehicleDetails?.vehicleModel,
                      ),
                      CustomVerticalSpace(height: 8),
                      FieldData(
                        title: ("dc_vc_plateNumber").tr(),
                        subTitle: state.vehicleItem?.vehiclePlateNumber,
                      ),
                      CustomVerticalSpace(height: 8),
                      FieldData(
                        title: ("dc_vc_chassie").tr(),
                        subTitle:
                            state.vehicleItem?.vehicleDetails?.chassisNumber,
                      ),
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

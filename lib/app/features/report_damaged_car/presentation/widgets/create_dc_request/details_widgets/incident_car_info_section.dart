import 'package:balady_plus/app/features/report_damaged_car/presentation/widgets/create_dc_request/details_widgets/previous_next_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/enums/bloc_status.dart';
import '../../../../../_shared_feature_/data/entities/drop_down_item.dart';
import '../../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../../vd/presentation/widgets/vd_header_desc_widget.dart';
import '../../../blocs/create_dc_request/create_dc_details_bloc/create_dc_bloc.dart';

class IncidentCarInfoSection extends StatelessWidget {
  const IncidentCarInfoSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateDCBloc, CreateDCState>(
      builder: (context, state) {
        return Stack(
          children: [
            Column(
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
                          CustomTapWidgetForLongDialog(
                            items: state.getReprtTypes(),
                            value: state.reportType,
                            onChangeType: (DropDownItem? item) {
                              context
                                  .read<CreateDCBloc>()
                                  .add(SelectReportTypeEvent(item: item));
                            },
                            label: ("dc_report_type").tr(),
                            hint: ("choose").tr(),
                            searchHint: ("searchFor").tr(),
                          ),
                          CustomTapWidgetForLongDialog(
                            items: state.getCarTypesItems(),
                            value: state.selectedCarType?.getDropDownItem(),
                            onChangeType: (DropDownItem? item) {
                              context
                                  .read<CreateDCBloc>()
                                  .add(GetCarModelsEvent(item: item));
                            },
                            label: ("dc_vc_type").tr(),
                            hint: ("choose").tr(),
                            searchHint: ("searchFor").tr(),
                          ),
                          CustomTapWidgetForLongDialog(
                            items: state.getCarModelsItems(),
                            value: state.selectedCarModel?.getDropDownItem(),
                            onChangeType: (DropDownItem? item) {
                              context
                                  .read<CreateDCBloc>()
                                  .add(SelectCarModelEvent(item: item));
                            },
                            label: ("dc_vc_model").tr(),
                            hint: ("choose").tr(),
                            searchHint: ("searchFor").tr(),
                          ),
                          /*CustomTapWidgetForLongDialog(
                            items: state.getRegstrationTypes(),
                            value: state.registerType,
                            onChangeType: (DropDownItem? item) {
                              context
                                  .read<CreateDCBloc>()
                                  .add(SelectRegisterTypeEvent(item: item));
                            },
                            label: Helpers.translatingWord("register_type"),
                            hint: Helpers.translatingWord("register_type"),
                            searchHint: Helpers.translatingWord("searchFor"),
                          ),*/
                        ],
                      ),
                    ),
                  ),
                ),
                PreviousNextButtons()
              ],
            ),
            if (state.status == BlocStatus.loading)
              Align(
                  alignment: Alignment.center,
                  child: CustomCircularLoadingWidget())
          ],
        );
      },
    );
  }
}

import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import '../../../../new_appointment/presentation/core/models/lookup_list_model.dart';
import '../../bloc/inquiry_cemetry_bloc/ekram_inquiry_cemetry_bloc.dart';
import '../../bloc/inquiry_cemetry_bloc/ekram_inquiry_cemetry_event.dart';
import '../../bloc/inquiry_cemetry_bloc/ekram_inquiry_cemetry_state.dart';
import '../../widgets/inquiry_cemetry/dead_religion.dart';
import '../../widgets/inquiry_cemetry/laundry_exists_widget.dart';

class InquiryCemetryDetailsPage extends StatefulWidget {
  const InquiryCemetryDetailsPage({super.key});

  @override
  State<InquiryCemetryDetailsPage> createState() =>
      _InquiryCemetryDetailsPageState();
}

class _InquiryCemetryDetailsPageState extends State<InquiryCemetryDetailsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    CommonFunctions.sendUXCamEvent(UXCamEvents.startServiceCemeteryInquiry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBarWidget(
        title: "ekram_inquiry_burial_grave".tr(),
        x: true,
      ),
      body: BlocProvider(
        create: (context) =>
            EkramInquiryCemetryBloc()..add(GetEkramCitiesEvent()),
        child: BlocConsumer<EkramInquiryCemetryBloc, EkramInquiryCemetryState>(
          listener: (context, state) {
            print(state);
            if (state.status == BlocStatus.failure) {
              CommonFunctions.showError(state.errorMsg ?? "");
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(children: [
                      CustomLookUpLongDialog(
                        items: state.cities ?? [],
                        value: state.selectedCity,
                        onEmptyList: () async {
                          return context
                              .read<EkramInquiryCemetryBloc>()
                              .getEkramCitiesEventHandler();
                        },
                        onChangeType: (LookUpItem? item) {
                          print(item?.name);
                          if (item != null) {
                            context
                                .read<EkramInquiryCemetryBloc>()
                                .add(GetEkramDistrictsEvent(city: item));
                          }
                        },
                        label: ("city").tr(),
                        hint: ("city").tr(),
                      ),
                      const CustomVerticalSpace(height: 16),
                      CustomLookUpLongDialog(
                        items: state.distrcts ?? [],
                        value: state.selectedDistrcit,
                        onChangeType: (LookUpItem? item) {
                          print(item?.name);
                          if (item != null) {
                            context
                                .read<EkramInquiryCemetryBloc>()
                                .add(SelectDistrcitEvent(item: item));
                          }
                        },
                        label: ("district").tr(),
                        hint: ("district").tr(),
                      ),
                      const CustomVerticalSpace(height: 16),
                      const DeadReligionWidget(),
                      const CustomVerticalSpace(height: 16),
                      //  const LaundryExistsWidget(),
                      //  const CustomVerticalSpace(height: 32),
                      ElevatedButtonWidget.custom(
                          isDisabled: state.selectedCity == null,
                          onPressed: () {
                            context
                                .read<EkramInquiryCemetryBloc>()
                                .add(FindCemetriesEvent());
                          },
                          text: "searchButton".tr())
                    ]),
                  ),
                ),
                if (state.status == BlocStatus.loading)
                  const CustomCircularLoadingWidget()
              ],
            );
          },
        ),
      ),
    );
  }
}

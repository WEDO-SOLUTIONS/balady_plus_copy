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
import '../../bloc/inquiry_orgnizations_bloc/ekram_inquiry_orgnization_state.dart';
import '../../bloc/inquiry_orgnizations_bloc/ekram_inquiry_orgnization_bloc.dart';
import '../../bloc/inquiry_orgnizations_bloc/ekram_inquiry_orgnization_event.dart';

class InquiryOrgnizaionDetailsPage extends StatefulWidget {
  const InquiryOrgnizaionDetailsPage({super.key});

  @override
  State<InquiryOrgnizaionDetailsPage> createState() =>
      _InquiryOrgnizaionDetailsPageState();
}

class _InquiryOrgnizaionDetailsPageState
    extends State<InquiryOrgnizaionDetailsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.startServiceFuneralServiceInquiry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0), // here the desired height

        child: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          elevation: 0,
          title: Text(
            "ekram_inquiry_orgnizations".tr(),
            maxLines: 3,
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) =>
            EkramInquiryOrgnizationBloc()..add(const GetEkramCitiesEvent()),
        child: BlocConsumer<EkramInquiryOrgnizationBloc,
            EkramOrgnizationCemetryState>(
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
                              .read<EkramInquiryOrgnizationBloc>()
                              .getEkramCitiesEventHandler();
                        },
                        onChangeType: (LookUpItem? item) {
                          print(item?.name);
                          if (item != null) {
                            context
                                .read<EkramInquiryOrgnizationBloc>()
                                .add(SelectCityEvent(item: item));
                          }
                        },
                        label: ("city").tr(),
                        hint: ("city").tr(),
                      ),
                      const CustomVerticalSpace(height: 32),
                      ElevatedButtonWidget.custom(
                          isDisabled: state.selectedCity == null,
                          onPressed: () {
                            context
                                .read<EkramInquiryOrgnizationBloc>()
                                .add(const FindCemetriesEvent());
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

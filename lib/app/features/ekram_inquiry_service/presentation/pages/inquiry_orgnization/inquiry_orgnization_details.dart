import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import '../../../../new_appointment/presentation/core/models/lookup_list_model.dart';
import '../../bloc/inquiry_orgnizations_bloc/ekram_inquiry_Orgnization_state.dart';
import '../../bloc/inquiry_orgnizations_bloc/ekram_inquiry_orgnization_bloc.dart';
import '../../bloc/inquiry_orgnizations_bloc/ekram_inquiry_orgnization_event.dart';

class InquiryOrgnizaionDetailsPage extends StatelessWidget {
  const InquiryOrgnizaionDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBarWidget(
        title: "ekram_inquiry_burial_grave".tr(),
        x: true,
      ),
      body: BlocProvider(
        create: (context) =>
            EkramInquiryOrgnizationBloc()..add(GetEkramCitiesEvent()),
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
                      ElevatedButtonWidget.primaryCustom(
                          onPressed: () {
                            context
                                .read<EkramInquiryOrgnizationBloc>()
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

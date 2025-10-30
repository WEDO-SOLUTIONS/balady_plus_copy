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

import '../../bloc/inquiry_grave_bloc/ekram_inquiry_grave_bloc.dart';
import '../../bloc/inquiry_grave_bloc/ekram_inquiry_grave_event.dart';
import '../../bloc/inquiry_grave_bloc/ekram_inquiry_grave_state.dart';

class InquiryGraveDetailsPage extends StatefulWidget {
  const InquiryGraveDetailsPage({super.key});

  @override
  State<InquiryGraveDetailsPage> createState() =>
      _InquiryGraveDetailsPageState();
}

class _InquiryGraveDetailsPageState extends State<InquiryGraveDetailsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    CommonFunctions.sendUXCamEvent(UXCamEvents.startServiceGraveInquiry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBarWidget(
        title: "ekram_inquiry_about_grave".tr(),
        x: true,
      ),
      body: BlocProvider(
        create: (context) =>
            EkramInquiryGraveBloc()..add(GetEkramCitiesEvent()),
        child: BlocConsumer<EkramInquiryGraveBloc, EkramInquiryGraveState>(
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
                      CustomTextFieldWidget(
                        label: "name".tr(),
                        onChanged: (String? val) {
                          context
                              .read<EkramInquiryGraveBloc>()
                              .add(ChangeFullNameEvent(value: val));
                        },
                      ),
                      const CustomVerticalSpace(height: 16),
                      CustomLookUpLongDialog(
                        items: state.nationalIdTypes ?? [],
                        value: state.selectedNationalIdType,
                        onEmptyList: () async {
                          return context
                              .read<EkramInquiryGraveBloc>()
                              .getEkramNationalIdTypesEventHandler();
                        },
                        onChangeType: (LookUpItem? item) {
                          if (item != null) {
                            context
                                .read<EkramInquiryGraveBloc>()
                                .add(SelectNationalIdTypeEvent(item: item));
                          }
                        },
                        label: ("ekram_identity_type").tr(),
                        hint: ("ekram_identity_type").tr(),
                      ),
                      CustomTextFieldWidget(
                        label: "ekram_identity_no".tr(),
                        onChanged: (String? val) {
                          context
                              .read<EkramInquiryGraveBloc>()
                              .add(ChangeIdentityNoEvent(value: val));
                        },
                      ),
                      const CustomVerticalSpace(height: 16),
                      CustomLookUpLongDialog(
                        items: state.cities ?? [],
                        value: state.selectedCity,
                        onEmptyList: () async {
                          return context
                              .read<EkramInquiryGraveBloc>()
                              .getEkramCitiesEventHandler();
                        },
                        onChangeType: (LookUpItem? item) {
                          print(item?.name);
                          if (item != null) {
                            context
                                .read<EkramInquiryGraveBloc>()
                                .add(SelectCityEvent(item: item));
                          }
                        },
                        label: ("burial_city").tr(),
                        hint: ("burial_city").tr(),
                      ),
                      CustomLookUpLongDialog(
                        items: state.nationalities ?? [],
                        value: state.selectedNationality,
                        onEmptyList: () {
                          return context
                              .read<EkramInquiryGraveBloc>()
                              .getEkramNationalIdTypesEventHandler();
                        },
                        onChangeType: (LookUpItem? item) {
                          print(item?.name);
                          if (item != null) {
                            context
                                .read<EkramInquiryGraveBloc>()
                                .add(SelectNationalityEvent(item: item));
                          }
                        },
                        label: ("nationality").tr(),
                        hint: ("nationality").tr(),
                      ),
                      const CustomVerticalSpace(height: 32),
                      ElevatedButtonWidget.custom(
                          isDisabled: !state.isFormValid(),
                          onPressed: () {
                            context
                                .read<EkramInquiryGraveBloc>()
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

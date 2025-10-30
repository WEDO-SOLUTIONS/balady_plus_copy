import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_event.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/pages/map/widgets/map_widgets/cr_header_desc_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import '../../../../new_appointment/presentation/core/models/lookup_list_model.dart';
import '../../bloc/inquiry_print_bloc/ekram_inquiry_print_bloc.dart';
import '../../bloc/inquiry_print_bloc/ekram_inquiry_print_event.dart';
import '../../bloc/inquiry_print_bloc/ekram_inquiry_print_state.dart';

class InquiryPrintDetailsPage extends StatefulWidget {
  const InquiryPrintDetailsPage({super.key});

  @override
  State<InquiryPrintDetailsPage> createState() =>
      _InquiryPrintDetailsPageState();
}

class _InquiryPrintDetailsPageState extends State<InquiryPrintDetailsPage> {
  @override
  void initState() {
    super.initState();

    CommonFunctions.sendUXCamEvent(UXCamEvents.startPrintBurialCertificate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBarWidget(
        title: "ekram_print_certificate".tr(),
        x: true,
      ),
      body: BlocProvider(
        create: (context) => EkramInquiryPrintBloc(),
        child: BlocConsumer<EkramInquiryPrintBloc, EkramInquiryPrintState>(
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
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          VdHeaderDesc(header: "ekram_decesssed_info".tr()),
                          CustomLookUpLongDialog(
                            items: state.nationalIdTypes ?? [],
                            value: state.selectedNationalIdTypeForDecassed,
                            onEmptyList: () async {
                              return context
                                  .read<EkramInquiryPrintBloc>()
                                  .getEkramNationalIdTypesEventHandler();
                            },
                            onChangeType: (LookUpItem? item) {
                              if (item != null) {
                                context.read<EkramInquiryPrintBloc>().add(
                                    UpdatePrintFieldsEvent(
                                        selectedNationalIdTypeForDecassed:
                                            item));
                              }
                            },
                            label: ("ekram_decesssed_identity_type").tr(),
                            hint: ("ekram_decesssed_identity_type").tr(),
                          ),
                          CustomTextFieldWidget(
                            label: "ekram_decesssed_identity".tr(),
                            isDigitsOnly: true,
                            keyboardType: TextInputType.number,
                            onChanged: (String? val) {
                              context.read<EkramInquiryPrintBloc>().add(
                                  UpdatePrintFieldsEvent(
                                      nationalIdForDecassed: val));
                            },
                          ),
                          const CustomVerticalSpace(height: 32),
                          VdHeaderDesc(header: "ekram_reciever_info".tr()),
                          CustomLookUpLongDialog(
                            items: state.nationalIdTypes ?? [],
                            value: state.selectedNationalIdTypeForReceiver,
                            onEmptyList: () async {
                              return context
                                  .read<EkramInquiryPrintBloc>()
                                  .getEkramNationalIdTypesEventHandler();
                            },
                            onChangeType: (LookUpItem? item) {
                              if (item != null) {
                                context.read<EkramInquiryPrintBloc>().add(
                                    UpdatePrintFieldsEvent(
                                        selectedNationalIdTypeForReceiver:
                                            item));
                              }
                            },
                            label: ("ekram_reciever_identity_type").tr(),
                            hint: ("ekram_reciever_identity_type").tr(),
                          ),
                          CustomTextFieldWidget(
                            label: "ekram_reciever_identity".tr(),
                            isDigitsOnly: true,
                            keyboardType: TextInputType.number,
                            onChanged: (String? val) {
                              context.read<EkramInquiryPrintBloc>().add(
                                  UpdatePrintFieldsEvent(
                                      nationalIdForReceiver: val));
                            },
                          ),
                          const CustomVerticalSpace(height: 32),
                          ElevatedButtonWidget.custom(
                              isDisabled: !state.isFormValid(),
                              onPressed: () {
                                /*   context
                                    .read<EkramInquiryPrintBloc>()
                                    .add(const PrintSendOTPEvent());*/
                                context
                                    .read<EkramInquiryPrintBloc>()
                                    .add(const PrintSendOTPEvent());
                              },
                              text: "ekram_print_certificate".tr())
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

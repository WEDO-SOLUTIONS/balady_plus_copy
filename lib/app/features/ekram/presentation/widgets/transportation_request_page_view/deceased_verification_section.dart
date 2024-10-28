import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:balady_plus/app/features/ekram/presentation/widgets/ekram_book_cemetry/gorgian_date_widget.dart';
import 'package:balady_plus/app/features/ekram/presentation/widgets/ekram_book_cemetry/hijri_date_widget.dart';
import 'package:balady_plus/app/features/ekram_inquiry_service/presentation/bloc/inquiry_print_bloc/ekram_inquiry_print_bloc.dart';
import 'package:balady_plus/app/features/ekram_inquiry_service/presentation/bloc/inquiry_print_bloc/ekram_inquiry_print_event.dart';
import 'package:balady_plus/app/features/ekram_inquiry_service/presentation/bloc/inquiry_print_bloc/ekram_inquiry_print_state.dart';
import 'package:balady_plus/app/features/new_appointment/presentation/core/models/lookup_list_model.dart';
import 'package:balady_plus/etmam_app/core/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../core/services/local/helpers.dart';
import '../../../../vd/presentation/widgets/vd_header_desc_widget.dart';

class DeceasedVerificationSection extends StatelessWidget {
  const DeceasedVerificationSection({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();

    return BlocProvider(
      create: (context) => EkramInquiryPrintBloc(),
      child: BlocBuilder<EkramRequestTransportationBloc,
          EkramRequestTransportationState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        VdHeaderDesc(
                          header: Helpers.translatingWord("deceasedInfo"),
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.0)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(IconPath.editIcon),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'deceased_verification'.tr(),
                                    style: const TextStyle(
                                      color: AppColor.black,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                              BlocConsumer<EkramInquiryPrintBloc,
                                  EkramInquiryPrintState>(
                                listener: (context, state) {
                                  print(state);
                                  if (state.status == BlocStatus.failure) {
                                    CommonFunctions.showError(
                                        state.errorMsg ?? "");
                                  }
                                },
                                builder: (context, state) {
                                  return CustomLookUpLongDialog(
                                    items: state.nationalIdTypes ?? [],
                                    value:
                                        state.selectedNationalIdTypeForDecassed,
                                    onEmptyList: () async {
                                      return context
                                          .read<EkramInquiryPrintBloc>()
                                          .getEkramNationalIdTypesEventHandler();
                                    },
                                    onChangeType: (LookUpItem? item) {
                                      if (item != null) {
                                        context
                                            .read<EkramInquiryPrintBloc>()
                                            .add(UpdatePrintFieldsEvent(
                                                selectedNationalIdTypeForDecassed:
                                                    item));
                                      }
                                    },
                                    label:
                                        ("ekram_decesssed_identity_type").tr(),
                                    hint:
                                        ("ekram_decesssed_identity_type").tr(),
                                  );
                                },
                              ),
                              CustomTextFieldWidget(
                                label: "ekram_decesssed_identity".tr(),
                                isDigitsOnly: true,
                                keyboardType: TextInputType.number,
                                onChanged: (String? val) {
                                  // context.read<EkramInquiryPrintBloc>().add(
                                  //     UpdatePrintFieldsEvent(
                                  //         nationalIdForDecassed: val));
                                },
                              ),
                              HijriCalendarDateWidget(
                                fieldName: Helpers.translatingWord(
                                    "cemetry_dob_hijri"),
                                isMandatory: true,
                                onChanged: (String? date) {},
                              ),
                              GorgianCalendarDateWidget(
                                maxValue: today,
                                fieldName: Helpers.translatingWord(
                                    "cemetry_dob_gorgian"),
                                isMandatory: true,
                                onChanged: (String? date) {},
                              ),
                              ElevatedButtonWidget.primaryCustomBorder(
                                onPressed: () async {},
                                text: "verify".tr(),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const EkramPreviousNextButtons()
            ],
          );
        },
      ),
    );
  }
}

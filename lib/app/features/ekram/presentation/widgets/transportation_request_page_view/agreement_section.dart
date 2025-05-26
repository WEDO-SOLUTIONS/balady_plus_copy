import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/ekram/data/model/ekram_transport_validate_submit_params.dart';
import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class AgreementSection extends StatelessWidget {
  const AgreementSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkramRequestTransportationBloc,
        EkramRequestTransportationState>(
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: Card(
                elevation: 0.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(IconPath.vdSummuryPledge),
                            SizedBox(
                              width: 10,
                            ),
                            Text("vd_pledges".tr())
                          ],
                        ),
                        CustomVerticalSpace(height: 8),
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(0x80E6EFEF)),
                          child: Row(
                            children: [
                              Checkbox(
                                value: state.agreementChecked ?? false,
                                activeColor: AppColor.primary900Light,
                                onChanged: (newVal) {
                                  context
                                      .read<EkramRequestTransportationBloc>()
                                      .add(ChangeAgreementEvent(
                                          isagree: newVal));
                                },
                              ),
                              Flexible(
                                child: CustomTextWidget(
                                  ("pledges_condtions").tr(),
                                  fontColor: AppColor.gray,
                                  fontSize: 12,
                                  maxLines: 10,
                                  fontWeight: AppFontWeight.semiBold,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        SafeArea(
                          child: ElevatedButtonWidget.custom(
                            onPressed: () async {
                              context
                                  .read<EkramRequestTransportationBloc>()
                                  .add(ekramTransportValidateSubmitEvent(
                                      params:
                                          EkramTransportValidateSubmitParams(
                                              subMunicipalityId: '',
                                              subMunicipalityName: '',
                                              municipalityId: '',
                                              municipalityName: '',
                                              districtId: '',
                                              districtName: '',
                                              streetId: '',
                                              streetName: '',
                                              centerPoint: '',
                                              krookyUrl: '',
                                              locationAddress: '',
                                              amanaCode: ''),
                                      requestId: state.requestId!));
                            },
                            isDisabled:
                                state.agreementChecked == false ? true : false,
                            text: "ekram_transportation_apply".tr(),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

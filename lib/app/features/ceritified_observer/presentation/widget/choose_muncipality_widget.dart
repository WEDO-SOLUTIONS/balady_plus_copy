import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/compliance_submission/sixth_submit_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../etmam_app/core/utils/constants/app_config.dart';
import '../../../../../etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_style.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../_shared_feature_/presentation/cards/expandable_card.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../_shared_feature_/presentation/widgets/notes_widget.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../new_appointment/presentation/core/models/lookup_list_model.dart';
import '../../domain/entity/MunicipalityLookUp.dart';
import '../../domain/entity/register_observer_request.dart';
import '../blocs/choose_muncipality_bloc.dart';

class ChooseMuncipalityWidget extends StatefulWidget {
  const ChooseMuncipalityWidget({Key? key}) : super(key: key);

  @override
  State<ChooseMuncipalityWidget> createState() => _ChooseMuncipalityWidgetState();
}

class _ChooseMuncipalityWidgetState extends State<ChooseMuncipalityWidget> {
  @override
  Widget build(BuildContext context) {

    return BlocConsumer<ChooseMuncipalityBloc, ChooseMuncipalityState>(
        listener: (context, state) {},

        builder: (context, state) {

          return  Column(

            children: [

              ExpandableCard(title: 'location'.tr(), children: [

                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomTextWidget(
                        "choose_muncipality".tr(),
                        fontSize: 12,
                        fontWeight: AppFontWeight.medium,
                        fontColor: AppColor.black500,
                        height: 1.4,
                        maxLines: 4,
                      ),
                    ],
                  ),

                  CustomLookUpLongDialog(
                    showOptional:false,
                    items: state.lstMunicipalityLookUp ?? [],
                    value: state.getMuncipalityById(state.requestData?.municipalityID),
                    onEmptyList: () async {
                      return context
                          .read<ChooseMuncipalityBloc>()
                          .getMuncipalityList();
                    },
                    onChangeType: (LookUpItem? item) {
                      if (item != null) {

                        context.read<ChooseMuncipalityBloc>().add(setRequestDataEvent(dataModel: RegisterObserverRequest(municipalityID: item.strId!)));

                      }
                    },
                    label: "license_health_municipality".tr(),
                    hint: "license_health_municipality".tr(),
                  ),


                state.isAcceptNewObservers==false? NotesWidget(notes: ['muncipality_not_accept'.tr()],):Container(),
                ],),

              Spacer(),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(36),
                    topRight: Radius.circular(36),
                  ),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 26),
                child: CustomElevatedButtonWidget(

                  btnColor: AppColor.primary800Light,
                  textStyle: AppStyle.elevatedButtonStyle.copyWith(
                    color: AppColor.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                  btnHeight: 56,
                  text: "next".tr(),
                  onPressed: () {

                    if(state.requestData?.municipalityID != null)
                      {
                        context.read<ChooseMuncipalityBloc>().checkMuncipalityAcceptance();

                      }

                  },
                ),
              ),
            ],
          );
        }



    );
  }
}

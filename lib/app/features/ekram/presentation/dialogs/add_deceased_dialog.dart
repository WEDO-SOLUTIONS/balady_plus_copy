import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:balady_plus/app/features/ekram/presentation/blocs/ekram_add_deceased/ekram_add_deceased_bloc.dart';
import 'package:balady_plus/app/features/ekram/presentation/widgets/add_deceased/deceased_require_transfer_widget.dart';
import 'package:balady_plus/app/features/ekram/presentation/widgets/add_deceased/select_burial_destination_widget.dart';
import 'package:balady_plus/app/features/ekram/presentation/widgets/add_deceased/select_gender_widget.dart';
import 'package:balady_plus/app/features/ekram/presentation/widgets/add_deceased/select_religion_widget.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/utils/enums/bloc_status.dart';
import '../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../new_appointment/presentation/core/models/lookup_list_model.dart';

class AddDeceasedDialog extends StatelessWidget {
  final AddDeceasedDialogParams params;
  const AddDeceasedDialog({Key? key, required this.params}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EkramAddDeceasedBloc(
          getCities: sl(),
          getLookUp: sl(),
          getNationalities: sl(),
          params: params),
      child: BlocConsumer<EkramAddDeceasedBloc, EkramAddDeceasedState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: CustomTextWidget(
                            trans('addDeceased'),
                            maxLines: 1,
                            fontSize: 24,
                            fontColor: AppColor.black,
                            textAlign: TextAlign.start,
                          )),
                          CustomTextButtonWidget(
                            onPressed: () => Navigator.of(context).pop(),
                            text: "closeButton".tr(),
                            btnTextColor: AppColor.grey1000,
                            btnTextSize: 17.0,
                            btnTextWeight: AppFontWeight.medium,
                            btnAlignment: AlignmentDirectional.centerEnd,
                          ),
                        ],
                      ),
                      Expanded(child: DialogBody()),
                      ElevatedButtonWidget.custom(
                        isDisabled: !state.isFormValid(),
                        text: ("confirm").tr(),
                        onPressed: () {
                          Navigator.of(context).pop(state.data);
                        },
                      ),
                    ],
                  ),
                ),
                if (state.status == BlocStatus.loading)
                  const CustomCircularLoadingWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DialogBody extends StatefulWidget {
  DialogBody({Key? key}) : super(key: key);

  @override
  State<DialogBody> createState() => _DialogBodyState();
}

class _DialogBodyState extends State<DialogBody> {
  final fullNameTextEditController = TextEditingController();
  final reasonForSpecialTransferTextEditController = TextEditingController();

  final fullNameFocusNode = FocusNode();
  final reasonForSpecialTransferFocusNode = FocusNode();

  @override
  void dispose() {
    fullNameTextEditController.clear();
    fullNameTextEditController.dispose();
    reasonForSpecialTransferTextEditController.clear();
    reasonForSpecialTransferTextEditController.dispose();

    fullNameFocusNode.dispose();
    reasonForSpecialTransferFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkramAddDeceasedBloc, EkramAddDeceasedState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomVerticalSpace(height: 20),
              CustomTextFieldWidget(
                  label: trans("deceasedName3"),
                  hintText: trans("deceasedName3"),
                  controller: fullNameTextEditController,
                  focusNode: fullNameFocusNode,
                  maxLines: 1,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  //contentHorizontalPadding: 0,
                  onChanged: (String? text) {
                    context
                        .read<EkramAddDeceasedBloc>()
                        .add(ChangeFullNameEvent(text: text));
                  },
                  onValidate: (String? value) {
                    if ((value?.split(" ").length ?? 0) < 3) {
                      return trans("deceasedName3_validation_msg");
                    }
                    return null;
                  }),
              CustomVerticalSpace(height: 10),
              CustomLookUpLongDialog(
                items: state.nationalities ?? [],
                value: state.data.nationalityId,
                onChangeType: (LookUpItem? item) {
                  context
                      .read<EkramAddDeceasedBloc>()
                      .add(ChangeNationalityEvent(item: item));
                },
                onEmptyList: () async {
                  return context
                      .read<EkramAddDeceasedBloc>()
                      .getNationalitiesHandler();
                },
                label: ("ekramNationality").tr(),
                hint: ("ekramNationality").tr(),
              ),
              // CustomVerticalSpace(height: 16),
              SelectGenderWidget(),
              CustomVerticalSpace(height: 16),
              SelectReligionWidget(),
              CustomVerticalSpace(height: 16),
              SelectBurialDestinationWidget(),
              if (state.data.multipleCityRequest == true) ...[
                CustomVerticalSpace(height: 16),
                CustomLookUpLongDialog(
                  items: state.cities ?? [],
                  value: state.data.burialCityId,
                  onChangeType: (LookUpItem? item) {
                    context
                        .read<EkramAddDeceasedBloc>()
                        .add(ChangeBurialDestinationCityEvent(item: item));
                  },
                  onEmptyList: () async {
                    return context
                        .read<EkramAddDeceasedBloc>()
                        .getCitiesHandler();
                  },
                  label: ("burial_city").tr(),
                  hint: ("burial_city").tr(),
                )
              ],
              CustomVerticalSpace(height: 16),
              DeceasedRequiredTransferWidget(),
              if (state.data.specialTransferNeeded == true) ...[
                CustomVerticalSpace(height: 16),
                CustomLookUpLongDialog(
                  items: state.specialNeeds ?? [],
                  value: state.data.specialTransferReasonId,
                  onChangeType: (LookUpItem? item) {
                    context
                        .read<EkramAddDeceasedBloc>()
                        .add(ChangeNeedSpecialTransferEvent(item: item));
                  },
                  onEmptyList: () async {
                    return context
                        .read<EkramAddDeceasedBloc>()
                        .getSpecialReasonsLookUp();
                  },
                  label: ("reasonForSpecialTransfer").tr(),
                  hint: ("reasonForSpecialTransfer").tr(),
                )
              ],
              if (state.data.specialTransferReasonId?.id == 30208) ...[
                CustomVerticalSpace(height: 16),
                CustomTextFieldWidget(
                    label: trans("reasonForSpecialTransferText"),
                    hintText: trans("reasonForSpecialTransferText"),
                    controller: reasonForSpecialTransferTextEditController,
                    focusNode: reasonForSpecialTransferFocusNode,
                    maxLines: 1,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    onChanged: (String? text) {
                      context.read<EkramAddDeceasedBloc>().add(
                          ChangeNeedSpecialTransferReasonEvent(text: text));
                    },
                    onValidate: (String? value) {})
              ],
              CustomVerticalSpace(height: 10),
              CustomVerticalSpace(height: 20),
            ],
          ),
        );
      },
    );
  }
}

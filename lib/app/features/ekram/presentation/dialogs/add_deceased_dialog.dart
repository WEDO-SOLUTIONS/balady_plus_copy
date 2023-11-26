import 'package:balady_new_app/app/core/core_exports.dart';
import 'package:balady_new_app/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_new_app/app/features/customer_voice/customer_voice_exports.dart';
import 'package:balady_new_app/app/features/customer_voice/presentation/dialogs/lookup_with_search_dialog.dart';
import 'package:balady_new_app/app/features/ekram/ekram_exports.dart';
import 'package:balady_new_app/app/features/ekram/presentation/blocs/ekram_add_deceased/ekram_add_deceased_bloc.dart';
import 'package:balady_new_app/app/features/ekram/presentation/widgets/add_deceased/deceased_require_transfer_widget.dart';
import 'package:balady_new_app/app/features/ekram/presentation/widgets/add_deceased/select_burial_destination_widget.dart';
import 'package:balady_new_app/app/features/ekram/presentation/widgets/add_deceased/select_gender_widget.dart';
import 'package:balady_new_app/app/features/ekram/presentation/widgets/add_deceased/select_religion_widget.dart';
import 'package:balady_new_app/etmam_app/core/utils/constants/app_config.dart';
import 'package:balady_new_app/shared/core/data/entities/lookup_item.dart';
import 'package:balady_new_app/shared/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../customer_voice/presentation/core/models/classification.dart';

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
            showError(state.errorMessage ?? "");
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
                            fontColor: AppColors.black,
                            textAlign: TextAlign.start,
                          )),
                          CustomTextButtonWidget(
                            btnPressed: () => Navigator.of(context).pop(),
                            btnText: Helpers.translatingWord(
                              "closeButton",
                            ),
                            btnTextColor: AppColors.grey1000,
                            btnTextSize: 17.0,
                            btnTextWeight: FONT_WEIGHT.medium,
                            alignment: AlignmentDirectional.centerEnd,
                          ),
                        ],
                      ),
                      Expanded(child: DialogBody()),
                      IncidentSubmitButton(
                        isButtonDisabled: !state.isFormValid(),
                        btnText: Helpers.translatingWord("confirm"),
                        onPress: () {
                          Navigator.of(context).pop(state.data);
                        },
                      ),
                    ],
                  ),
                ),
                if (state.status == BlocStatus.loading)
                  CustomCircularLoadingWidget(),
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
                  contentHorizontalPadding: 0,
                  onChanged: (String? text) {
                    context
                        .read<EkramAddDeceasedBloc>()
                        .add(ChangeFullNameEvent(text: text));
                  },
                  validator: (String? value) {
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
                label: Helpers.translatingWord("ekramNationality"),
                hint: Helpers.translatingWord("ekramNationality"),
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
                  label: Helpers.translatingWord("burial_city"),
                  hint: Helpers.translatingWord("burial_city"),
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
                  label: Helpers.translatingWord("reasonForSpecialTransfer"),
                  hint: Helpers.translatingWord("reasonForSpecialTransfer"),
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
                    contentHorizontalPadding: 0,
                    onChanged: (String? text) {
                      context.read<EkramAddDeceasedBloc>().add(
                          ChangeNeedSpecialTransferReasonEvent(text: text));
                    },
                    validator: (String? value) {})
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

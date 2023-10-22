import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/vd/vd_exports.dart'
    show
        PreviousNextButtons,
        VdHeaderDesc,
        CreateVDBloc,
        CreateVDState,
        ChangeGuestFirstNameEvent,
        ChangeGuestLastNameEvent,
        ChangeGuestMobileEvent;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';

class GuestInfoSection extends StatelessWidget {
  const GuestInfoSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateVDBloc, CreateVDState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(top: 24, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VdHeaderDesc(
                        header: ("vd_enter_personal_info").tr(),
                      ),
                      VDGuestSectionWidget(
                        //  initialName: "",
                        initialFirstName: state.firstName,
                        initialLastName: state.lastName,
                        initialMobile: state.mobileNumber,

                        onFirstNameChanged: (String value) {
                          context
                              .read<CreateVDBloc>()
                              .add(ChangeGuestFirstNameEvent(text: value));
                        },
                        onLastNameChanged: (String value) {
                          context
                              .read<CreateVDBloc>()
                              .add(ChangeGuestLastNameEvent(text: value));
                        },
                        onMobileChanged: (String value) {
                          context
                              .read<CreateVDBloc>()
                              .add(ChangeGuestMobileEvent(text: value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            PreviousNextButtons()
          ],
        );
      },
    );
  }
}

class VDGuestSectionWidget extends StatefulWidget {
  // final Function? onNameChanged;
  final Function? onFirstNameChanged;
  final Function? onLastNameChanged;
  final Function? onMobileChanged;
  //final String? initialName;
  final String? initialFirstName;
  final String? initialLastName;

  final String? initialMobile;

  const VDGuestSectionWidget(
      {Key? key,
      //this.onNameChanged,
      this.onFirstNameChanged,
      this.onLastNameChanged,
      this.onMobileChanged,
      //this.initialName,
      this.initialFirstName,
      this.initialLastName,
      this.initialMobile})
      : super(key: key);

  @override
  _GuestSectionWidgetState createState() => _GuestSectionWidgetState();
}

class _GuestSectionWidgetState extends State<VDGuestSectionWidget> {
  //final guestNameTextEditController = TextEditingController();

  final guestFirstNameTextEditController = TextEditingController();
  final guestLastNameTextEditController = TextEditingController();

  final guestMobileTextEditController = TextEditingController();

  //final guestNameFocusNode = FocusNode();
  final guestFirstNameFocusNode = FocusNode();
  final guestLastNameFocusNode = FocusNode();
  final guestMobileFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // guestNameTextEditController.text = widget.initialName ?? "";

    guestFirstNameTextEditController.text = widget.initialFirstName ?? "";
    guestLastNameTextEditController.text = widget.initialLastName ?? "";

    guestMobileTextEditController.text = widget.initialMobile ?? "";
  }

  @override
  void dispose() {
    //guestNameTextEditController.clear();
    //guestNameTextEditController.dispose();
    guestFirstNameTextEditController.clear();
    guestFirstNameTextEditController.dispose();
    guestLastNameTextEditController.clear();
    guestLastNameTextEditController.dispose();

    guestMobileTextEditController.clear();
    guestMobileTextEditController.dispose();

    // guestNameFocusNode.dispose();
    guestFirstNameFocusNode.dispose();
    guestLastNameFocusNode.dispose();
    guestMobileFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateVDBloc, CreateVDState>(
      builder: (context, state) {
        return Column(
          children: [
            /* CustomTextFieldWidget(
                label: Helpers.translatingWord("vd_full_name"),
                hintText: Helpers.translatingWord("vd_full_name_hint"),
                controller: guestNameTextEditController,
                focusNode: guestNameFocusNode,
                maxLines: 1,
                onChanged: (String? value) => widget.onNameChanged!(value?.trim()),
                readOnly: false,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                validator: (String? value) {
                  if ((value == null) || (value.isEmpty)) {
                    return Helpers.translatingWord("text_input_empty_err");
                  }
                  if (!Helpers.HasArabicOrEnglishCharacters(value.trim()) ||
                      value.trim().length < 2) {
                    return Helpers.translatingWord("error_input_only_chars");
                  }
                  return null;
                }),*/

            CustomTextFieldWidget(
                label: ("lbl_first_name_hint1").tr(),
                hintText: ("lbl_first_name_hint2").tr(),
                controller: guestFirstNameTextEditController,
                focusNode: guestFirstNameFocusNode,
                maxLines: 1,
                onChanged: (String? value) =>
                    widget.onFirstNameChanged!(value?.trim()),
                readOnly: false,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                errorText: state.firstNameErrorText,
                onValidate: (String? value) {}
                /*validator: (String? value) {
                  if ((value == null) || (value.isEmpty)) {
                    return Helpers.translatingWord("text_input_empty_err");
                  }
                  if (!Helpers.HasArabicOrEnglishCharacters(value.trim()) ||
                      value.trim().length < 2) {
                    return Helpers.translatingWord("error_input_only_chars");
                  }
                  return null;
                }*/
                ),
            CustomVerticalSpace(height: 16),
            CustomTextFieldWidget(
                label: ("lbl_last_name_hint1").tr(),
                hintText: ("lbl_last_name_hint2").tr(),
                controller: guestLastNameTextEditController,
                focusNode: guestLastNameFocusNode,
                maxLines: 1,
                onChanged: (String? value) =>
                    widget.onLastNameChanged!(value?.trim()),
                readOnly: false,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                errorText: state.lastNameErrorText,
                onValidate: (String? value) {}

                /* validator: (String? value) {
                  if ((value == null) || (value.isEmpty)) {
                    return Helpers.translatingWord("text_input_empty_err");
                  }
                  if (!Helpers.HasArabicOrEnglishCharacters(value.trim()) ||
                      value.trim().length < 2) {
                    return Helpers.translatingWord("error_input_only_chars");
                  }
                  return null;
                }*/
                ),
            CustomVerticalSpace(height: 16),
            CustomTextFieldWidget(
                label: ("lbl_mobile_hint1").tr(),
                hintText: ("lbl_mobile_hint2").tr(),
                controller: guestMobileTextEditController,
                focusNode: guestMobileFocusNode,
                maxLines: 1,
                onChanged: (String? value) => widget.onMobileChanged!(value),
                readOnly: false,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.phone,
                errorText: state.phoneErrorText,
                onValidate: (String? value) {}

                /* validator:(String? value) {
                  RegExp regExp = RegExp(r'^(05)([0-9]{8})$');
                  if ((value == null) || (value.isEmpty)) {
                    return Helpers.translatingWord("text_input_empty_err");
                  } else if (!regExp.hasMatch(value)) {
                    return Helpers.translatingWord("mobile_err");
                  }
                  return null;
                }*/
                ),
          ],
        );
      },
    );
  }
}

import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/draw_line_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/utils/common_functions.dart';
import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../core/utils/constants/constants.dart';
import '../../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../../_shared_feature_/data/entities/drop_down_item.dart';
import '../../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../core/bloc/transaction_inquiry_bloc/transaction_inquiry_bloc.dart';
import '../../../core/view_models/inquiry/transaction_inquiry_view_model.dart';
import 'hijri_picker.dart' as hijri_picker;
import 'previous_next_buttons.dart';

class NewTransactionInquiryScreen extends StatefulWidget {
  const NewTransactionInquiryScreen({Key? key}) : super(key: key);

  @override
  _NewTransactionInquiryScreen createState() => _NewTransactionInquiryScreen();
}

class _NewTransactionInquiryScreen extends State<NewTransactionInquiryScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    CommonFunctions.sendUXCamEvent(UXCamEvents.startServiceRequestFollowUp);

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.RequestFollowUp_Open_Create_Details_Event);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionInquiryBloc, TransactionInquiryState>(
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding:
                      const EdgeInsets.only(bottom: 85, right: 30, left: 30),
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const CustomVerticalSpace(height: 32),
                        TransactionBodySection(),
                      ]),
                ),
              ),
            ),

            PreviousNextButtons()
            //MM
            /*IncidentSubmitButton(
                          btnText: Helpers.translatingWord('submit_inquiry'),
                          isButtonDisabled: !model.isFormValid,
                          onPress: model.geRequestDetails,
                        )*/
          ],
        );
      },
    );
  }
}

class TransactionBodySection extends StatefulWidget {
  TransactionBodySection({Key? key}) : super(key: key);

  @override
  State<TransactionBodySection> createState() => _TransactionBodySectionState();
}

class _TransactionBodySectionState extends State<TransactionBodySection> {
  final FocusNode _inquiryNoFocusNode = FocusNode();
  final TextEditingController _inquiryNoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TransactionInquiryViewModel model =
        Provider.of<TransactionInquiryViewModel>(context, listen: false);
    return Column(
      children: <Widget>[
        //MM
        /*CustomSectionHeaderWithImg(
          title: Helpers.translatingWord(
              'customerVoiceLatestRequestsSectionGoToDetailsButtonWord'),
          img: "contractType@3x.png",
        ),*/
        CustomTapWidgetForLongDialog(
          items: model.municipalities,
          value: model.municipality,
          onChangeType: (DropDownItem? item) {
            model.municipality = item;
            model.validateForm();
            setState(() {});
          },
          label: ("side").tr(),
          hint: ("side_hint").tr(),
          searchHint: ("side_search").tr(),
        ),
        const CustomVerticalSpace(height: 5),
        CustomTextFieldWidget(
          controller: _inquiryNoController,
          focusNode: _inquiryNoFocusNode,
          label: ("inquiry_number").tr(),
          hintText: ("inquiry_number_hint").tr(),
          obsecureText: false,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          fillColor: Colors.transparent,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          onValidate: (text) {
            if (text.toString().isEmpty) {
              return ('text_field_error').tr();
            }
            return null;
          },
          onChanged: (v) {
            model.refrenceNumber = v;
            model.validateForm();
          },
        ),
        const CustomVerticalSpace(height: 5),
        CustomHeaderAndDescOnTapWidget(
          label: ("date").tr(),
          hintText: ("date_hint").tr(),
          textValue: model.year,
          onTap: () async {
            showHijriDate(context);
          },
        ),
        const CustomVerticalSpace(height: 5),

        CustomTapWidgetForLongDialog(
          items: model.types,
          value: model.type,
          isButtonDisabled: false,
          onChangeType: (DropDownItem? item) {
            // model.type = item;
            // model.validateForm();
            //  setState(() {});
          },
          label: ("inquiry_type").tr(),
          hint: ("inquiry_type_hint").tr(),
          searchHint: ("search").tr(),
        ),
      ],
    );
  }

  void showHijriDate(BuildContext context) {
    TransactionInquiryViewModel model =
        Provider.of<TransactionInquiryViewModel>(context, listen: false);
    hijri_picker.Picker(
        isAr: true,
        textScaleFactor: 1,
        confirmTextStyle: const TextStyle(
          fontFamily: Constants.appFontType,
          fontSize: 15,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
          color: AppColor.baladyDarkGreen2,
        ),
        headercolor: const Color(0xfffafaf8),
        cancel: Container(),
        height: 270,
        confirmText: ('done').tr(),
        title: Text(
          ('choose_date').tr(),
          style: const TextStyle(
            color: AppColor.black,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            fontSize: 15.0,
          ),
          textScaleFactor: 1,
          textAlign: TextAlign.right,
        ),
        hideHeader: false,
        adapter: hijri_picker.DateTimePickerAdapter(
            customColumnType: [0], value: null),
        selectedTextStyle: const TextStyle(color: AppColor.baladyDarkGreen2),
        onConfirm: (hijri_picker.Picker picker, List value) {
          var date =
              (picker.adapter as hijri_picker.DateTimePickerAdapter).value;
          setState(() {
            model.year = date!.toFormat("yyyy");
          });
          model.validateForm();
        }).showModal(context);
  }
}

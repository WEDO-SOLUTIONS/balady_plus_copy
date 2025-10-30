import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/report_damaged_car/presentation/widgets/create_dc_request/details_widgets/plate_letter_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../../core/utils/constants/dialog_names.dart';
import '../../../../../_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_with_actions.dart';
import '../../../../../_shared_feature_/presentation/components/bottom_sheets/draggable_sheet_component.dart';
import '../../../../../_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../blocs/create_dc_request/create_dc_details_bloc/create_dc_bloc.dart';

List<String> letters = [
  "أ",
  "ب",
  "ح",
  "د",
  "ر",
  "س",
  "ص",
  "ط",
  "ع",
  "ق",
  "ك",
  "ل",
  "م",
  "ن",
  "هـ",
  "و",
  "ي",
];

class PlateNumberWidget extends StatelessWidget {
  const PlateNumberWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateDCBloc, CreateDCState>(
      builder: (context, state) {
        return Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextWidget(
                ("dc_vc_plate_letters").tr(),
                fontColor: AppColor.blackModern700Light,
                fontSize: 16,
                textAlign: TextAlign.start,
                fontWeight: AppFontWeight.bold,
              ),
              CustomVerticalSpace(height: 15),
              Row(
                mainAxisSize: MainAxisSize.min, //
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        onSelectPlateLetter(context, rightLetter: true);
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          // color: AppColor.algae,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color: AppColor.blackModern300Light, width: 1),
                        ),
                        child: Stack(children: [
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Padding(
                              padding: EdgeInsetsDirectional.only(start: 10),
                              child: CustomTextWidget(
                                state.rightLetter ?? "",
                                textAlign: TextAlign.start,
                                fontColor: Colors.black,
                                fontSize: 16,
                                fontWeight: AppFontWeight.medium,
                              ),
                            ),
                          ),
                          Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: FittedBox(
                                  child: Icon(Icons.arrow_drop_down))),
                        ]),
                      ),
                    ),
                  ),
                  CustomHorizontalSpace(width: 8),
                  Expanded(
                    child: GestureDetector(
                        onTap: () {
                          onSelectPlateLetter(context, middleLetter: true);
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            // color: AppColor.algae,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: AppColor.blackModern300Light, width: 1),
                          ),
                          child: Stack(children: [
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Padding(
                                padding: EdgeInsetsDirectional.only(start: 10),
                                child: CustomTextWidget(
                                  state.middleLetter ?? "",
                                  textAlign: TextAlign.start,
                                  fontColor: Colors.black,
                                  fontSize: 16,
                                  fontWeight: AppFontWeight.medium,
                                ),
                              ),
                            ),
                            Align(
                                alignment: AlignmentDirectional.centerEnd,
                                child: FittedBox(
                                    child: Icon(Icons.arrow_drop_down))),
                          ]),
                        )),
                  ),
                  CustomHorizontalSpace(width: 8),
                  Expanded(
                    child: GestureDetector(
                        onTap: () {
                          onSelectPlateLetter(context, leftLetter: true);
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            // color: AppColor.algae,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: AppColor.blackModern300Light, width: 1),
                          ),
                          child: Stack(children: [
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Padding(
                                padding: EdgeInsetsDirectional.only(start: 10),
                                child: CustomTextWidget(
                                  state.leftLetter ?? "",
                                  textAlign: TextAlign.start,
                                  fontColor: Colors.black,
                                  fontSize: 16,
                                  fontWeight: AppFontWeight.medium,
                                ),
                              ),
                            ),
                            Align(
                                alignment: AlignmentDirectional.centerEnd,
                                child: FittedBox(
                                    child: Icon(Icons.arrow_drop_down))),
                          ]),
                        )),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void onSelectPlateLetter(BuildContext context,
      {bool? rightLetter = false,
      bool? leftLetter = false,
      bool? middleLetter = false}) async {
    await BottomSheetDialog.showDraggableSheet(
      context,
      dialogKeyName: DialogName.dcPlateDialog,
      currentRouteName: RouteName.createDCDetailsPage,
      isFullHeight: false,
      // child: const CloseRequestBottomSheetComponent(),
      child: PlateNumberKeyBoard(
        onSelect: (String l) {
          context.read<CreateDCBloc>().add(ChangeCarDetailsEvent(
              rightLetter: rightLetter == true ? l : null,
              leftLetter: leftLetter == true ? l : null,
              middleLetter: middleLetter == true ? l : null));
        },
      ),
    );
  }
}

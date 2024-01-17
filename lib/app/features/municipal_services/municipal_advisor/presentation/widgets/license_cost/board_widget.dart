import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/constants/dialog_names.dart';
import '../../../municipal_advisor_exports.dart';

class BoardWidget extends StatelessWidget {
  final BoardsParams board;
  final int index;

  const BoardWidget({super.key, required this.board, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(top: 16),
      decoration: ShapeDecoration(
        color: AppColor.mystic,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: BlocBuilder<MunicipalAdvisorBloc, MunicipalAdvisorState>(
        builder: (context, state) {
          final BoardTypeEntity? type =
              state.boardTypes.where((e) => e.id == board.typeId).firstOrNull;
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomTextWidget(
                      "${'board'.tr()} ${index + 1}",
                      textStyle: AppStyle.dropDownTitleTextStyle,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      BlocProvider.of<MunicipalAdvisorBloc>(context).add(
                        MunicipalAdvisorRemoveCommercialBoardEvent(
                          index: index,
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.close,
                      color: AppColor.primary900Light,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: DropDownWithTitle(
                      title: "boardsOptions".tr(),
                      selectedValue: type?.name,
                      height: 55,
                      onTap: () {
                        final List<String> items =
                            state.boardTypes.map((e) => e.name).toList();
                        BottomSheetDialog.showDraggableSheet(
                          context,
                          dialogKeyName: DialogName.municipalAdvisorBoardType,
                          currentRouteName: RouteName.municipalAdvisor,
                          child: BottomSheetList(
                            title: "BoardType".tr(),
                            items: items,
                            selectedValue: type?.name,
                            onTap: (item) {
                              Navigator.pop(context);
                              final typeId = state.boardTypes
                                  .where((e) => e.name == item)
                                  .first
                                  .id;
                              BlocProvider.of<MunicipalAdvisorBloc>(context)
                                  .add(
                                MunicipalAdvisorUpdateCommercialBoardEvent(
                                  index: index,
                                  board: board.copyWith(
                                    typeId: typeId,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextWidget(
                            'area'.tr(),
                            textStyle: AppStyle.dropDownTitleTextStyle,
                          ),
                          const SizedBox(height: 8),
                          CustomTextFieldWidget(
                            borderColor: AppColor.primary900Light16,
                            // controller: _controller,
                            initialValue: board.area != null
                                ? board.area.toString()
                                : null,
                            keyboardType: const TextInputType.numberWithOptions(
                              signed: true,
                              decimal: true,
                            ),
                            textInputAction: TextInputAction.done,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onSubmitted: (value) {
                              BlocProvider.of<MunicipalAdvisorBloc>(context)
                                  .add(
                                MunicipalAdvisorUpdateCommercialBoardEvent(
                                  index: index,
                                  board: board.copyWith(
                                    area: num.tryParse(value) ?? 0,
                                  ),
                                ),
                              );
                            },

                            suffixIcon: CustomTextWidget(
                              'm2'.tr(),
                              textAlign: TextAlign.right,
                              textStyle: AppStyle.textFieldSuffixTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

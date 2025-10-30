import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../../../features/_shared_feature_/shared_feature_exports.dart';
import '../../../commercial_license_exports.dart';
import '../../../domain/entities/commercial_board_type.dart';
import '../bloc/cr_step4_shop_data_cubit.dart';

class BillboardComponent extends StatelessWidget {
  const BillboardComponent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CrStep4ShopDataCubit, CrStep4ShopDataState>(
        builder: (context, state) {
      return Container(
        margin: const EdgeInsets.only(top: 32, bottom: 24),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: AppColor.white,
        ),
        child: Column(
          children: [
            Row(
              children: [
                const CustomSvgIconWidget(
                  IconPath.additionalActivity,
                  iconSize: 20,
                ),
                const SizedBox(width: 6),
                CustomTextWidget(
                  "lbl_boards_title".tr(),
                  fontWeight: AppFontWeight.bold,
                  fontSize: 18,
                  fontColor: AppColor.blackModern600Light,
                ),
              ],
            ),
            const SizedBox(height: 14),
            ListView.separated(
              itemCount: state.selectedBoards?.length ?? 0,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) => BillboardCard(
                type: state.selectedBoards![index],
                onDelete: () {
                  context.read<CrStep4ShopDataCubit>().deleteBoard(index);
                },
              ),
            ),
            const SizedBox(height: 12),
            PlusAddButton(
                text: "add_new_board".tr(),
                onPressed: () {
                  BottomSheetDialog.showDraggableSheet(
                    context,
                    child: CommercialBoardDialog(
                      length: state.selectedBoards?.length ?? 0,
                    ),
                  ).then((value) {
                    print(value);
                    if (value != null) {
                      context.read<CrStep4ShopDataCubit>().addBoard(value);
                    }
                  });
                }),
          ],
        ),
      );
    });
  }
}

class CommercialBoardDialog extends StatefulWidget {
  final CommercialBoardType? board;
  final int length;
  const CommercialBoardDialog({super.key, this.board, required this.length});

  @override
  State<CommercialBoardDialog> createState() => _CommercialBoardDialogState();
}

class _CommercialBoardDialogState extends State<CommercialBoardDialog> {
  List<DropDownItem> items = [
    DropDownItem(name: "Directional".tr(), id: "1"),
    DropDownItem(name: "Advertising".tr(), id: "2"),
  ];
  DropDownItem? selectedItem;
  double? area;

  CommercialBoardType? board;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    board = widget.board;
    if (board != null) {
      selectedItem = DropDownItem(id: board?.typeId, name: board?.name ?? "");
      area = board?.area;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isBtnDisabled = area == null || area == 0 || selectedItem == null;
    return BottomSheetWithActions(
      title: "add_new_adv_board".tr(),
      action: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: EnhancedCustomElevatedButtonWidget(
            btnColor:
                isBtnDisabled ? AppColor.black200 : AppColor.primary900Light,
            btnTextColor: isBtnDisabled ? AppColor.black400 : AppColor.white,
            btnPressed: isBtnDisabled
                ? () {}
                : () {
                    if (area != null) {
                      board = CommercialBoardType(
                          id: board?.id ?? widget.length,
                          typeId: int.tryParse(selectedItem?.id) ?? 0,
                          name: selectedItem?.name ?? "",
                          area: area);

                      Navigator.pop(context, board);
                    }
                  },
            btnRadius: 8,
            btnText: "add".tr(),
            btnTextSize: 16,
            btnTextWeight: AppFontWeight.bold,
            btnHeight: 56,
          )),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTapWidgetForLongDialog(
            items: items,
            value: selectedItem,
            label: "BoardType".tr(),
            marginBottom: 8,
            onChangeType: (item) {
              setState(() {
                selectedItem = item;
              });
            },
          ),
          CustomTextFieldWidget(
            label: "lbl_painting_space".tr(),
            hintText: "boardSpaceEntry".tr(),
            isDigitsOnly: true,
            initialValue: area != null ? area.toString() : null,
            keyboardType: TextInputType.number,
            suffixIcon: CustomTextWidget(
              "m2".tr(),
              fontSize: 12,
              fontWeight: AppFontWeight.semiBold,
              fontColor: AppColor.blackModern400Light,
            ),
            bottomMargin: 24,
            onChanged: (value) {
              setState(() {
                area = double.tryParse(value);
              });
            },
          ),
        ],
      ),
    );
  }
}

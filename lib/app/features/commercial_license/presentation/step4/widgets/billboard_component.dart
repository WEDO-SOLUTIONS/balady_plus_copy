import 'package:flutter/material.dart';
import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../commercial_license_exports.dart';

class BillboardComponent extends StatelessWidget {
  const BillboardComponent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 32, bottom: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: AppColor.white,
      ),
      child: Column(
        children: [
          const Row(
            children: [
              CustomSvgIconWidget(
                IconPath.additionalActivity,
                iconSize: 20,
              ),
              SizedBox(width: 6),
              CustomTextWidget(
                "لوحه اعلانيه",
                fontWeight: AppFontWeight.bold,
                fontSize: 18,
                fontColor: AppColor.blackModern600Light,
              ),
            ],
          ),
          const SizedBox(height: 14),
          ListView.separated(
            itemCount: 2,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, __) => const BillboardCard(),
          ),
          const SizedBox(height: 12),
          PlusAddButton(
            text: "اضافه لوحه اعلانيه",
            onPressed: () => BottomSheetDialog.showDraggableSheet(
              context,
              child: BottomSheetWithActions(
                title: "اضافه لوحه اعلانيه",
                action: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ElevatedButtonWidget.add(onPressed: () {}),
                ),
                body: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTapWidgetForLongDialog(
                      items: const [],
                      value: null,
                      label: "نوع اللوحة",
                      marginBottom: 8,
                      onChangeType: (item) {},
                    ),
                    CustomTextFieldWidget(
                      label: "مساحة اللوحة",
                      hintText: "ادخل مساحة اللوحة",
                      isDigitsOnly: true,
                      keyboardType: TextInputType.number,
                      suffixIcon: const CustomTextWidget(
                        "متر  مربع",
                        fontSize: 12,
                        fontWeight: AppFontWeight.semiBold,
                        fontColor: AppColor.blackModern400Light,
                      ),
                      bottomMargin: 24,
                      onChanged: (value) {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

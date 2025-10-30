import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_advisor/app/core/services/local/navigation_services.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:smart_advisor/app/features/_shared_feature_/domain/entities/lookUp_response.dart';
import 'package:smart_advisor/app/features/_shared_feature_/presentation/widgets/custom_widgets/customTextField.dart';
import 'package:smart_advisor/app/features/shared_features/widgets/custom_button.dart';

class CityDialog extends StatefulWidget {
  final LookUpItem? selection;
  final List<LookUpItem> items;
  final String title;
  final Function onSelection;
  const CityDialog(
      {super.key,
      this.selection,
      required this.items,
      required this.title,
      required this.onSelection});

  @override
  State<CityDialog> createState() => _CityDialogState();
}

class _CityDialogState extends State<CityDialog> {
  String search = "";
  int? selection;
  @override
  Widget build(BuildContext context) {
    List<LookUpItem> items =
        widget.items.where((e) => e.name.contains(search)).toList() ?? [];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: 600,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 20),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: AppStyle.heading2BoldStyle,
                    ),
                    GestureDetector(
                      onTap: () {
                        NavigationService.navigatorKey.currentState!.pop();
                      },
                      child: SvgPicture.asset(
                          "packages/smart_advisor/smart_advisor_assets/icons/svg/Button.svg"),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Textfield(onChanged: (String? t) {
                  setState(() {
                    search = t ?? "";
                  });
                }),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  height: 300,
                  child: ListView.builder(
                    itemCount: items.length ?? 0,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (_, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selection = index;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          margin: EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xffE1E1E2).withOpacity(0.40),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(selection == index
                                  ? 'packages/smart_advisor/smart_advisor_assets/icons/svg/Radio.svg'
                                  : 'packages/smart_advisor/smart_advisor_assets/icons/svg/Radionotselected.svg'),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  items![index].name ?? "",
                                  style: AppStyle.footNoteMediumStyle.copyWith(
                                      color: AppColor.textPrimaryColor,
                                      fontSize: 16),
                                ),
                              ),
                              SvgPicture.asset(
                                '',
                                color: AppColor.textPrimaryColor,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                CustomButton(
                  btnWidth: 361,
                  isDisabled: selection == null,
                  btnColor: AppColor.primary,
                  text: "تاكيد",
                  onPress: () {
                    widget.onSelection(items[selection ?? 0]);
                  },
                ),
              ],
            )),
      ),
    );
  }
}

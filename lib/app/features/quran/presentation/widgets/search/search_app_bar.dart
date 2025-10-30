import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/search_text_field_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function(String?) onSearch;

  const SearchAppBar({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 214,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                ImagePath.zmzmBackground,
              ))),
      child: Column(children: [
        CustomVerticalSpace(height: MediaQuery.of(context).padding.top),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.close,
                  color: AppColor.white,
                )),
            CustomTextWidget(
              ("البحث").tr(),
              fontColor: AppColor.blackModern50Light,
              fontSize: 20,
              fontWeight: AppFontWeight.bold,
            ),
            Container(
              height: 24,
              width: 24,
            )
          ],
        ),
        const CustomVerticalSpace(height: 37),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              CustomTextFieldWidget(
                textFieldHeight: 48,
                fillColor: Colors.transparent,
                hintText: ("إبحث عن آية").tr(),
                onChanged: onSearch,
                onSubmitted: onSearch,
                textFieldStyle: TextStyle(color: AppColor.primary100Light),
                hintStyle: TextStyle(color: AppColor.primary100Light),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: SvgPicture.asset(
                    IconPath.quranSearchIcon,
                  ),
                  onPressed: () {},
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(214);
}

class ZmZmChangeCityDropDownButton extends StatelessWidget {
  final String? currentCity;
  final Function onChangeCityPressed;

  const ZmZmChangeCityDropDownButton(
      {super.key, this.currentCity, required this.onChangeCityPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChangeCityPressed(),
      child: Container(
        height: 48,
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          CustomTextWidget(
            currentCity ?? ("city_select").tr(),
          ),
          Icon(Icons.arrow_drop_down, color: AppColor.white)
        ]),
        decoration: BoxDecoration(
            border: Border.all(color: AppColor.white),
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(6)),
      ),
    );
  }
}

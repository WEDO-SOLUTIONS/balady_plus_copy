import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';

class SearchTextFieldWidget extends StatefulWidget {
  final String hintText;
  final Function onTextChanged;
  final Function onSubmitSearch;
  final double containerHeight;

  const SearchTextFieldWidget({
    super.key,
    required this.hintText,
    required this.onTextChanged,
    required this.onSubmitSearch,
    this.containerHeight = 40,
  });

  @override
  State<SearchTextFieldWidget> createState() => _SearchTextFieldWidgetState();
}

class _SearchTextFieldWidgetState extends State<SearchTextFieldWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.containerHeight,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(color: const Color(0x29036362), width: 1),
        color: Colors.transparent,
      ),
      alignment: Alignment.center,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1)),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: TextFormField(
            onChanged: (String val) => widget.onTextChanged(val),
            controller: _controller,
            style: const TextStyle(color: AppColor.black, fontSize: 17, fontWeight: FontWeight.w500),
            cursorColor: AppColor.black100,
            textInputAction: TextInputAction.search,
            onFieldSubmitted: (String val) => widget.onSubmitSearch(val),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                color: AppColor.blackModern600Light,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
              suffixIcon: Container(
                margin: const EdgeInsetsDirectional.only(end: 5),
                child: const CustomSvgIconWidget(
                  IconPath.appBarSearch,
                  iconSize: 20,
                  iconColor: AppColor.primary700Light,
                ),
              ),
              fillColor: Colors.transparent,
              filled: true,
              isDense: true,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 10),
              suffixIconConstraints: const BoxConstraints(minHeight: 24, minWidth: 24),
            ),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder getOutlineDesign() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(4.0),
      borderSide: const BorderSide(color: AppColor.black100, width: 1),
    );
  }
}

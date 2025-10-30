import 'package:flutter/material.dart';

import '../../../../../../app/core/utils/constants/app_colors.dart';
import '../../../../../../app/core/utils/constants/constants.dart';
import '../../../../../../app/features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';

class SearchWidget extends StatefulWidget {
  Function onChange;
  final String? hint;

  SearchWidget({required this.onChange, Key? key, this.hint}) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.clear();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: Constants.boxDecorationWithShadowAndRoundedCorner,
      child: LayoutBuilder(
        builder: (_, constraints) {
          final height = constraints.maxHeight; // 60.0
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
            child: TextField(
              controller: _searchController,
              cursorColor: AppColor.baladyDarkGreen2,
              style: TextStyle(
                color: AppColor.black,
                fontSize: height / 3.5, // we need to get 16.0 (60.0 / 3.5)
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: TextStyle(
                  color: AppColor.black300,
                  fontSize: height / 3.5, // we need to get 16.0 (60.0 / 3.5)
                ),
                contentPadding: EdgeInsets.only(
                  right: 12.0,
                  left: 12.0,
                  top: height / 2.5, // we need to get 24.0 (60.0 / 2.5)
                  bottom: height / 3.5, // we need to get 16.0 (60.0 / 3.5)
                ),
                filled: true,
                fillColor: AppColor.white,
                border: _getBorder(),
                focusedBorder: _getBorder(),
                enabledBorder: _getBorder(),
                suffixIcon: CustomIconButtonWidget(
                  onPressed: () {
                    widget.onChange(_searchController.text);
                  },
                  icon: Icons.search,
                  iconColor: AppColor.black300,
                  // we need to get 30.0 (60.0 / 2.0)
                  iconSize: height / 2.0,
                  btnWidth: height / 2.0,
                  btnHeight: height / 2.0,
                ),
              ),
              onSubmitted: (value) {
                widget.onChange(value);
              },
              onChanged: (String value) => widget.onChange(value),
            ),
          );
        },
      ),
    );
  }

  OutlineInputBorder _getBorder() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.0),
        borderSide: const BorderSide(color: AppColor.white),
      );
}

import 'package:balady_plus/app/features/accecipilities/balady_theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../../../core/services/services_exports.dart';
import '../../../../../core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/home_page/home_exports.dart';
import '../../../shared_feature_exports.dart';

class BottomSheetWithActions extends StatefulWidget {
  final String title;
  final Widget body;
  final Widget? action;
  final bool? searchable;
  final bool? isList;
  final Color? backgroundColor;
  final Function? onSearchChanged;

  const BottomSheetWithActions(
      {super.key,
      required this.title,
      required this.body,
      this.action,
      this.isList = false,
      this.searchable,
      this.backgroundColor,
      this.onSearchChanged});

  @override
  State<BottomSheetWithActions> createState() => _BottomSheetWithActionsState();
}

class _BottomSheetWithActionsState extends State<BottomSheetWithActions> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _textEditingController.addListener(() {
      if (widget.onSearchChanged != null) {
        widget.onSearchChanged!(_textEditingController.text);
      }
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BaladyThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Container(
            padding: padding,
            // height: context.screenHeight * 0.90,
            color: widget.backgroundColor ?? AppColor.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const DrawLineWidget(
                  lineWidth: 70.0,
                  lineHeight: 6.0,
                  lineColor: AppColor.blackModern200Light,
                  radius: 46.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: CustomTextWidget(
                        widget.title,
                        textAlign: TextAlign.start,
                        maxLines: 3,
                        textStyle: AppStyle.mainTextSecondaryStyle.copyWith(
                          fontSize: 24.0,
                          color: themeNotifier.isDarkMode ? Colors.white : AppColor.black,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: CircleIcon(
                        icon: Icons.close,
                        iconColor: AppColor.primary600Light,
                        backgroundColor: AppColor.geyser.withOpacity(0.4),
                        iconSize: 18,
                      ),
                    ),
                  ],
                ),
                if (widget.searchable ?? false)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: CustomTextFieldWidget(
                      controller: _textEditingController,
                      hintText: 'search'.tr(),
                      prefixIcon: const DrawIconBasedTypeWidget(
                        icon: IconPath.search,
                        iconColor: AppColor.primary700Light,
                      ),
                      borderRadius: 16,
                      borderColor: AppColor.primary900Light16,
                      suffixIcon: _textEditingController.text.isNotEmpty
                          ? InkWell(
                              onTap: () {
                                _textEditingController.text = '';
                                FocusScope.of(context).unfocus();
                              },
                              child: const DrawIconBasedTypeWidget(
                                icon: Icons.close,
                                iconColor: AppColor.primary700Light,
                              ),
                            )
                          : null,
                    ),
                  ),
                if (widget.isList == true) widget.body,
                if (widget.isList == false) ...[
                  const SizedBox(height: 16),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          widget.body,
                        ],
                      ),
                    ),
                  )
                ],
                if (widget.action != null)
                  Container(
                    padding: EdgeInsets.only(bottom: 24),
                    child: SafeArea(
                      top: false,
                      child: widget.action!,
                    ),
                  ),
              ],
            ),
          ),
        );
      }
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        padding: padding,
        height: context.screenHeight * 0.90,
        color: AppColor.white,
        child: Column(
          children: [
            const DrawLineWidget(
              lineWidth: 70.0,
              lineHeight: 6.0,
              lineColor: AppColor.gray,
              radius: 46.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTextWidget(
                  widget.title,
                  textAlign: TextAlign.center,
                  textStyle: AppStyle.mainTextSecondaryStyle.copyWith(
                    fontSize: 24.0,
                    color: AppColor.black,
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: CircleIcon(
                    icon: Icons.close,
                    iconColor: AppColor.primary600Light,
                    backgroundColor: AppColor.geyser.withOpacity(0.4),
                    iconSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    widget.body,
                  ],
                ),
              ),
            ),
            if (widget.action != null)
              SafeArea(
                top: false,
                child: widget.action!,
              ),
          ],
        ),
      ),
    );
  }

  EdgeInsetsGeometry get padding => EdgeInsets.only(
        right: UIHelper.mediumPadding,
        left: UIHelper.mediumPadding,
        top: UIHelper.smallPadding,
        bottom: context.bottomPadding,
      );

  BuildContext get context => NavigationService.navigatorKey.currentContext!;
}

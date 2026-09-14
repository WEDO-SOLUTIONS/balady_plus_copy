import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/delegators/presentation/delegators_cubit/delegators_cubit.dart';
import 'package:balady_plus/app/features/delegators/presentation/widgets/delegator_list.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/utils/constants/dialog_names.dart';
import '../../../home_page/presentation/widgets/home_app_bar/circle_icon.dart';
import '../buttons/elevated_button_widgets.dart';
import '../widgets/custom_svg_icon_widget.dart';
import '../widgets/draw_line_widget.dart';
import 'bottom_sheet_dialogs.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class NotAuthorizedIndivisualDialog extends StatelessWidget {
  String? routName;
  NotAuthorizedIndivisualDialog({super.key, this.routName});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.white,
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          const DrawLineWidget(lineWidth: 70.0, lineHeight: 6.0, lineColor: AppColor.blackModern200Light, radius: 46.0),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CustomSvgIconWidget("assets/icons/svg/alert-user.svg", iconSize: 22),
                  const SizedBox(width: 8),
                  CustomTextWidget(
                    "serivce_no_available_for_indivisual".tr(),
                    fontSize: 15,
                    fontWeight: AppFontWeight.bold,
                    fontColor: AppColor.primary900Light,
                  ),
                ],
              ),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: CircleIcon(
                  icon: Icons.close,
                  iconColor: AppColor.primary600Light,
                  backgroundColor: AppColor.geyser.withValues(alpha: 0.4),
                  iconSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          CustomTextWidget(
            "you_must_switch_to_entity_profile".tr(),
            fontSize: 12,
            maxLines: 5,
            height: 1.4,
            fontWeight: AppFontWeight.bold,
            fontColor: AppColor.blackModern500Light,
          ),
          const SizedBox(height: 64),
          /* ElevatedButtonWidget.primaryCustom(
              onPressed: () => Navigator.pop(context),
              text: "contino_as_indiviusal".tr()),
          const SizedBox(
            height: 16,
          ),*/
          ElevatedButtonWidget.primaryCustom(
            onPressed: () async {
              try {
                await BottomSheetDialog.showDraggableSheet(
                  context,
                  dialogKeyName: DialogName.delegatorsDialog,
                  currentRouteName: routName ?? RouteName.commercialLicenseServicePage,
                  child: DelegatorList(fromService: true, delegatorsCubit: sl<DelegatorsCubit>()),
                );
                if (!context.mounted) {
                  return;
                }
                Navigator.of(context).pop();
              } catch (error, stackTrace) {
                LogsViewModel().sendEventFromModel(
                  event: ErrorExceptionModel(
                    nameEvent: EventsName.handledException,
                    message: error.toString(),
                    stackTrace: stackTrace.toString(),
                  ),
                );
              }
            },
            text: "switch_to_entity".tr(),
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}

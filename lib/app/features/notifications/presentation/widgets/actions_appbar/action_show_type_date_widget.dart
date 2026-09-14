import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/notifications/presentation/bloc/notifications_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../_shared_feature_/presentation/widgets/custom_popups_widgets.dart';

class ActionShowTypeDateWidget extends StatelessWidget {
  const ActionShowTypeDateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    NotificationsListCubit cubit = context.watch<NotificationsListCubit>();
    return AppPopupMenu<int>(
      menuItems: [
        PopupMenuItem(
          value: 1,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [SvgPicture.asset(IconPath.check), const SizedBox(width: 12), Text('make_all_read'.tr())],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [SvgPicture.asset(IconPath.trash01), const SizedBox(width: 12), Text('delete_all'.tr())],
          ),
        ),
      ],
      initialValue: 0,
      onSelected: (int value) async {
        debugPrint(value.toString());
        switch (value) {
          case 1:
            cubit.markReadNotificationsMessages();
            break;
          case 2:
            await CustomPopUpsWidgets.showConfirmAppMessageDialog(
              context,
              ("delete_all_notifications_confirmation").tr(),
              primaryBtn: () {
                cubit.deletedNotificationsMessages();
                Navigator.of(context).pop(true);
              },
            );
            break;
        }
      },
      onCanceled: () {},
      tooltip: "",
      elevation: 12,
      icon: SvgPicture.asset(IconPath.dotsVertical),
      offset: const Offset(0, 65),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
    );
  }
}

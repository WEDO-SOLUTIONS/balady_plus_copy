import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class ProfileMenu extends StatelessWidget {
  final VoidCallback? onTapLogout;
  final VoidCallback? onTapInfo;
  final VoidCallback? onTapChangeAvatar;

  const ProfileMenu({
    super.key,
    this.onTapLogout,
    this.onTapInfo,
    this.onTapChangeAvatar,
  });

  @override
  Widget build(BuildContext context) => PopupMenuButton<bool>(
        itemBuilder: (context) => [
          PopupMenuItem(
            onTap: onTapInfo?.call,
            child: Text(context.l10n.view_info_short, style: context.textStyle.text),
          ),
          PopupMenuItem(
            onTap: onTapChangeAvatar?.call,
            child: Text(context.l10n.change_avatar, style: context.textStyle.text),
          ),

          /// This code is commented because the logout dialog didn't liked by the client
          /// But design still have this logout behavior
          /// IF DESIGN CHANGES, UNCOMMENT THIS CODE OR DELETE IT
          /// https://urbi-team.youtrack.cloud/issue/BSA-331
          // PopupMenuItem(
          //     child: Text(
          //       context.l10n.logOut,
          //       style: context.textStyle.text.copyWith(
          //         color: context.color.textAndIconsStatusNegative,
          //       ),
          //     ),
          //     onTap: () {
          //       showDialog(
          //         context: context,
          //         builder: (ctx) => LogoutDialog(
          //           onCancel: () => Navigator.of(ctx).pop(),
          //           onLogout: onTapLogout?.call,
          //           title: context.l10n.areYouSureYouWantToLogOutOfYourAccount,
          //           logOutText: context.l10n.logOut,
          //           cancelText: context.l10n.cancel,
          //         ),
          //       );
          //     }),
        ],
        icon: AppIcons(
          iconData: SystemIcons.ellipsis,
          color: context.colors.foregroundSoft,
        ),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      );
}

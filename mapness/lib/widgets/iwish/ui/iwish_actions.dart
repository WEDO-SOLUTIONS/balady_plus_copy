import 'package:flutter/material.dart';
import 'package:mapness/widgets/iwish/lib/iwish_action_drive_button.dart';

class IwishActions extends StatelessWidget {

  const IwishActions({
    // required this.onShare,
    // required this.onEnter,
    // required this.onCall,
    required this.onDrive, required this.driveLabel, super.key,
  });
  // final VoidCallback onShare;
  // final VoidCallback onEnter;
  // final VoidCallback onCall;
  final VoidCallback onDrive;

  final String driveLabel;

  @override
  Widget build(BuildContext context) {
    // const gap = SizedBox(width: 8);

    return SizedBox(
      height: 41,
      child: Row(
        children: [
          IwishActionDriveButton(label: driveLabel, onPressed: onDrive),
          // gap,
          // IwishActionIconButton(
          //   iconAsset: 'assets/icons/svg/ic_share.svg',
          //   onPressed: onShare,
          // ),
          // gap,
          // IwishActionIconButton(
          //   iconAsset: 'assets/icons/svg/ic_entrance.svg',
          //   onPressed: onEnter,
          // ),
          // gap,
          // IwishActionIconButton(
          //   iconAsset: 'assets/icons/svg/ic_phone.svg',
          //   onPressed: onCall,
          // ),
        ],
      ),
    );
  }
}

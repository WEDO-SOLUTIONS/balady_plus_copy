import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CostumeListTile extends StatelessWidget {
  final Null Function()? onTap;
  final Widget? leading;
  final Widget title;
  final Widget? trailing;
  final bool showDivider;

  const CostumeListTile({
    super.key,
    required this.title,
    this.onTap,
    this.leading,
    this.trailing,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                leading != null
                    ? Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                        child: leading!,
                      )
                    : const SizedBox(),
                Flexible(
                  fit: FlexFit.tight,
                  child: title,
                ),
                trailing != null
                    ? Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                        child: trailing!,
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
        showDivider
            ? const Divider(
                color: AppColor.blackModern100Light,
                height: 12,
                thickness: 1,
              )
            : const SizedBox(),
      ],
    );
  }
}

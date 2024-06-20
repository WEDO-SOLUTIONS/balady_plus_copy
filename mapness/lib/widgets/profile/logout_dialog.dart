import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

class LogoutDialog extends StatelessWidget {
  final Function? onLogout;
  final Function? onCancel;
  final String title;
  final String logOutText;
  final String cancelText;

  const LogoutDialog({
    required this.title,
    required this.logOutText,
    required this.cancelText,
    super.key,
    this.onLogout,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) => Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(Spacing.horizontalPaddingInsideWrapper),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(color: const Color(0xffFFFFFF), borderRadius: BorderRadius.circular(14)),
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(title,
                        textAlign: TextAlign.center,
                        style: context.textStyle.footNote.copyWith(color: context.color.textAndIconsBaseSecondary)),
                  ),
                  const Divider(
                    color: Color(0x3c3c435c),
                  ),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0).copyWith(top: 8),
                      child: Text(
                        logOutText,
                        style: context.textStyle.callout.copyWith(
                          color: context.color.textAndIconsStatusNegative,
                        ),
                      ),
                    ),
                    onTap: () => onLogout?.call(),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            InkWell(
              child: Container(
                decoration: BoxDecoration(color: const Color(0xffFFFFFF), borderRadius: BorderRadius.circular(14)),
                alignment: Alignment.center,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    cancelText,
                    style: context.textStyle.callout.copyWith(
                      color: context.color.textAndIconsBasePrimary,
                    ),
                  ),
                ),
              ),
              onTap: () => onCancel?.call(),
            ),
          ],
        ),
      ));
}

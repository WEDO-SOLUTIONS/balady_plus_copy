import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
              decoration: BoxDecoration(color: const Color(0xffB3B3B3), borderRadius: BorderRadius.circular(14)),
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(title),
                  ),
                  const Divider(
                    color: Color(0xff3c3c435c),
                  ),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(logOutText,
                          style: const TextStyle(
                            fontSize: 17,
                            color: Color(0xffFF3B30),
                          )),
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
                decoration: BoxDecoration(color: const Color(0xffB3B3B3), borderRadius: BorderRadius.circular(14)),
                alignment: Alignment.center,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    cancelText,
                    style: const TextStyle(
                      fontSize: 17,
                      color: Color(0xff007AFF),
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

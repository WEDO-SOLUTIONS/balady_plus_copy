import 'package:balady_plus/app/features/notifications/presentation/widgets/notifications_settings/notifications_settings.dart';
import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class NotificationsCell extends StatefulWidget {
  const NotificationsCell({super.key});

  @override
  State<NotificationsCell> createState() => _NotificationsCellState();
}

class _NotificationsCellState extends State<NotificationsCell> {
  bool checked = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          child: Material(
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xFFF5F7FA),
            child: InkWell(
              onTap: () {
                setState(() {
                  checked = !checked;
                });
                // ref.read(darkModeProvider.notifier).toggle();
              },
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 48,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2.0),
                        child: Text(
                          'notifications'.tr(),
                          style: Theme.of(context)
                              .extension<ThemeTextStyles>()!
                              .textM
                              .copyWith(color: const Color(0xFF1E2A36)),
                        ),
                      ),
                      const Spacer(),
                      IgnorePointer(
                        child: CupertinoSwitch(
                          onChanged: (bool value) {},
                          value: checked,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Text(
                'يمكنك من هنا أو إلغاء تفعيل الإشعار',
                style: Theme.of(context)
                    .extension<ThemeTextStyles>()!
                    .textXS
                    .copyWith(color: const Color(0xFF1E2A36).withOpacity(0.36)),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        checked
            ? GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const NotificationsSettings()));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/svg/profile/settings.svg",
                        height: 24,
                        width: 24,
                        color: Colors.red,
                      ),
                      Text(
                        'إدارة الإشعارات للخدمات',
                        style: Theme.of(context)
                            .extension<ThemeTextStyles>()!
                            .textXS
                            .copyWith(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}

import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../core/utils/constants/app_style.dart';

class NotificationsSettingsCell extends StatefulWidget {
  const NotificationsSettingsCell({super.key});

  @override
  State<NotificationsSettingsCell> createState() =>
      _NotificationsSettingsCellState();
}

class _NotificationsSettingsCellState extends State<NotificationsSettingsCell> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(
      5,
      (index) => Padding(
        padding: const EdgeInsets.all(8.0),
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
    );

    return ExpansionTile(
        shape: const Border(),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'mun_title'.tr(),
            style: AppStyle.cardTitleTextStle,
          ),
        ),
        children: items);
  }
}

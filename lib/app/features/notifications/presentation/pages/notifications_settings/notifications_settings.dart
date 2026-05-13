import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../data/model/notifications_settings_list/category.dart';
import 'notifications_settings_cell.dart';

class NotificationsSettings extends StatefulWidget {
  final List<Category> notificationsList;
  const NotificationsSettings({required this.notificationsList, super.key});

  @override
  State<NotificationsSettings> createState() => _NotificationsSettingsState();
}

class _NotificationsSettingsState extends State<NotificationsSettings> {
  bool isEnabled = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        leading: IconButton(
          tooltip: 'a11yBack'.tr(),
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),

        elevation: 0,
        title: Text(
          'settings'.tr(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontFamily: GeneralKey.appFontType,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: ListView.builder(
        itemCount: widget.notificationsList.length,
        itemBuilder: ((context, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: NotificationsSettingsCell(
            category: widget.notificationsList[index],
          ),
        )),
      ),
    );
  }
}

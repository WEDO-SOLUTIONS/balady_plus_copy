import 'package:balady_uikit/core/extensions/build_context_ext.dart';
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
      backgroundColor: context.colors.backgroundSurface2,

      appBar: AppBar(
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back_ios,color: context.color.surfaceStatusAccent,)),
        elevation: 0,
        title: Text('settings'.tr()),
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

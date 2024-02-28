import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'notifications_settings_cell.dart';

class NotificationsSettings extends StatefulWidget {
  const NotificationsSettings({super.key});

  @override
  State<NotificationsSettings> createState() => _NotificationsSettingsState();
}

class _NotificationsSettingsState extends State<NotificationsSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 0,
        title: Text(
          'settings'.tr(),
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: ListView.builder(
          itemCount: 2,
          itemBuilder: ((context, index) => const Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: NotificationsSettingsCell(),
              ))),
    );
  }
}

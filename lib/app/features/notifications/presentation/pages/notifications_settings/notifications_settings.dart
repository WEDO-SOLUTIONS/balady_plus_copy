import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/app/features/notifications/presentation/bloc/notifications_settings/notifications_list_settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../data/model/notifications_settings_list/category.dart';
import '../../../data/model/notifications_settings_list/notifications_settings_list_response.dart';
import '../../../data/repositories/notification_repository_implementation.dart';
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
          itemCount: widget.notificationsList.length,
          itemBuilder: ((context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: NotificationsSettingsCell(category: widget.notificationsList[index]),
              ))),
    );
  }
}

import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/features/_shared_features/notifications_count/cubit_notification_count/notifications_item_cubit.dart';
import 'package:balady_plus/app/features/notifications/presentation/pages/notifications_settings/notifications_settings.dart';
import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../etmam_app/features/_shared_feature_/shared/presentation/widgets/reload_widget.dart';
import '../../../notifications/data/repositories/notification_repository_implementation.dart';
import '../../../notifications/domain/entities/set_notifications_profile_params.dart';
import '../../../notifications/presentation/bloc/notifications_settings/notifications_setting_cubit.dart';

class NotificationsSettingCell extends StatelessWidget {
  const NotificationsSettingCell({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return NotificationsCountCubit(webService: sl());
      },
      child: BlocBuilder<NotificationsCountCubit, SucceedCountState>(
        builder: (contextCubit, state) {
          return  SvgPicture.asset("assetName");
        },
      ),
    );
  }
}

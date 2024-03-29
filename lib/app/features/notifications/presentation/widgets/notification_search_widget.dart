import 'package:balady_plus/app/features/notifications/presentation/bloc/notifications_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class NotificationSearchWidget extends StatelessWidget {
  const NotificationSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    NotificationsListCubit cubit = context.watch<NotificationsListCubit>();
    return TextFormField(
      onChanged: (text) {},
      onFieldSubmitted: (text) {
        cubit.params.query = text;
        cubit.getNotificationsMessagesList();
      },
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: "search".tr(),
        hintStyle: AppStyle.violatioCreateSubtitle.copyWith(
          color: Colors.grey.shade400,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SvgPicture.asset(
            IconPath.search,
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(
              Colors.grey.shade400,
              BlendMode.srcIn,
            ),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        isDense: true,
        filled: true,
        fillColor: AppColor.white10,
      ),
    );
  }
}

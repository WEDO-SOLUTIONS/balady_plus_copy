import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart' show AppColor, IconPath;
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../requests_exports.dart'
    show GetRequestsEvent, RequestsBloc, SearchRequestsByNumberEvent;

class AppBarSeachBar extends StatelessWidget implements PreferredSizeWidget {
  const AppBarSeachBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CustomTextFieldWidget(
        hintText: 'search'.tr(),
        prefixIcon: const DrawIconBasedTypeWidget(
          icon: IconPath.search,
          iconColor: AppColor.primary700Light,
        ),
        borderRadius: 16,
        borderColor: AppColor.primary900Light16,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        onSubmitted: (value) {
          context.read<RequestsBloc>().add(
                SearchRequestsByNumberEvent(requestNumber: value),
              );
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(76);
}

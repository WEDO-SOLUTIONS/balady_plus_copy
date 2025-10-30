import 'package:balady_plus/app/features/classification_certificate/persentation/classification_certificate_verify/utility/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../bloc/classification_certificate_verify_bloc.dart';
import 'normal_search/search_normal_options_widget.dart';

class TitleWithWidget extends StatelessWidget {
  final String title;

  final Widget widget;
  final bool isRequired;

  const TitleWithWidget({
    super.key,
    required this.title,
    required this.widget,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title.tr(),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(width: 4),
            isRequired ?  Text(
              "*".tr(),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.error,
                  ),
            ) : const SizedBox(),
          ],
        ),
        const SizedBox(height: 6),
        widget,
      ],
    );
  }
}

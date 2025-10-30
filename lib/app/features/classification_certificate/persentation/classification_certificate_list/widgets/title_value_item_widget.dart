import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:balady_plus/app/features/classification_certificate/persentation/classification_certificate_list/bloc/classification_certificate_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../bloc/classification_certificate_list_cubit.dart';
import 'classification_certificate_item_widget.dart';

class TitleValueItemWidget extends StatelessWidget {
  final String title, value;

  const TitleValueItemWidget({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          fit: FlexFit.tight,
          child: Text(
            title.tr(),
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: const Color(0xff6B6B6B)
            ),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../_shared_feature_/presentation/widgets/default_appbar_widget.dart';

class SelfRatingResultAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const SelfRatingResultAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultAppBarWidget(
      title: "self_rating_result".tr(),
      showBack: false,
      flexibleSpace: Container(),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close,
              color: Colors.black,
            ))
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

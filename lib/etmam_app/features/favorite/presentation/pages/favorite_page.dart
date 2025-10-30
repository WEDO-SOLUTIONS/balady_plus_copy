import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show AppEvents;
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show CommonFunctions, trans;
import 'package:balady_plus/etmam_app/features/favorite/favorite_exports.dart'
    show FavoriteItemWidget;
import 'package:flutter/material.dart';

import '../../../_shared_feature_/shared/shared_feature_exports.dart'
    show CustomAppBar;

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePage();
}

class _FavoritePage extends State<FavoritePage> {
  @override
  void initState() {
    super.initState();
    //CommonFunctions.sendEventToAnalytics(AppEvents.FavoriteListPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: trans("favorite"),
          withBackImg: false,
        ),
        body: /*(unAuthorized)
                  ? NeedLoginWidget();
               :
            (state.items?.length ?? 0) <= 0
            ?
            EmptyStateWidget(
                img: IconPath.emptyFavoriteLogo,
                title: trans('empty_favorite_title'),
                desc: trans('empty_favorite_desc'), imgHeight: 187)
             :*/
            ListView.builder(
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                itemCount: 5,
                itemBuilder: (ctx, index) {
                  return const FavoriteItemWidget();
                }));
  }
}

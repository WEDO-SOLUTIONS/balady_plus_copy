import '/app/core/utils/utils_exports.dart';
import '/app/features/_shared_feature_/presentation/widgets/custom_icon_widget.dart';
import '/app/features/home/domain/entities/news_response.dart';
import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({
    Key? key,
    this.item,
  }) : super(key: key);

  final NewsItem? item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsetsDirectional.only(end: 12, bottom: 4),
      padding: const EdgeInsets.only(bottom: 14),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColor.gray,
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(1, 1), // changes position of shadow
          ),
        ],
        color: AppColor.white,
        borderRadius: BorderRadiusDirectional.only(
            topStart: Radius.circular(30), bottomEnd: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadiusDirectional.only(
                topStart: Radius.circular(30)),
            child: CustomIconWidget(
              item?.getIconUrl ?? "",
              iconWidth: 160,
              iconHeight: 100,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    item?.title ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                        AppStyle.mainTextStyle.copyWith(color: AppColor.blue),
                  ),
                ),
                const SizedBox(height: 2),
                Flexible(
                  child: Text(
                    item?.creationDate.toString() ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        AppStyle.mainTextStyle.copyWith(color: AppColor.blue),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

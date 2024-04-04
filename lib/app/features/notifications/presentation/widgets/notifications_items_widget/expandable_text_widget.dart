import 'package:flutter/material.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:provider/provider.dart';

class ExpandableTextWidget extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const ExpandableTextWidget({
    super.key,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExpandableTextProvider(),
      child: Selector<ExpandableTextProvider, bool>(
        selector: (_, provider) => provider.isExpandable,
        builder: (contextProvider, isExpandable, _) {
          ExpandableTextProvider provider =
              Provider.of<ExpandableTextProvider>(contextProvider);
          return InkWell(
            onTap: () {
              provider.expandableText();
              if (onTap != null) {
                onTap!();
              }
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6.0,
                      vertical: 8,
                    ),
                    child: Linkify(
                      onOpen: (link) =>
                          CommonFunctions.openBaladyWebView(link.url),
                      text: text,
                      maxLines: isExpandable ? null : 1,
                      style: AppStyle.nearbyItemSubTitleTextStyle.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                        color: AppColor.warmGrey2,
                      ),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ),
                Icon(
                  isExpandable
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ExpandableTextProvider extends ChangeNotifier {
  bool isExpandable;

  ExpandableTextProvider({this.isExpandable = false});

  void expandableText() {
    isExpandable = !isExpandable;
    notifyListeners();
  }
}

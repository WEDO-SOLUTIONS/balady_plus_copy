import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:flutter/material.dart';

//!
class FavSearchSectionShimmerLoadingWidget extends StatelessWidget {
  const FavSearchSectionShimmerLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Color placeholderColor = Theme.of(context).colorScheme.surface;

    final double itemHeight = context.h(64);

    final double horizontalPadding = context.screenWidth * 0.02;
    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(height: context.screenHeight * 0.02),
      scrollDirection: Axis.vertical,
      itemCount: 10,
      itemBuilder: (context, index) {
        return SizedBox(
          width: context.screenWidth,
          height: itemHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Theme.of(context).cardColor),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: context.w(48),
                        height: context.h(48),
                        decoration: BoxDecoration(color: placeholderColor, borderRadius: BorderRadius.circular(10)),
                      ),
                      SizedBox(width: context.screenWidth * 0.02),
                      Container(
                        width: context.w(192),
                        height: context.h(15),
                        decoration: BoxDecoration(color: placeholderColor, borderRadius: BorderRadius.circular(4)),
                      ),
                    ],
                  ),
                  Container(
                    width: context.w(40),
                    height: context.h(25),
                    decoration: BoxDecoration(color: placeholderColor, borderRadius: BorderRadius.circular(15)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

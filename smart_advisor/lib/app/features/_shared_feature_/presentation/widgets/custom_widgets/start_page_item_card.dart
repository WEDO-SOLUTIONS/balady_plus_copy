import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import 'package:flutter/material.dart';
import '/app/features/_shared_feature_/presentation/models/startpagemodel.dart';

class StartPageItemCard extends StatelessWidget {
  bool isSelected = false;
  StartPageItemCard({super.key, required this.item, required this.isSelected});

  final Startpagemodel item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 16,
        left: 16,
        top: 12,
      ),
      child: Container(
        //padding: EdgeInsets.all(16),
        height: 132,
        //width: 353,

        decoration: BoxDecoration(
          color: const Color(0xffFFFFFF),
          image: DecorationImage(
              image: AssetImage(
                item.image ?? "",
              ),
              fit: BoxFit.cover),
          border: isSelected == true
              ? Border.all(color: const Color(0xff4E976C))
              : null,
          borderRadius: const BorderRadius.all(Radius.circular(14)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title!,
                textAlign: TextAlign.start,
                style:
                    AppStyle.heading2BoldStyle.copyWith(color: AppColor.white),
              ),
              //the point from media Q to force the text takes 60% from size of contaiuner

              SizedBox(
                height: 6,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.60,
                child: Text(
                  item.subtitle!,
                  maxLines: 2,
                  style:
                      AppStyle.textRegularStyle.copyWith(color: AppColor.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

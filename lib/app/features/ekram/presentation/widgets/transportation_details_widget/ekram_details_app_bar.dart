import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../ekram_status_widget.dart';

class EkramDetailsAppBar extends StatefulWidget {
  final String title;
  final String orderNo;
  final String status;
  final Function? onExit;

  const EkramDetailsAppBar(
      {Key? key,
      required this.title,
      required this.status,
      required this.orderNo,
      this.onExit})
      : super(key: key);

  @override
  _EkramDetailsAppBar createState() => _EkramDetailsAppBar();
}

class _EkramDetailsAppBar extends State<EkramDetailsAppBar> {
  var top = 0.0;
  bool silverCollapsed = false;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: MediaQuery.of(context).padding.top + 160,
      floating: false,
      leading: GestureDetector(
        onTap: () {
          if (widget.onExit != null)
            widget.onExit!();
          else
            Navigator.of(context).pop();
        },
        child: Container(
          margin: const EdgeInsets.only(right: 10),
          child: Image.asset(
            Constants.backImg,
            height: 20.0,
            width: 20.0,
            color: Colors.black,
          ),
        ),
      ),
      leadingWidth: 35,
      actions: [
        /* IconButton(
            iconSize: 24,
            onPressed: (){},
            icon: CustomSvgIconWidget(
              Constants.shareIcon,
              iconHeight: 24,
              iconWidth: 24,
            ))*/
      ],
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
        statusBarBrightness: Brightness.light,
      ),
      flexibleSpace: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        top = constraints.biggest.height;
        double smallAppBarHeight =
            AppBar().preferredSize.height + MediaQuery.of(context).padding.top;
        if (top == smallAppBarHeight) {
          silverCollapsed = true;
        } else {
          silverCollapsed = false;
        }
        return EkramCardBigHeader(
          title: widget.title,
          status: widget.status,
          orderNo: widget.orderNo,
          isScrolled: silverCollapsed,
        );
      }),
    );
  }
}

class EkramCardBigHeader extends StatefulWidget {
  final String title;
  final String status;
  final String orderNo;
  final bool isScrolled;

  const EkramCardBigHeader(
      {Key? key,
      required this.title,
      required this.status,
      required this.orderNo,
      required this.isScrolled})
      : super(key: key);

  @override
  _EkramCardBigHeaderState createState() => _EkramCardBigHeaderState();
}

class _EkramCardBigHeaderState extends State<EkramCardBigHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: Constants.appBarBoxShadow,
      ),
      alignment: AlignmentDirectional.topStart,
      child: FlexibleSpaceBar(
        centerTitle: true,
        title: widget.isScrolled
            ? SizedBox(
                width: MediaQuery.of(context).size.width - 60,
                child: CustomTextWidget(
                  widget.title,
                  fontColor: AppColor.black,
                  fontSize: 20,
                  maxLines: 1,
                  textScaleFactor: 1,
                  textOverflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              )
            : Container(),
        background: widget.isScrolled
            ? const Center()
            : Padding(
                padding: EdgeInsetsDirectional.only(
                    top: MediaQuery.of(context).padding.top + 60,
                    start: 20,
                    end: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Constants.verticalSpaceSmall,
                    EkramStatusWidget(status: widget.status),
                    Constants.verticalSpaceSmall,
                    CustomTextWidget(
                      widget.title,
                      fontColor: AppColor.black,
                      fontSize: 22.0,
                      textAlign: TextAlign.start,
                      height: 1.2,
                      maxLines: 1,
                      textScaleFactor: 1,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                    Constants.verticalSpaceSmall,
                    CustomTextWidget(
                      widget.orderNo,
                      fontColor: AppColor.black500,
                      fontSize: 16.0,
                      textAlign: TextAlign.start,
                      height: 1.3,
                      fontWeight: AppFontWeight.medium,
                      maxLines: 2,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

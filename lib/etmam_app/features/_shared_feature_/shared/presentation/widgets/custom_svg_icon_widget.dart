import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart' show SvgPicture;

class CustomSvgIconWidget extends StatelessWidget {
  final String iconPath;
  final double iconSize;
  final double? iconWidth;
  final double? iconHeight;
  final Color? iconColor;
  final Alignment iconAlignment;
  final BoxFit iconFit;

  const CustomSvgIconWidget(
    this.iconPath, {
    Key? key,
    this.iconSize = 16.0,
    this.iconWidth,
    this.iconHeight,
    this.iconColor,
    this.iconAlignment = Alignment.center,
    this.iconFit = BoxFit.contain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      iconPath,
      color: iconColor,
      width: iconWidth ?? iconSize,
      height: iconHeight ?? iconSize,
      alignment: iconAlignment,
      fit: iconFit,
    );
  }
}

class CustomImageIconWidget extends StatelessWidget {
  final String iconPath;
  final double iconSize;
  final double? iconWidth;
  final double? iconHeight;
  final Color? iconColor;
  final Alignment iconAlignment;
  final BoxFit iconFit;

  const CustomImageIconWidget(
    this.iconPath, {
    Key? key,
    this.iconSize = 16.0,
    this.iconWidth,
    this.iconHeight,
    this.iconColor,
    this.iconAlignment = Alignment.center,
    this.iconFit = BoxFit.contain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      iconPath,
      color: iconColor,
      width: iconWidth ?? iconSize,
      height: iconHeight ?? iconSize,
      alignment: iconAlignment,
      fit: iconFit,
    );
  }
}

/*class CustomNetworkImageWidget extends StatefulWidget {
  final String imagePath;
  final double imageWidth;
  final double imageHeight;
  final Color? imageColor;
  final BoxFit imageFit;
  final Widget? placeHolderWidget;

  const CustomNetworkImageWidget(
    this.imagePath, {
    Key? key,
    this.imageWidth = 16,
    this.imageHeight = 16,
    this.imageColor,
    this.imageFit = BoxFit.cover,
    this.placeHolderWidget,
  }) : super(key: key);

  @override
  State<CustomNetworkImageWidget> createState() =>
      _CustomNetworkImageWidgetState();
}

class _CustomNetworkImageWidgetState extends State<CustomNetworkImageWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.imagePath.isUrl
        ? widget.imagePath.isSvgIcon
            ? SvgPicture.network(
                widget.imagePath,
                width: widget.imageWidth,
                height: widget.imageHeight,
                fit: widget.imageFit,
                placeholderBuilder: (BuildContext context) {
                  return widget.placeHolderWidget ??
                      Container(
                        color: AppColor.bottomNavigationSelected,
                        width: widget.imageWidth,
                        height: widget.imageHeight,
                      );
                },
              )
            : Image.network(
                widget.imagePath,
                width: widget.imageWidth,
                height: widget.imageHeight,
                fit: widget.imageFit,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return widget.placeHolderWidget ??
                      Container(
                        color: AppColor.bottomNavigationSelected,
                        width: widget.imageWidth,
                        height: widget.imageHeight,
                      );
                },
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return widget.placeHolderWidget ??
                      Container(
                        color: AppColor.bottomNavigationSelected,
                        width: widget.imageWidth,
                        height: widget.imageHeight,
                      );
                },
              )
        : widget.placeHolderWidget ??
            SvgPicture.asset(
              IconPath.otpLogo,
              width: widget.imageWidth,
              height: widget.imageHeight,
              fit: widget.imageFit,
            );
  }

  bool isSvg() {
    final SvgParser parser = SvgParser();
    try {
      parser.parse(widget.imagePath, warningsAsErrors: true);
      return true;
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return false;
    }
  }
}*/

/* class CustomSvgIconWithBackgroundWidget extends StatelessWidget {
  final String iconPath;
  final double iconWidth;
  final double iconHeight;
  final Color? iconColor;
  final Alignment iconAlignment;
  final BoxFit iconFit;
  final double width;
  final double height;
  final Color? backgroundColor;
  final BoxShape backgroundShape;

  const CustomSvgIconWithBackgroundWidget(
    this.iconPath, {
    Key? key,
    this.iconWidth = 16,
    this.iconHeight = 16,
    this.iconColor,
    this.iconAlignment = Alignment.center,
    this.iconFit = BoxFit.none,
    this.backgroundColor,
    this.width = 60.0,
    this.height = 60.0,
    this.backgroundShape = BoxShape.circle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: backgroundShape,
        // color: backgroundColor ?? AppColor.black200.withOpacity(0.3),
        color: backgroundColor ?? AppColor.white6,
      ),
      child: SvgPicture.asset(
        iconPath,
        color: iconColor,
        width: iconWidth,
        height: iconHeight,
        alignment: iconAlignment,
        fit: iconFit,
      ),
    );
  }
}
 */

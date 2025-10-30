import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart' show SvgPicture;

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppColorsTheme, StringIconChecker;
import 'custom_svg_cached.dart';

class CustomNetworkImageWidget extends StatefulWidget {
  final String imagePath;
  final double imageWidth;
  final double imageHeight;
  final BoxFit imageFit;
  final Widget? placeHolderWidget;

  const CustomNetworkImageWidget(
    this.imagePath, {
    Key? key,
    this.imageWidth = 16,
    this.imageHeight = 16,
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
    //print("DSCdc ${widget.imagePath.isUrl}");

    //print("DSCdc ${widget.imagePath.isSvgIcon}");
    //print("DSCdc ${widget.imagePath}");

    return widget.imagePath.isUrl
        ? widget.imagePath.isSvgIcon
            ? SvgNetwork(
                widget.imagePath,
                imageWidth: widget.imageWidth,
                imageHeight: widget.imageHeight,
                imageFit: widget.imageFit,
                placeHolderWidget: widget.placeHolderWidget,
              )
            : ImageNetwork(
                widget.imagePath,
                imageWidth: widget.imageWidth,
                imageHeight: widget.imageHeight,
                imageFit: widget.imageFit,
                placeHolderWidget: widget.placeHolderWidget,
              )
        : /*widget.placeHolderWidget ?? 
                Container(
                  color: AppColor.darkTurquoise,
                  width: widget.imageWidth,
                  height: widget.imageHeight,
                )*/
        SvgPicture.asset(
            IconPath.baladyLogo,
            width: widget.imageWidth,
            height: widget.imageHeight,
            fit: widget.imageFit,
          );
  }
}

class ImageNetwork extends StatelessWidget {
  final String imagePath;
  final double imageWidth;
  final double imageHeight;
  final BoxFit imageFit;
  final Widget? placeHolderWidget;

  const ImageNetwork(
    this.imagePath, {
    Key? key,
    this.imageWidth = 16,
    this.imageHeight = 16,
    this.imageFit = BoxFit.cover,
    this.placeHolderWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imagePath,
      width: imageWidth,
      height: imageHeight,
      fit: imageFit,
      headers: {"verifyingKEY": CommonFunctions.hashRequest(imagePath, "GET")},
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return PlaceHolderNetwork(
          placeHolderWidget: placeHolderWidget,
          imageWidth: imageWidth,
          imageHeight: imageHeight,
        );
      },
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        return PlaceHolderNetwork(
          placeHolderWidget: placeHolderWidget,
          imageWidth: imageWidth,
          imageHeight: imageHeight,
        );
      },
    );
  }
}

class SvgNetwork extends StatefulWidget {
  final String imagePath;
  final double imageWidth;
  final double imageHeight;
  final BoxFit imageFit;
  final Widget? placeHolderWidget;

  const SvgNetwork(
    this.imagePath, {
    Key? key,
    this.imageWidth = 16,
    this.imageHeight = 16,
    this.imageFit = BoxFit.cover,
    this.placeHolderWidget,
  }) : super(key: key);

  @override
  State<SvgNetwork> createState() => _SvgNetworkState();
}

class _SvgNetworkState extends State<SvgNetwork> {
/*  bool isSvg = true;

  @override
  void initState() {
    super.initState();
    loadPictures();
  }*/

  @override
  Widget build(BuildContext context) {
    //print("ffldmvldk ${widget.imagePath}");
    return /*isSvg
        ?*/
        CachedNetworkSvgImage(
      url: widget.imagePath,
      //  loadinggif: String.fromCharCodes(charCodes),
      width: widget.imageWidth,
      height: widget.imageHeight,
      fit: widget.imageFit,
      placeholderBuilder: (BuildContext context) {
        return PlaceHolderNetwork(
          placeHolderWidget: widget.placeHolderWidget,
          imageWidth: widget.imageWidth,
          imageHeight: widget.imageHeight,
        );
      },
    )
        /*: PlaceHolderNetwork(
            placeHolderWidget: widget.placeHolderWidget,
            imageWidth: widget.imageWidth,
            imageHeight: widget.imageHeight,
          )*/
        ;
  }

/*  Future<void> loadPictures() async {
    await precachePicture(
        NetworkPicture(SvgPicture.svgByteDecoderBuilder, widget.imagePath),
        context, onError: (object, t) {
      isSvg = false;
      setState(() {});
    });
  }*/
}

class PlaceHolderNetwork extends StatelessWidget {
  final double imageWidth;
  final double imageHeight;
  final Widget? placeHolderWidget;

  const PlaceHolderNetwork({
    Key? key,
    this.imageWidth = 16,
    this.imageHeight = 16,
    this.placeHolderWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return placeHolderWidget ??
        Container(
          color: AppColor.darkTurquoise,
          //   color: AppColorsTheme.primary700,
          width: imageWidth,
          height: imageHeight,
        );
  }
}

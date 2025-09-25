import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';

class MediaCatalogItem extends StatelessWidget {
  const MediaCatalogItem({
    required this.title,
    required this.subTitle,
    required this.image,
    required this.radioImage,
    required this.isSelected,
    super.key,
  });

  final String title;
  final String subTitle;
  final ImageProvider image;
  final ImageProvider radioImage;
  final bool isSelected;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: RadiusBorder.xs),
        child: Stack(
          children: [
            SizedBox(
              width: 104,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(RadiusBorder.m),
                          border: Border.all(color: Colors.white10),
                          image: DecorationImage(image: image, fit: BoxFit.cover),
                        ),
                      ),
                      if (isSelected)
                        Container(
                          width: 96,
                          height: 96,
                          decoration: ShapeDecoration(
                            gradient: LinearGradient(
                              begin: const Alignment(0.50, -0.00),
                              end: const Alignment(0.50, 1.00),
                              colors: [Colors.black.withValues(alpha: 0.60), Colors.black.withValues(alpha: 0.90)],
                            ),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white.withValues(alpha: 0.10)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),

                      if( isSelected)
                        Positioned(
                          top: 0,
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: Center(
                            child: SvgPicture.asset(
                              Assets.icons.svg.audio.waves.keyName,
                              width: 32,
                              height: 32,
                              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                            ),
                          ),
                        )

                    ],
                  ),
                  const SizedBox(height: Spacing.$2x),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        subTitle,
                        style: const TextStyle(fontSize: 12, color: Colors.white60),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 50,
              right: 0,
              child: Container(
                width: 45,
                height: 45,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(RadiusBorder.full),
                  border: Border.all(color: Colors.white10),
                  image: DecorationImage(image: radioImage, fit: BoxFit.contain),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 10)),
                    BoxShadow(color: Colors.black26, blurRadius: 36, offset: Offset(0, 12))
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}

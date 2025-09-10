import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';

class MediaCatalogItem extends StatelessWidget {
  const MediaCatalogItem({
    required this.title,
    required this.subTitle,
    required this.image,
    required this.radioImage,
    super.key,
  });

  final String title;
  final String subTitle;
  final ImageProvider image;
  final ImageProvider radioImage;

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
                  Container(
                    width: 96,
                    height: 96,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(RadiusBorder.m),
                      border: Border.all(
                        color: Colors.white10,
                      ),
                      image: DecorationImage(
                        image: image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: Spacing.$2x),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        subTitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white60,
                        ),
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
                    border: Border.all(
                      color: Colors.white10,
                    ),
                    image: DecorationImage(
                      image: radioImage,
                      fit: BoxFit.contain,
                    ),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 12,
                        offset: Offset(0, 10),
                      ),
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 36,
                        offset: Offset(0, 12),
                      )
                    ]),
              ),
            ),
          ],
        ),
      );
}

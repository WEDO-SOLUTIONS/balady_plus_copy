import 'dart:io';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FeedbackImages extends StatelessWidget {
  final List<XFile> images;
  final void Function() addImage;
  final void Function(int) removeImage;

  const FeedbackImages({
    super.key,
    required this.images,
    required this.addImage,
    required this.removeImage,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: Spacing.$2x),
                  child: Text(
                    'Images',
                    style: context.textStyle.caption,
                  ),
                ),
              ),
            ],
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Button(onTap: addImage),
              ...images.map(
                (img) => _ImageFeedback(
                  img: img,
                  onRemove: () => removeImage(
                    images.indexOf(img),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
}

class _Button extends StatelessWidget {
  final void Function() onTap;
  const _Button({
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Container(
          height: 62,
          width: 62,
          decoration: BoxDecoration(
            color: context.colorsV2.backgroundSurface1,
            borderRadius: BorderRadius.circular(RadiusBorder.l),
          ),
          // TODO: Add icon "Plus cicle"
          child: Center(
            child: Icon(
              GeneralIcons.circleNull,
              color: context.colorsV2.accentDefault,
              size: 24,
            ),
          ),
        ),
      );
}

class _ImageFeedback extends StatelessWidget {
  final XFile img;
  final VoidCallback onRemove;
  const _ImageFeedback({
    required this.img,
    required this.onRemove,
    super.key,
  });

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(RadiusBorder.l),
        child: SizedBox(
          width: 62,
          height: 62,
          child: Stack(
            children: [
              SizedBox(
                height: 62,
                width: 62,
                child: Image.file(
                  File(img.path),
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Text('This image type is not supported'),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              CupertinoButton(
                padding: const EdgeInsetsDirectional.fromSTEB(3, 3, 3, 8),
                onPressed: onRemove,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    height: 18,
                    width: 18,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(0, 0, 0, 0.6),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.close_rounded,
                        color: context.colorsV2.backgroundSurface1,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

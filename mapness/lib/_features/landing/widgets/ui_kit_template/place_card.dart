import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/widgets/smooth_radius.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/config/package_config.dart';

part 'gradient_placeholder.dart';

class PlaceCard extends StatelessWidget {
  const PlaceCard({
    required this.onTap,
    required this.title,
    required this.subtitle,
    required this.image,
    super.key,
  });

  final Function() onTap;
  final String title;
  final String subtitle;
  final String image;

  @override
  Widget build(BuildContext context) => Material(
        shape: smoothBorder(8),
        clipBehavior: Clip.antiAlias,
        color: Colors.transparent,
        child: Stack(
          children: [
            _GradientPlaceholder(
              child: SvgPicture.asset(
                'assets/icons/svg/place_card_placeholder.svg',
                package: PackageConfig.packageName,
                fit: BoxFit.cover,
                width: 163,
                height: 200,
                matchTextDirection: true,
              ),
            ),
            Positioned.fill(
              key: ValueKey(image),
              child: _GradientPlaceholder(
                child: Image(
                  image: NetworkImage(image),
                  fit: BoxFit.cover,
                  errorBuilder: (context, _, __) => const SizedBox.shrink(),
                ),
              ),
            ),
            Positioned.fill(
              child: InkWell(
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: context.textStyle.callout.copyWith(
                          color: context.color.textAndIconsBaseInversePrimary,
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      if (subtitle.isNotEmpty)
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.textStyle.footNote.copyWith(
                            color: context.color.surfaceBaseSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

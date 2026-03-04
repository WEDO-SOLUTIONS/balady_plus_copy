import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/src/layouts/size_constraint.dart';
import 'package:flutter/material.dart';

/// A [Stories] component for the [Landing Page] showcasing a selectable story tile.
///
/// A widget displaying a story tile with an optional image (network or asset),
/// title, and an indicator if the story has been watched. The widget supports
/// tap actions.
///
/// See also:
/// * [Figma Design](https://www.figma.com/file/owbsr9Pf0mQSEHXlbiPGOv/Balady-–-Components-Library?type=design&node-id=2641-4249&mode=design), design specs
class Stories extends StatelessWidget {
  const Stories({
    required this.onTap,
    this.title,
    this.networkImage,
    this.assetImage,
    this.isWatched = false,
    this.isLoading = false,
    super.key,
  }) : assert(
          assetImage != null || networkImage != null,
          'You must provide a network image or a asset image!',
        );

  final String? title;
  final String? networkImage;
  final String? assetImage;
  final VoidCallback onTap;
  final bool isWatched;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final _assetImage = assetImage;
    final _networkImage = networkImage;

    Widget frameBuilder(BuildContext context, Widget child, int? frame, __) =>
        isLoading || frame == null ? buildStoriesPlaceholder(context) : buildStoriesImage(context, child);

    Widget loadingBuilder(BuildContext context, Widget child, ImageChunkEvent? progress) =>
        progress == null ? child : buildStoriesPlaceholder(context);

    Widget errorBuilder(BuildContext context, Object error, StackTrace? stackTrace) => buildStoriesPlaceholder(context);

    return GestureDetector(
      onTap: onTap,
      child: _networkImage != null
          ? Image.network(
              _networkImage,
              height: SizeConstraints.storiesVertical,
              width: SizeConstraints.storiesHorizontal,
              fit: BoxFit.cover,
              frameBuilder: frameBuilder,
              loadingBuilder: loadingBuilder,
              errorBuilder: errorBuilder,
            )
          : _assetImage != null
              ? Image.asset(
                  _assetImage,
                  height: SizeConstraints.storiesVertical,
                  width: SizeConstraints.storiesHorizontal,
                  fit: BoxFit.cover,
                  frameBuilder: frameBuilder,
                  errorBuilder: errorBuilder,
                )
              : buildStoriesPlaceholder(context),
    );
  }

  Widget buildStoriesImage(BuildContext context, Widget child) {
    final core = _buildStoriesContainer(
      context,
      title: title,
      image: _buildImage(context, child),
    );

    // watched: без обводки
    if (isWatched) {
      return core;
    }

    final colors = context.colors;
    // Всегда рисуем рамку как градиент на основе accentSecondary из темы.
    final decoration = BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(RadiusBorder.xl)),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          colors.accentSecondaryDefault,
          colors.accentSecondarySoft,
        ],
      ),
    );

    return DecoratedBox(
      decoration: decoration,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: core,
      ),
    );
  }

  Widget buildStoriesPlaceholder(BuildContext context) {
    final core = _buildStoriesContainer(
      context,
      image: _buildImagePlaceholder(context),
    );

    final colors = context.colors;
    final decoration = BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(RadiusBorder.xl)),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          colors.accentSecondaryDefault,
          colors.accentSecondarySoft,
        ],
      ),
    );

    return DecoratedBox(
      decoration: decoration,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: core,
      ),
    );
  }

  Widget _buildStoriesContainer(
    BuildContext context, {
    required Widget image,
    String? title,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(RadiusBorder.xl),
        color: context.colors.backgroundSurface1,
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: SizedBox(
          height: SizeConstraints.storiesVertical,
          width: SizeConstraints.storiesHorizontal,
          child: Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(RadiusBorder.l),
                child: image,
              ),
              if (title != null && title.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(Spacing.$2x),
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5,
                    style: context.textStyles.captionSmallSemiBold.copyWith(
                      fontSize: 11,
                      color: context.colors.accentOnAccent,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context, Widget child) => ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (bounds) => LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0x00666666),
            Colors.black.withOpacity(0.7),
          ],
        ).createShader(bounds),
        child: child,
      );

  Widget _buildImagePlaceholder(BuildContext context, {Widget? child}) => SizedBox(
        height: SizeConstraints.storiesVertical,
        width: SizeConstraints.storiesHorizontal,
        child: ColoredBox(
          color: context.colors.backgroundSurface2,
          child: child,
        ),
      );
}

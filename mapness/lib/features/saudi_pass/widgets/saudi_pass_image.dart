import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/saudi_pass/providers/saudi_pass_repository_riverpod.dart';

class SaudiPassImage extends ConsumerWidget {
  final String imageId;

  final BoxFit imageFit;

  const SaudiPassImage({
    required this.imageId,
    this.imageFit = BoxFit.cover,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(saudiPassRepositoryProvider).valueOrNull;
    if (repository == null) {
      return const SizedBox.shrink();
    }

    final imageUri = repository.getPromotionsImagesUri(imageId: imageId);
    return GestureDetector(
      onTap: () => context.router.push(
          PhotoViewerRoute(photoPaths: [imageUri.url], currentPhotoIndex: 0)),
      child: CachedNetworkImage(
        imageUrl: imageUri.url,
        httpHeaders: imageUri.headers,
        fit: BoxFit.cover,
        errorWidget: (context, _, __) => const SizedBox.shrink(),
      ),
    );
  }
}

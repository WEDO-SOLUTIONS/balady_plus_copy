import 'package:flutter/material.dart';
import 'package:mapness/shared/ui/loading_image/loading_shimmer_image.dart';

class PhotosMutiview extends StatelessWidget {
  const PhotosMutiview({required this.photos, super.key});
  final List<String> photos;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (photos.length > 1) ...[
                Expanded(
                  flex: 137,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: LoadingShimmerImage(
                          imageUrl: photos[1],
                          fit: BoxFit.cover,
                        ),
                      ),
                      Center(
                        child: Text(
                          photos.length.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 1),
              ],
              if (photos.isNotEmpty)
                Expanded(
                  flex: 186,
                  child: LoadingShimmerImage(
                    imageUrl: photos.first,
                    fit: BoxFit.cover,
                  ),
                ),
            ],
          ),
        ),
      );
}

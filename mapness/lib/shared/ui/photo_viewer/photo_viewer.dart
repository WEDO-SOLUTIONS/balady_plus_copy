import 'package:balady_uikit/colors/non_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewer extends StatefulWidget {

  const PhotoViewer({
    required this.photoPaths,
    required this.currentPhotoIndex,
    super.key,
  });
  final List<String>? photoPaths;
  final int currentPhotoIndex;

  ///Using Navigator instead of Gorouter for prevent rebuild underlying page
  static Future<Object?> open(
    BuildContext context,
    int currentPhotoIndex,
    List<String> photoPaths,
  ) {
    final navigatorState = Navigator.of(context);
    return navigatorState.push(
      MaterialPageRoute(
        builder: (ctx) => PhotoViewer(
          currentPhotoIndex: currentPhotoIndex,
          photoPaths: photoPaths,
        ),
      ),
    );
  }

  @override
  State<PhotoViewer> createState() => _PhotoViewerState();
}

class _PhotoViewerState extends State<PhotoViewer> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.currentPhotoIndex);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: Material(
            color: Colors.white,
            child: Ink(
              color: Colors.white,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.close,
                    color: NonThemeColor.color58,
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (ctx, index) {
                final photo = widget.photoPaths![index];
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(photo),
                  initialScale: PhotoViewComputedScale.contained,
                  minScale:
                      PhotoViewComputedScale.contained * (0.5 + index / 10),
                  maxScale: PhotoViewComputedScale.covered * 4.1,
                  heroAttributes: PhotoViewHeroAttributes(tag: photo),
                );
              },
              itemCount: widget.photoPaths?.length ?? 0,
              backgroundDecoration: const BoxDecoration(color: Colors.white),
              pageController: pageController,
            ),
          ],
        ),
      );
}

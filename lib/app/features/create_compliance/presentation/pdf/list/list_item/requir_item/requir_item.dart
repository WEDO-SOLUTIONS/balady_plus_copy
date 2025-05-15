import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/pdf/core/image_path.dart';

class RequirementsItem extends StatelessWidget {
  final String desc;
  final String image;

  const RequirementsItem({super.key, required this.desc, required this.image});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(10),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(ImagePath.flag),
                  const SizedBox(
                    width: 4,
                  ),
                  Flexible(
                    child: Text(
                      desc,
                      style: const TextStyle(
                        color: Color(0xFF52525B),
                        fontSize: 14,
                        fontFamily: 'packages/balady_uikit/Frutiger',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                height: 191,
                decoration: BoxDecoration(
                  // image: DecorationImage(
                  //   image: AssetImage(
                  //     image,
                  //   ),
                  //   fit: BoxFit.fill,
                  // ),
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: const Alignment(-0.00, 1.00),
                    end: const Alignment(0, -1),
                    colors: [
                      const Color(0xFF050505),
                      Colors.black.withOpacity(0),
                    ],
                  ),
                ),
                child: CachedNetworkImage(
                  imageUrl: image,
                  width: double.maxFinite,
                  height: double.maxFinite,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                        // colorFilter: const ColorFilter.mode(
                        //   Colors.red,
                        //   BlendMode.colorBurn,
                        // ),
                      ),
                    ),
                  ),
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

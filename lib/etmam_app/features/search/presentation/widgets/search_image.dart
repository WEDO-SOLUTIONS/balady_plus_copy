import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show ImagePath;
import 'package:flutter/material.dart';

class SearchImage extends StatelessWidget {
  final String url;
  const SearchImage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      width: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: const Color(0xffe5e7eb), width: 0.5),
          boxShadow: const [
            BoxShadow(
                color: Color(0x14d1d5db),
                offset: Offset(-2, 4),
                blurRadius: 8,
                spreadRadius: 0)
          ]),
      child: url.isEmpty
          ? Image.asset(
              ImagePath.subService2,
              fit: BoxFit.fill,
            )
          : Image.network(
              url,
              fit: BoxFit.fill,
            ),
    );
  }
}

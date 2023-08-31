import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

final List<String> imgList = [
  ImagePath.swiperImage,
  ImagePath.swiperImage,
  ImagePath.swiperImage,
  ImagePath.swiperImage,
  ImagePath.swiperImage,
  ImagePath.swiperImage,
  ImagePath.swiperImage,
];
final List<String> imgList2 = [
  ImagePath.swiperImage2,
  ImagePath.swiperImage2,
  ImagePath.swiperImage2,
  ImagePath.swiperImage2,
  ImagePath.swiperImage2,
  ImagePath.swiperImage2,
  ImagePath.swiperImage2,
];

class EventImageSwiper extends StatefulWidget {
  EventImageSwiper({
    super.key,
  });

  @override
  State<EventImageSwiper> createState() => _EventImageSwiperState();
}

class _EventImageSwiperState extends State<EventImageSwiper> {
  final List<Widget> imageSliders = imgList
      .map((item) => Container(
            child: Image.asset(
              item,
              fit: BoxFit.fill,
            ),
          ))
      .toList();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          aspectRatio: 1.5,
          enlargeCenterPage: true,
        ),
        items: imageSliders,
      ),
    );
  }
}

class EventImageSwiper2 extends StatefulWidget {
  EventImageSwiper2({
    super.key,
  });

  @override
  State<EventImageSwiper2> createState() => _EventImageSwiper2State();
}

class _EventImageSwiper2State extends State<EventImageSwiper2> {
  final List<Widget> imageSliders2 = imgList2
      .map((item) => Container(
            child: Image.asset(
              item,
              fit: BoxFit.fill,
            ),
          ))
      .toList();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          aspectRatio: 1.5,
          enlargeCenterPage: true,
        ),
        items: imageSliders2,
      ),
    );
  }
}

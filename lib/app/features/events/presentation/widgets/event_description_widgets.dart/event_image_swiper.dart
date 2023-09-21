import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/events_bloc.dart';
import '../../bloc/events_state.dart';

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
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsBloc, EventsState>(builder: (context, state) {
      return SizedBox(
        height: 112,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: state.eventDetails.pictures?.length ?? 0,
          itemBuilder: (c, index) {
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                child: Container(
                  width: index == _currentIndex ? 122 : 90,
                  height: 100,
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        state.eventDetails.pictures?[index].url ?? "",
                      ),
                      fit: BoxFit.fill,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
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
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 112,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imgList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = index;
                });
              },
              child: Container(
                width: index == _currentIndex ? 122 : 90,
                height: 100,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      imgList[index],
                    ),
                    fit: BoxFit.fill,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

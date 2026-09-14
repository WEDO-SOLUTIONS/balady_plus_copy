import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/events_bloc.dart';
import '../../bloc/events_state.dart';

class EventImageSwiper extends StatefulWidget {
  final Function(String img) onChange;
  const EventImageSwiper({super.key, required this.onChange});

  @override
  State<EventImageSwiper> createState() => _EventImageSwiperState();
}

class _EventImageSwiperState extends State<EventImageSwiper> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsBloc, EventsState>(
      builder: (context, state) {
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
                    widget.onChange(state.eventDetails.pictures![index].url!);
                  },
                  child: Container(
                    width: index == _currentIndex ? 122 : 90,
                    height: 100,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: NetworkImage(state.eventDetails.pictures?[index].url ?? ""),
                        fit: BoxFit.fill,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

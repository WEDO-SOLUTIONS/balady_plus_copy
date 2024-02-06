import 'package:equatable/equatable.dart';

import 'item.dart';

class EventsDetails extends Equatable {

  final List<Item>? items;

  const EventsDetails({this.items});

  factory EventsDetails.fromJson(Map<String, dynamic> json) => EventsDetails(

        items: (json['items'] as List<dynamic>?)
            ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'items': items?.map((e) => e.toJson()).toList(),
      };

  @override
  List<Object?> get props => [items];
}

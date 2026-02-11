import 'package:balady_plus/app/features/notifications/data/model/notifications_list/notifications_message_item.dart';
import 'package:equatable/equatable.dart';

class NotificationsListResponse extends Equatable {
  final int totalItemsCount;

  // final int? pageSize;
  final int totalPageCount;
  final List<NotificationsMessageItem> listMessages;

  const NotificationsListResponse({
    required this.totalItemsCount,
    // this.pageSize,
    required this.totalPageCount,
    required this.listMessages,
  });

  factory NotificationsListResponse.fromJson(Map<String, dynamic> json) =>
      NotificationsListResponse(
        totalItemsCount: json['totalItemsCount'] ?? 0,
        // pageSize: json['pageSize'] as int?,
        totalPageCount: json['totalPagesCount'] ?? 0,
        listMessages: json['items'] != null
            ? (json['items'] as List<dynamic>)
                .map((e) => NotificationsMessageItem.fromJson(
                    e as Map<String, dynamic>))
                .toList()
            : [],
      );

  Map<String, dynamic> toJson() => {
        'totalItemsCount': totalItemsCount,
        // 'pageSize': pageSize,
        'totalPages': totalPageCount,
        'calendarEvents': listMessages.map((e) => e.toJson()).toList(),
      };

  @override
  List<Object?> get props {
    return [
      totalItemsCount,
      // pageSize,
      totalPageCount,
      listMessages,
    ];
  }
}

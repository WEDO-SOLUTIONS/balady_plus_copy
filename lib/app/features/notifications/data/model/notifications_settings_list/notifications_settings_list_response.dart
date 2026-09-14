import 'actor_context.dart';
import 'category.dart';
import 'channel.dart';

class NotificationsSettingsList {
  final String? id;
  final ActorContext? actorContext;
  final Channel? channel;
  final bool? enabled;
  final List<Category>? categories;

  const NotificationsSettingsList({this.id, this.actorContext, this.channel, this.enabled, this.categories});

  factory NotificationsSettingsList.fromJson(Map<String, dynamic> json) => NotificationsSettingsList(
    id: json['id'] as String?,
    actorContext: json['actorContext'] == null
        ? null
        : ActorContext.fromJson(json['actorContext'] as Map<String, dynamic>),
    channel: json['channel'] == null ? null : Channel.fromJson(json['channel'] as Map<String, dynamic>),
    enabled: json['enabled'] as bool?,
    categories: (json['categories'] as List<dynamic>?)
        ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'actorContext': actorContext?.toJson(),
    'channel': channel?.toJson(),
    'enabled': enabled,
    'categories': categories?.map((e) => e.toJson()).toList(),
  };

  List<Object?> get props {
    return [id, actorContext, channel, enabled, categories];
  }
}

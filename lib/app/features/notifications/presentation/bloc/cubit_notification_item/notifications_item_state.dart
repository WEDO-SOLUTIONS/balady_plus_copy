part of 'notifications_item_cubit.dart';

class SucceedMessageState extends Equatable {
  final NotificationsMessageItem message;

  const SucceedMessageState({required this.message});

  @override
  List<Object?> get props => [message];
}

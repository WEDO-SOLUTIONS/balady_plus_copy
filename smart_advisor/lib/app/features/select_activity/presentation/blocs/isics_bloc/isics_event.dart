import 'package:equatable/equatable.dart';

abstract class IsicsEvent extends Equatable {
  const IsicsEvent();

  @override
  List<Object?> get props => [];
}

class GetIsicsEvent extends IsicsEvent {
  const GetIsicsEvent();
}

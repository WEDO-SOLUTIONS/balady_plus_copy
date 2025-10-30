import 'package:equatable/equatable.dart';

abstract class RubricsEvent extends Equatable {
  const RubricsEvent();

  @override
  List<Object?> get props => [];
}

class GetRubricsEvent extends RubricsEvent {
  const GetRubricsEvent();
}

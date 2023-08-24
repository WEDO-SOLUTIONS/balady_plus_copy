import 'package:equatable/equatable.dart';

class ViolationEvent extends Equatable {
  const ViolationEvent();

  @override
  List<Object> get props => [];
}

class CategorySelectedEvent extends ViolationEvent {
  final int index;
  const CategorySelectedEvent(this.index);
}

import 'package:equatable/equatable.dart';

class RadioItem extends Equatable {
  RadioItem({required this.radioValue, required this.id});

  String radioValue;
  int id;

  @override
  List<Object?> get props => [radioValue, id];
}

import 'package:equatable/equatable.dart';

class RadioItem<T> extends Equatable {
  RadioItem({required this.radioValue, required this.radioText});

  T radioValue;
  String radioText;

  @override
  List<Object?> get props => [radioValue, radioText];
}

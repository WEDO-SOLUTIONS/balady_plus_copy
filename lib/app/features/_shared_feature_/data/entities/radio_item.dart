import 'package:equatable/equatable.dart';

class RadioItem<T> extends Equatable {
  const RadioItem({required this.radioValue, required this.radioText});

  final T radioValue;
  final String radioText;

  @override
  List<Object?> get props => [radioValue, radioText];
}

import 'package:equatable/equatable.dart';

class ConditionsUrlsEntity extends Equatable {
  final String boardsUrl;
  final String baladyConditionsUrl;

  const ConditionsUrlsEntity({
    required this.boardsUrl,
    required this.baladyConditionsUrl,
  });

  @override
  List<Object?> get props => [
        boardsUrl,
        baladyConditionsUrl,
      ];
}

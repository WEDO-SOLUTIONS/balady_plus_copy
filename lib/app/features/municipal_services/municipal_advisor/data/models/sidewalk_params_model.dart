import 'package:equatable/equatable.dart';

class SideWalkParamsModel extends Equatable {
  final num length;
  final num width;
  final int days;

  const SideWalkParamsModel({
    required this.length,
    required this.width,
    required this.days,
  });

  Map<String, dynamic> toMap() {
    return {
      'length': length,
      'width': width,
      'days': days,
    };
  }

  SideWalkParamsModel copyWith({
    num? length,
    num? width,
    int? days,
  }) {
    return SideWalkParamsModel(
      length: length ?? this.length,
      width: width ?? this.width,
      days: days ?? this.days,
    );
  }

  @override
  List<Object?> get props => [
        length,
        width,
        days,
      ];
}

import 'age.dart';

class Biometrics {
  dynamic height;
  dynamic weight;
  Age? age;

  Biometrics({this.height, this.weight, this.age});

  factory Biometrics.fromJson(Map<String, dynamic> json) => Biometrics(
        height: json['height'] as dynamic,
        weight: json['weight'] as dynamic,
        age: json['age'] == null
            ? null
            : Age.fromJson(json['age'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'height': height,
        'weight': weight,
        'age': age?.toJson(),
      };
}

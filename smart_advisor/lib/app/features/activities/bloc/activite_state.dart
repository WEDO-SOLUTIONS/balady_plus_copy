import 'package:equatable/equatable.dart';
import '/app/features/_shared_feature_/presentation/models/activite_model.dart';

class ActiviteState extends Equatable {
  List<ActiviteModel> activiteList;
  List<ActiviteModel> popularList;
  List<ActiviteModel> normalList;

  ActiviteState(
      {required this.activiteList,
      required this.normalList,
      required this.popularList});
  @override
  List<Object?> get props => [activiteList, popularList, normalList];

  ActiviteState copyWith({
    List<ActiviteModel>? activiteList,
    List<ActiviteModel>? popularList,
    List<ActiviteModel>? normalList,
  }) {
    return ActiviteState(
      activiteList: activiteList ?? this.activiteList,
      popularList: popularList ?? this.popularList,
      normalList: normalList ?? this.normalList,
    );
  }
}

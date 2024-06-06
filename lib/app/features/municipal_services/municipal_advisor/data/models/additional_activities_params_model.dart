import 'package:equatable/equatable.dart';

class AdditionalActivitiesParamsModel extends Equatable {
  final String consultationKey;
  final List<(int, double?)> ids;
  final bool? hasSalamaPermit;
  final num?  mainActivityArea;
  final num? shopArea;

  const AdditionalActivitiesParamsModel(
      {required this.consultationKey, required this.ids, this.hasSalamaPermit,this.mainActivityArea,this.shopArea});

  @override
  List<Object?> get props => [consultationKey, ids, hasSalamaPermit,mainActivityArea,shopArea];
}

import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/self_rating_item.dart';

class SelfRatingState extends Equatable {
  final BlocStatus status;
  final double currentStep;
  final String? errorMessage;
  final List<SelfRatingItem>? items;

  const SelfRatingState(
      {this.status = BlocStatus.initial,
      required this.currentStep,
      this.errorMessage,
      this.items});

  SelfRatingState copyWith(
      {final BlocStatus? status,
      final double? currentStep,
      final String? errorMessage,
      final List<SelfRatingItem>? items}) {
    return SelfRatingState(
        currentStep: currentStep ?? this.currentStep,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        items: items ?? this.items);
  }

  int get totalViolation =>
      items?.where((element) => element.compliance == false).length ?? 0;
  int get totalCompliance =>
      items?.where((element) => element.compliance == true).length ?? 0;
  List<SelfRatingItem> get complianes =>
      items?.where((element) => element.compliance == false).toList() ?? [];
  String get percentage =>
      ((totalCompliance / items!.length) * 100).toStringAsFixed(1);
  @override
  List<Object?> get props => [
        status,
        currentStep,
        items,
      ];
}

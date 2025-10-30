// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../../core/utils/enums/enums.dart';

class ServiceCardEntity extends Equatable {
  final String title;
  final String iconName;
  final String description;
  final String? descriptionLink;

  final ServiceCardsTypes? type;
  final num rate;
  final String duration;
  final int? fees;
  final String? feesName;
  final String? feesLink;
  final List<String>? requirements;
  final List<ServiceCardFlow>? flow;

  const ServiceCardEntity(
      {required this.title,
      required this.iconName,
      required this.description,
      required this.rate,
      required this.duration,
      this.fees,
      this.descriptionLink,
      this.feesName,
      this.feesLink,
      this.type,
      this.requirements,
      this.flow});

  @override
  List<Object?> get props => [
        title,
        iconName,
        description,
        rate,
        duration,
        descriptionLink,
        fees,
        type,
        requirements,
        flow
      ];
}

class ServiceCardFlow {
  String? title;
  List<String>? steps;
  ServiceCardFlow({
    this.title,
    this.steps,
  });

  factory ServiceCardFlow.fromMap(Map<String, dynamic> map) {
    return ServiceCardFlow(
      title: map['title'] != null ? map['title'] as String : null,
      steps: map['steps'] != null
          ? List<String>.from((map['steps'] as List<String>))
          : null,
    );
  }
}

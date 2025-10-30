import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/models/commercial_debts_model.dart';
import 'package:equatable/equatable.dart';

class CommercialListDebt extends Equatable {
  // final int totalItemsCount;

  // final int? pageSize;
  final int totalPageCount;
  final List<Debt> listMessages;

  const CommercialListDebt({
    // required this.totalItemsCount,
    // this.pageSize,
    required this.totalPageCount,
    required this.listMessages,
  });

  factory CommercialListDebt.fromJson(Map<String, dynamic> json) =>
      CommercialListDebt(
        // totalItemsCount: json['totalItemsCount'] ?? 0,
        // pageSize: json['pageSize'] as int?,
        totalPageCount: json['pageSize'],
        listMessages: json['debts'] != null
            ? (json['debts'] as List<dynamic>)
                .map((e) => Debt.fromJson(e as Map<String, dynamic>))
                .toList()
            : [],
      );

  @override
  List<Object?> get props {
    return [
      // totalItemsCount,
      // pageSize,
      totalPageCount,
      listMessages,
    ];
  }
}

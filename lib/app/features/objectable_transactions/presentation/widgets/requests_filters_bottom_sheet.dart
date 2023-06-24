import 'package:balady_plus/app/features/objectable_transactions/presentation/widgets/filters/request_date_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../objections_exports.dart'
    show
        ObjectableTransactionBloc,
        RequestsProductFilter,
        RequestsStatusFilter,
        RequestsTypeFilter;

class RequestsFilterBottomSheet extends StatelessWidget {
  final ObjectableTransactionBloc requestsBloc;

  const RequestsFilterBottomSheet({
    super.key,
    required this.requestsBloc,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: requestsBloc,
      child: SizedBox(
        width: double.infinity,
        child: Builder(builder: (context) {
          return const Column(
            children: [
              RequestsProductFilter(),
              RequestsTypeFilter(),
              RequestsDateFilter(),
              SizedBox(height: 16),
            ],
          );
        }),
      ),
    );
  }
}

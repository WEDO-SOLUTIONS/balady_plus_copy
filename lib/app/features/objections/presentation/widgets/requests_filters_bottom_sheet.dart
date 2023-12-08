import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../objections_exports.dart'
    show
        ObjectionsBloc,
        RequestsProductFilter,
        RequestsStatusFilter,
        RequestsTypeFilter;

class RequestsFilterBottomSheet extends StatelessWidget {
  final ObjectionsBloc requestsBloc;

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
            mainAxisSize: MainAxisSize.min,
            children: [
              RequestsProductFilter(),
              RequestsTypeFilter(),
              RequestsStatusFilter(),
              SizedBox(height: 16),
            ],
          );
        }),
      ),
    );
  }
}

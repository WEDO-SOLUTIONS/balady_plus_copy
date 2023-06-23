import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../requests_exports.dart'
    show
        RequestsBloc,
        RequestsDateFilter,
        RequestsMunicipalityFilter,
        RequestsProductFilter,
        RequestsSortFilter,
        RequestsStatusFilter,
        RequestsSubMunicipalityFilter,
        RequestsTypeFilter;

class RequestsFilterBottomSheet extends StatelessWidget {
  final RequestsBloc requestsBloc;

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
              RequestsStatusFilter(),
              RequestsMunicipalityFilter(),
              RequestsSubMunicipalityFilter(),
              RequestsSortFilter(),
              SizedBox(height: 16),
            ],
          );
        }),
      ),
    );
  }
}

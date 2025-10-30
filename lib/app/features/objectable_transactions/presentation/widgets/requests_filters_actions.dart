import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../_shared_feature_/shared_feature_exports.dart'
    show ElevatedButtonWidget;
import '../../objections_exports.dart'
    show
        ApplyRequestsFiltersEvent,
        ClearRequestsFiltersEvent,
        ObjectableTransactionBloc;

class RequestsFilterActions extends StatelessWidget {
  final ObjectableTransactionBloc requestsBloc;

  const RequestsFilterActions({
    super.key,
    required this.requestsBloc,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: requestsBloc,
      child: Builder(builder: (context) {
        return Column(
          children: [
            ElevatedButtonWidget.apply(
              onPressed: () {
                context.read<ObjectableTransactionBloc>().add(
                      ApplyRequestsFiltersEvent(),
                    );
                Navigator.pop(context, true);
              },
            ),
            const SizedBox(height: 16),
            ElevatedButtonWidget.deletaAll(
              onPressed: () {
                context.read<ObjectableTransactionBloc>().add(
                      ClearRequestsFiltersEvent(),
                    );
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      }),
    );
  }
}

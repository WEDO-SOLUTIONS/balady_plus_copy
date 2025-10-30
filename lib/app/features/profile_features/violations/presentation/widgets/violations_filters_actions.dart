import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../_shared_feature_/shared_feature_exports.dart'
    show ElevatedButtonWidget;
import '../../violations_exports.dart'
    show
        ApplyViolationsFiltersEvent,
        ClearViolationsFiltersEvent,
        ViolationsBloc;

class ViolationsFilterActions extends StatelessWidget {
  final ViolationsBloc requestsBloc;

  const ViolationsFilterActions({
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
                context.read<ViolationsBloc>().add(
                      ApplyViolationsFiltersEvent(),
                    );
                Navigator.pop(context, true);
              },
            ),
            const SizedBox(height: 16),
            ElevatedButtonWidget.deletaAll(
              onPressed: () {
                context.read<ViolationsBloc>().add(
                      ClearViolationsFiltersEvent(),
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

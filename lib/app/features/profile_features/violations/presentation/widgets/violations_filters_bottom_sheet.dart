import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../violations_exports.dart'
    show
        InvoiceStatusFilter,
        ObjectionLastApplyDateFilter,
        SearchWithLicenseNumberEvent,
        SearchWithViolationNumberEvent,
        ViolationIssueDateDateFilter,
        ViolationsBloc,
        ViolationsSortFilter,
        ViolationsState,
        ViolationsStatusesFilter;

class ViolationsFilterBottomSheet extends StatelessWidget {
  final ViolationsBloc requestsBloc;

  const ViolationsFilterBottomSheet({
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
          return BlocBuilder<ViolationsBloc, ViolationsState>(
            builder: (context, state) {
              return Column(
                children: [
                  FilterTextField(
                    hintText: "transaction_details_license".tr(),
                    initialValue: state.licenseNumberQuery,
                    onChanged: (value) {
                      context.read<ViolationsBloc>().add(
                            SearchWithLicenseNumberEvent(
                              query: value,
                            ),
                          );
                    },
                  ),
                  FilterTextField(
                    hintText: "billNumber".tr(),
                    initialValue: state.invoiceNumberQuery,
                    onChanged: (value) {
                      context.read<ViolationsBloc>().add(
                            SearchWithViolationNumberEvent(
                              query: value,
                            ),
                          );
                    },
                  ),
                  const ViolationsStatusesFilter(),
                  const InvoiceStatusFilter(),
                  const ObjectionLastApplyDateFilter(),
                  const ViolationIssueDateDateFilter(),
                  const ViolationsSortFilter(),
                  const SizedBox(height: 16),
                ],
              );
            },
          );
        }),
      ),
    );
  }
}

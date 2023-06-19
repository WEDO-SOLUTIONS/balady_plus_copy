import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import '../../../../../core/utils/utils_exports.dart'
    show AppColor, BlocRequestStatus, IconPath;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show DefaultAppBarWidget, MessageDialog;
import '../../../../home_page/home_exports.dart' show CircleIcon;
import '../../../requests/requests_exports.dart' show AppBarSeachBar;
import '../../licenses_exports.dart'
    show
        GetLicensesEvent,
        LicensesBloc,
        LicensesListItem,
        LicensesListShimmer,
        LicensesState,
        SearchLicensesEvent;

class LicensesPage extends StatelessWidget {
  const LicensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LicensesBloc>(
      create: (context) => sl<LicensesBloc>()..add(GetLicensesEvent()),
      child: Scaffold(
        appBar: DefaultAppBarWidget(
          title: 'licenses'.tr(),
          bottom: AppBarSeachBar(
            onChanged: (value) {
              context.read<LicensesBloc>().add(
                    SearchLicensesEvent(
                      query: value,
                    ),
                  );
            },
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: CircleIcon(
                backgroundColor: AppColor.primary50Light,
                icon: IconPath.filter,
                circleSize: 48.0,
                iconSize: 30.0,
              ),
            ),
          ],
        ),
        body: Builder(
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: BlocConsumer<LicensesBloc, LicensesState>(
                listener: (_, state) async {
                  switch (state.requestsStatus) {
                    case BlocRequestStatus.submissionGetFailure:
                      MessageDialog.showErrorNotification(msg: state.error);
                      break;
                    default:
                      break;
                  }
                },
                builder: (context, state) {
                  switch (state.requestsStatus) {
                    case BlocRequestStatus.submissionGetLoading:
                      return const LicensesListShimmer();
                    case BlocRequestStatus.submissionGetSuccess:
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.requests.length,
                        itemBuilder: (context, index) {
                          return LicensesListItem(
                            request: state.requests[index],
                          );
                        },
                      );
                    default:
                      return const SizedBox.shrink();
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

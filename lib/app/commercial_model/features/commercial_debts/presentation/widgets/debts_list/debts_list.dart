import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/bloc/commercial_list_debts/commercial_list_debts_cubit.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/bloc/commercial_list_debts/commercial_list_debts_state.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/widgets/debts_list/debts_list_item.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class DebtsList extends StatelessWidget {
  const DebtsList({super.key});

  @override
  Widget build(BuildContext context) {
    CommercialListDebtsCubit cubit = context.watch<CommercialListDebtsCubit>();
    return BlocBuilder<CommercialListDebtsCubit, ListDebtsState>(
      bloc: cubit,
      builder: (_, state) {
        if (state is LoadingListDebtState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is NoListDebtsDebtState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(IconPath.noEvents),
                const SizedBox(height: 10),
                Text('no_debts'.tr())
              ],
            ),
          );
        }

        if (state is FieldListDebtState) {
          return ReloadWidget(
            onTab: () => cubit.getListDebts(
              pageNumber: state.pageNumber,
            ),
          );
        }

        /////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////
        // View Loading In after list item in list
        if (state is SucceedWithPaginationListDebtState) {
          ScrollController scrollController = ScrollController();
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return index == state.listDebts.length
                  ? const Center(child: CircularProgressIndicator())
                  : DebtsListItem(debt: state.listDebts[index]);
            },
            controller: scrollController
              ..addListener(
                () {
                  if (scrollController.position.pixels ==
                      scrollController.position.maxScrollExtent) {
                    cubit.getListDebts(pageNumber: state.page);
                  }
                },
              ),
            itemCount: state.listDebts.length + 1,
          );
        }
        if (state is SuccessListDebtState) {
          return ListView.builder(
            padding: const EdgeInsets.all(12.0),
            itemBuilder: (BuildContext context, int index) {
              return DebtsListItem(debt: state.listDebts[index]);
            },
            itemCount: state.listDebts.length,
          );
        }

        return const SizedBox();
      },
    );
  }
}

/*import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';



class EstablishmentDropDown extends StatelessWidget {
  const MallsDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CrStep4ShopDataCubit, CrStep4ShopDataState>(
        builder: (context, state) {
      return DropDownWithTitle(
        title: "المركز التجاري".tr(),
        selectedValue: state.selectedMall?.name,
        blocStatus: state.mallsStatus,
        onRetry: () {
          context.read<CrStep4ShopDataCubit>().getMalls();
        },
        onTap: () {
          // if (state.requestDetails?.usageDisable == true) return;
          
        },
      );
    });
  }
}
*/

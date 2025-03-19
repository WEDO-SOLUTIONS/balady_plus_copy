import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:smart_advisor/app/features/_shared_feature_/presentation/widgets/custom_widgets/customTextField.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/blocs/main_flow_bloc/main_flow_bloc.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/widgets/option_license_card.dart';

import '../../../../../core/utils/enums/bloc_status.dart';
import '../../widgets/delegator_card.dart';

class CommercialRegisterPageUser extends StatefulWidget {
  const CommercialRegisterPageUser({super.key});

  @override
  State<CommercialRegisterPageUser> createState() =>
      _CommercialRegisterPageUserState();
}

class _CommercialRegisterPageUserState
    extends State<CommercialRegisterPageUser> {
  int _selectedIndex = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    int index = context.read<ManageMainFlowBloc>().state.delegators?.indexWhere(
            (e) =>
                e.id ==
                context
                    .read<ManageMainFlowBloc>()
                    .state
                    .selectedDelegator
                    ?.id) ??
        -1;

    _selectedIndex = index;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageMainFlowBloc, ManageMainFlowState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(top: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "ما السجل التجاري الذي ترغب في إدارته؟",
                            style: AppStyle.somarSemiBold
                                .copyWith(color: AppColor.textPrimaryColor),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            'تعرض القائمة السجلات التجارية التي تملكها او مفوض او مدير عليها ',
                            style: AppStyle.textRegularStyle
                                .copyWith(color: AppColor.textSecondaryColor),
                          ),
                          /* const SizedBox(
                            height: 16,
                          ),
                          // Search
                          Textfield(
                            onChanged: (String? t) {},
                          ),*/
                          const SizedBox(
                            height: 16,
                          ),
                          MediaQuery.removePadding(
                            removeTop: true,
                            context: context,
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: state.delegators?.length ?? 0,
                              itemBuilder: (context, index) {
                                return DelegatorCard(
                                    isCommercialRegister: false,
                                    data: LicenseCardModel(
                                      idNumber:
                                          state.delegators?[index].id ?? "",
                                      status:
                                          state.delegators?[index].roleName ??
                                              "",
                                      isAcitve: false,
                                      title:
                                          state.delegators?[index].entityName ??
                                              "",
                                      branchName: "",
                                      city: "",
                                      date: "",
                                    ),
                                    isSelected: _selectedIndex == index,
                                    onTap: () {
                                      context.read<ManageMainFlowBloc>().add(
                                          SelectDelegatorEvent(
                                              delegator:
                                                  state.delegators![index]));
                                      setState(() {
                                        _selectedIndex = index;
                                      });
                                    });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (state.delegatorsStatus == BlocStatus.loading)
                    Center(
                      child: CircularProgressIndicator(
                        color: AppColor.statusAccentColor,
                      ),
                    ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

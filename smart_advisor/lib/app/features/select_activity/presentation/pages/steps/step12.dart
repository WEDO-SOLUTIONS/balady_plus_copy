import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:smart_advisor/app/features/select_activity/presentation/blocs/main_flow_bloc/main_flow_bloc.dart';

class Step12page extends StatefulWidget {
  const Step12page({super.key});

  @override
  State<Step12page> createState() => _Step12pageState();
}

class _Step12pageState extends State<Step12page> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainFlowBloc, MainFlowState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(
            right: 16.0,
            left: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'هل لديك حق انتفاع؟',
                    textAlign: TextAlign.center,
                    style: AppStyle.somarSemiBold
                        .copyWith(color: AppColor.textPrimaryColor),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'سيساعدنا هذا في تقديم إرشادات مصممة خصيصًا لك',
                    textAlign: TextAlign.center,
                    style: AppStyle.textRegularStyle
                        .copyWith(color: AppColor.textSecondaryColor),
                  ),
                  const SizedBox(height: 24),
                  ContractType(
                      isSelected: state.contractType == "EJAR",
                      title: "إيجار",
                      onSelect: () {
                        context.read<MainFlowBloc>().add(
                            const ChangeValuesEvent(
                                contractType: "EJAR", contractOption: ""));
                      },
                      contractOption: state.contractOption,
                      onContractOptionSelect: (String type) {
                        context
                            .read<MainFlowBloc>()
                            .add(ChangeValuesEvent(contractOption: type));
                      }),
                  const SizedBox(height: 16),
                  ContractType(
                      isSelected: state.contractType == "INVEST",
                      title: "استثمار",
                      onSelect: () {
                        context.read<MainFlowBloc>().add(
                            const ChangeValuesEvent(
                                contractType: "INVEST", contractOption: ""));
                      },
                      contractOption: state.contractOption,
                      onContractOptionSelect: (String type) {
                        context
                            .read<MainFlowBloc>()
                            .add(ChangeValuesEvent(contractOption: type));
                      }),
                  const SizedBox(height: 16),
                  ContractType(
                      isSelected: state.contractType == "DEED",
                      title: "صك ملكية",
                      onSelect: () {
                        context.read<MainFlowBloc>().add(
                            const ChangeValuesEvent(
                                contractType: "DEED", contractOption: ""));
                      },
                      contractOption: state.contractOption,
                      onContractOptionSelect: (String type) {
                        context
                            .read<MainFlowBloc>()
                            .add(ChangeValuesEvent(contractOption: type));
                      }),
                  const SizedBox(height: 16),
                  ContractType(
                      isSelected: state.contractType == "Undefined",
                      title: "غير محدد",
                      onSelect: () {
                        context.read<MainFlowBloc>().add(
                            const ChangeValuesEvent(
                                contractType: "Undefined",
                                contractOption: "Undefined"));
                      },
                      contractOption: state.contractOption,
                      onContractOptionSelect: (String type) {
                        context
                            .read<MainFlowBloc>()
                            .add(ChangeValuesEvent(contractOption: type));
                      }),
                  const SizedBox(height: 16),
                ]),
          ),
        );
      },
    );
  }
}

class ContractType extends StatefulWidget {
  final Function onSelect;
  final Function(String t) onContractOptionSelect;
  final bool isSelected;
  final String title;
  final String? contractOption;
  const ContractType(
      {super.key,
      required this.onSelect,
      required this.isSelected,
      required this.onContractOptionSelect,
      required this.title,
      this.contractOption});

  @override
  State<ContractType> createState() => _ContractTypeState();
}

class _ContractTypeState extends State<ContractType> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OptionButton(
          text: widget.title,
          isSelected: widget.isSelected,
          onTap: () => widget.onSelect(),
        ),
        SizedBox(
          height: 8,
        ),
        if (widget.isSelected == true && widget.contractOption != "Undefined")
          ContractOption(
            onSelect: widget.onContractOptionSelect,
            contractOption: widget.contractOption,
            title: "نوع عقد ال${widget.title}",
          )
      ],
    );
  }
}

class ContractOption extends StatelessWidget {
  final String title;
  final Function(String text) onSelect;
  final String? contractOption;

  const ContractOption(
      {super.key,
      required this.onSelect,
      required this.title,
      this.contractOption});

  @override
  Widget build(BuildContext context) {
    print(contractOption);
    print(contractOption);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: TextAlign.right,
          style: AppStyle.somarSemiBold
              .copyWith(color: AppColor.textPrimaryColor, fontSize: 16),
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: OptionButton(
                text: "عقد ورقي",
                isSelected: contractOption == "ATTACH",
                onTap: () {
                  onSelect("ATTACH");
                },
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: OptionButton(
                text: "عقد إلكتروني",
                isSelected: contractOption == "SERVICE",
                onTap: () {
                  onSelect("SERVICE");
                },
              ),
            )
          ],
        )
      ],
    );
  }
}

class OptionButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionButton({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: Border.all(
              color: isSelected ? AppColor.primary : Colors.transparent),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FittedBox(
                fit: BoxFit.fill,
                child: Container(
                  height: 22,
                  width: 22,
                  child: SvgPicture.asset(
                    isSelected
                        ? 'packages/smart_advisor/smart_advisor_assets/icons/svg/Radio.svg'
                        : 'packages/smart_advisor/smart_advisor_assets/icons/svg/Radionotselected.svg',
                    height: 22,
                    width: 22,
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Text(
                text,
                style: AppStyle.textRegularRomanStyle
                    .copyWith(color: AppColor.textPrimaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

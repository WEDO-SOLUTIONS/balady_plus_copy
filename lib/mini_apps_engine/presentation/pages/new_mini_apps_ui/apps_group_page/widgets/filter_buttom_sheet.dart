import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class FilterButtomSheet extends StatefulWidget {
  final FilterOptionType? initialSelectedType;

  const FilterButtomSheet({super.key, this.initialSelectedType});

  static Future<FilterOptionType?> show(BuildContext context, {FilterOptionType? initialSelectedType}) async {
    return await showModalBottomSheet<FilterOptionType>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => FilterButtomSheet(initialSelectedType: initialSelectedType),
    );
  }

  @override
  State<FilterButtomSheet> createState() => _FilterButtomSheetState();
}

class _FilterButtomSheetState extends State<FilterButtomSheet> {
  late FilterOptionType? selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.initialSelectedType ?? FilterOptionType.serviceDateAscending;
  }

  List<FilterOptionModel> filterOptions = [
    FilterOptionModel(
      translationKey: 'alphabetical_ascending',
      type: FilterOptionType.alphabeticalAscending,
      isEnabled: true,
    ),
    FilterOptionModel(
      translationKey: 'alphabetical_descending',
      type: FilterOptionType.alphabeticalDescending,
      isEnabled: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with close button and title
              Center(
                child: SizedBox(
                  height: context.screenHeight * 0.006,
                  width: context.w(36),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSurface.withAlpha(13),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              SizedBox(height: context.screenHeight * 0.02),
              Center(
                child: Text(
                  'sort_by'.tr(),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: GeneralKey.appFontType,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    height: 1.0,
                    letterSpacing: 0,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              ...filterOptions.map((option) {
                final isDisabled = !option.isEnabled;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: InkWell(
                    onTap: isDisabled
                        ? null
                        : () {
                            setState(() {
                              selectedOption = option.type;
                            });
                          },
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: isDisabled
                              ? null
                              : () {
                                  setState(() {
                                    selectedOption = option.type;
                                  });
                                },
                          child: Container(
                            width: context.w(22),
                            height: context.h(22),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDisabled
                                  ? Colors.transparent
                                  : (selectedOption == option.type ? Colors.white : Colors.transparent),
                              border: Border.all(
                                color: isDisabled
                                    ? Colors.black
                                    : (selectedOption == option.type
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context).colorScheme.onSurface),
                                width: 1,
                              ),
                            ),
                            child: selectedOption == option.type && !isDisabled
                                ? Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                        SizedBox(width: context.screenWidth * 0.03),
                        Expanded(
                          child: Text(
                            option.translationKey.tr(),
                            style: TextStyle(
                              fontFamily: GeneralKey.appFontType,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              height: 20 / 16,
                              letterSpacing: 0,
                              color: isDisabled
                                  ? Theme.of(context).disabledColor
                                  : Theme.of(context).colorScheme.onSurface,
                              decoration: isDisabled ? TextDecoration.lineThrough : TextDecoration.none,
                              decorationColor: Colors.blue,
                            ),
                          ),
                        ),

                        // Custom Radio button
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),
              // Confirm button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(selectedOption);
                  },
                  style: ElevatedButton.styleFrom(
                    // backgroundColor: AppColor.primary600Light,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: Text(
                    'confirm'.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: GeneralKey.appFontType,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FilterOptionModel {
  final String translationKey;
  final FilterOptionType type;
  final bool isEnabled;

  FilterOptionModel({required this.translationKey, required this.type, this.isEnabled = true});
}

enum FilterOptionType { serviceDateAscending, serviceDateDescending, alphabeticalAscending, alphabeticalDescending }

import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class FilterButtomSheet extends StatefulWidget {
  final FilterOptionType? initialSelectedType;

  const FilterButtomSheet({super.key, this.initialSelectedType});

  static Future<FilterOptionType?> show(
    BuildContext context, {
    FilterOptionType? initialSelectedType,
  }) async {
    return await showModalBottomSheet<FilterOptionType>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) =>
          FilterButtomSheet(initialSelectedType: initialSelectedType),
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
    selectedOption =
        widget.initialSelectedType ?? FilterOptionType.ServiceDateAscending;
  }

  List<FilterOptionModel> filterOptions = [
    // FilterOptionModel(
    //   translationKey: 'service_date_ascending',
    //   type: FilterOptionType.ServiceDateAscending,
    //   isEnabled: true,
    // ),
    // FilterOptionModel(
    //   translationKey: 'service_date_descending',
    //   type: FilterOptionType.ServiceDateDescending,
    //   isEnabled: true,
    // ),
    FilterOptionModel(
      translationKey: 'alphabetical_ascending',
      type: FilterOptionType.AlphabeticalAscending,
      isEnabled: true,
    ),
    FilterOptionModel(
      translationKey: 'alphabetical_descending',
      type: FilterOptionType.AlphabeticalDescending,
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
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: 0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with close button and title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'sort_by'.tr(),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: GeneralKey.appFontType,
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                      height: 1.0,
                      letterSpacing: 0,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.close,
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 20,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Text with strikethrough if disabled
                        Expanded(
                          child: Text(
                            option.translationKey.tr(),
                            style: TextStyle(
                              fontFamily: GeneralKey.appFontType,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              height:
                                  20 /
                                  16, // line-height: 20px / font-size: 16px
                              letterSpacing: 0,
                              color: isDisabled
                                  ? Theme.of(context).disabledColor
                                  : Theme.of(context).colorScheme.onSurface,
                              decoration: isDisabled
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              decorationColor: Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Custom Radio button
                        GestureDetector(
                          onTap: isDisabled
                              ? null
                              : () {
                                  setState(() {
                                    selectedOption = option.type;
                                  });
                                },
                          child: Container(
                            width: 24,
                            height: 24,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDisabled
                                  ? Colors.transparent
                                  : (selectedOption == option.type
                                        ? const Color(0xFF1CA9A6)
                                        : Colors.transparent),
                              border: Border.all(
                                color: isDisabled
                                    ? Colors.grey.withOpacity(0.5)
                                    : (selectedOption == option.type
                                          ? AppColor.primary600Light
                                          : const Color(0xFFE0E0E0)),
                                width: 2,
                              ),
                            ),
                            child: selectedOption == option.type && !isDisabled
                                ? Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  )
                                : null,
                          ),
                        ),
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
                    backgroundColor: AppColor.primary600Light,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'confirm'.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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

  FilterOptionModel({
    required this.translationKey,
    required this.type,
    this.isEnabled = true,
  });
}

enum FilterOptionType {
  ServiceDateAscending,
  ServiceDateDescending,
  AlphabeticalAscending,
  AlphabeticalDescending,
}

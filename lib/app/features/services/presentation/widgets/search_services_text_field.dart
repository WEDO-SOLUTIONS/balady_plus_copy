import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/utils_exports.dart' show AppColor, IconPath;
import '../../../_shared_feature_/shared_feature_exports.dart'
    show CustomTextFieldWidget, DrawIconBasedTypeWidget;
import '../../services_exports.dart' show ServicesCubit, ServicesState;

class SearchServicesTextField extends StatefulWidget
    implements PreferredSizeWidget {
  const SearchServicesTextField({
    super.key,
  });

  @override
  State<SearchServicesTextField> createState() =>
      _SearchServicesTextFieldState();

  @override
  Size get preferredSize => const Size.fromHeight(76);
}

class _SearchServicesTextFieldState extends State<SearchServicesTextField> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(() {
      context.read<ServicesCubit>().searchServices(
            _textEditingController.text,
          );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _textEditingController.text =
        context.read<ServicesCubit>().state.searchQuery ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesCubit, ServicesState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: CustomTextFieldWidget(
            controller: _textEditingController,
            hintText: 'search'.tr(),
            prefixIcon: const DrawIconBasedTypeWidget(
              icon: IconPath.search,
              iconColor: AppColor.primary700Light,
            ),
            borderRadius: 16,
            borderColor: AppColor.primary900Light16,
            suffixIcon: /* _textEditingController.text.isNotEmpty  ,*/ true
                ? InkWell(
                    onTap: () {
                      _textEditingController.text = '';
                      context.read<ServicesCubit>().toggleSearchField();
                    },
                    child: const DrawIconBasedTypeWidget(
                      icon: Icons.close,
                      iconColor: AppColor.primary700Light,
                    ),
                  )
                : null,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}

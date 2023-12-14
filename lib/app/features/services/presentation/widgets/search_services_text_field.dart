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
          height: 67,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: CustomTextFieldWidget(
            controller: _textEditingController,
            hintText: 'search'.tr(),
            textFieldVerticalPadding: 16,
            fillColor: Color(0xffF5F7FA),
            prefixIcon: const DrawIconBasedTypeWidget(
              icon: Icons.search,
              iconSize: 24,
              iconColor: Color(0x5C1E2A36),
            ),
            borderRadius: 8,
            textFieldStyle: TextStyle(
                color: Color(0x5C1E2A36),
                fontSize: 14,
                fontWeight: FontWeight.w400),
            borderColor: Colors.transparent,
            /* suffixIcon: _textEditingController.text.isNotEmpty
                ? InkWell(
                    onTap: () {
                      _textEditingController.text = '';
                      context.read<ServicesCubit>().toggleSearchField();
                    },
                    child: const DrawIconBasedTypeWidget(
                      icon: Icons.close,
                      iconColor: AppColor.blackModern600Light,
                    ),
                  )
                : null,*/
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

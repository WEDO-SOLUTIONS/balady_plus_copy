import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

import '../../services_exports.dart' show ServicesCubit, ServicesState;

class SearchServicesTextField extends StatefulWidget implements PreferredSizeWidget {
  const SearchServicesTextField({
    super.key,
  });

  @override
  State<SearchServicesTextField> createState() => _SearchServicesTextFieldState();

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
    _textEditingController.text = context.read<ServicesCubit>().state.searchQuery ?? '';
  }

  @override
  Widget build(BuildContext context) {
    // isFoundationDay is false by default so we don't change text color
    // Color? textColor = CommonFunctions.isFoundationDay() ? const Color(0xff6B4E45) : null;

    return BlocBuilder<ServicesCubit, ServicesState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: BaladyInput.search(
            hintText: context.l10n.searchPlaceOrAddress,
            controller: _textEditingController,
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

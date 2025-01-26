import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/services/presentation/cubit/sub_service_cubit/sub_service_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SearchServicesWidget extends StatelessWidget {
  final bool autofocus;

  const SearchServicesWidget({
    super.key,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        onChanged: (value) {
          context.read<ServiceCardsCubit>().searchServices(value);
        },
        autofocus: autofocus,
        controller: context.read<ServiceCardsCubit>().textFormSearchController,
        decoration: InputDecoration(
          hintText: "search".tr(),
          filled: true,
          fillColor: Colors.grey.shade200,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SvgPicture.asset(IconPath.search),
          ),
          suffixIcon: IconButton(
            onPressed: () {
              context.read<ServiceCardsCubit>().searchServices("");
            },
            icon: Icon(
              Icons.clear,
              color: Colors.red.shade800,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

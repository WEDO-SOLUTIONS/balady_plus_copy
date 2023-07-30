import 'package:balady_plus/etmam_app/core/utils/Debouncer.dart';
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/search_widget.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomHorizontalSpace,
        CustomIconButtonWidget,
        CustomSvgIconWidget,
        CustomTextFieldWidget;
import 'package:balady_plus/etmam_app/features/search/search_exports.dart'
    show SearchBloc, GetSearchDataEvent, SearchParams, SearchState;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchHeader extends StatefulWidget {
  final FocusNode focusNode;
  const SearchHeader({Key? key, required this.focusNode}) : super(key: key);

  @override
  State<SearchHeader> createState() => _SearchHeaderState();
}

class _SearchHeaderState extends State<SearchHeader> {
  final TextEditingController _controller = TextEditingController();

  final _debouncer = Debouncer(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchBloc, SearchState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12)),
              color: Colors.white),
          child: Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20),
            child: SizedBox(
              height: 64,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /* CustomIconButtonWidget(
                      btnPressed: () => Navigator.of(context).pop(),
                      icon: CustomSvgIconWidget(
                        IconPath.back,
                        iconFit: BoxFit.fill,
                        iconHeight: 24,
                        iconSize: 24,
                        iconWidth: 24,
                        iconColor: AppColorsTheme.primary700,
                      )),*/
                  const CustomHorizontalSpace(width: 16),
                  Expanded(
                    child: SearchWidget(
                      hint: trans('Search_SearchForServiceHint'),
                      onChange: /* () {},*/
                          (text) {
                        if (text != state.text)
                          _debouncer.run(() {
                            context.read<SearchBloc>().add(GetSearchDataEvent(
                                params:
                                    SearchParams(pageIndex: "1", text: text)));
                            setState(() {});
                          });
                      },
                    ),
                  ),
                  const CustomHorizontalSpace(width: 16)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class SearchIcon extends StatelessWidget {
  // String? text;
  TextEditingController controller;
  SearchIcon({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool showSearch = controller.text.isEmpty;
    return GestureDetector(
      onTap: () {
        if (!showSearch) {
          controller.clear();
          context.read<SearchBloc>().add(GetSearchDataEvent(
              params: SearchParams(pageIndex: "1", text: controller.text)));
        }
      },
      child: Container(
          padding: const EdgeInsetsDirectional.only(end: 12),
          child: showSearch
              ? SvgPicture.asset(IconPath.search)
              : SvgPicture.asset(IconPath.searchCancel)),
    );
  }
}

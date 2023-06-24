import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/vd/presentation/blocs/create_vd_details_bloc/create_vd_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/constants/app_colors.dart';

class VDSearchTextFieldWidget extends StatefulWidget {
  final String hintText;
  final Function onTextChanged;
  final Function onSubmitSearch;
  final double containerHeight;

  const VDSearchTextFieldWidget(
      {Key? key,
      required this.hintText,
      required this.onTextChanged,
      required this.onSubmitSearch,
      this.containerHeight = 40})
      : super(key: key);

  @override
  _VDSearchTextFieldWidgetState createState() =>
      _VDSearchTextFieldWidgetState();
}

class _VDSearchTextFieldWidgetState extends State<VDSearchTextFieldWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateVDBloc, CreateVDState>(
      listenWhen: ((previous, current) =>
          previous.isSearchShown != current.isSearchShown),
      listener: (context, state) {
        if (state.isSearchShown != null && !state.isSearchShown!) {
          _controller.text = "";
        }
      },
      child: Container(
        height: widget.containerHeight,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            boxShadow: [
              BoxShadow(
                  color: Color(0x1a000000),
                  offset: Offset(0, 2),
                  blurRadius: 15,
                  spreadRadius: 0)
            ],
            color: Colors.white),
        alignment: Alignment.center,
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
          child: TextFormField(
            onChanged: (String val) => widget.onTextChanged(val),
            controller: _controller,
            style: const TextStyle(
              color: AppColor.black,
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
            cursorColor: AppColor.black100,
            textInputAction: TextInputAction.search,
            onFieldSubmitted: (String val) => widget.onSubmitSearch(val),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                color: AppColor.black300,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
              suffixIcon: Container(
                margin: const EdgeInsetsDirectional.only(end: 5),
                child: Image.asset(
                  IconPath.vdmapSearchIcon,
                  height: 24,
                  width: 24,
                ),
              ),
              fillColor: AppColor.white,
              filled: true,
              isDense: true,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: const EdgeInsets.only(
                  top: 10, right: 10, left: 10, bottom: 10),
              suffixIconConstraints: const BoxConstraints(
                minHeight: 24,
                minWidth: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder getOutlineDesign() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(4.0),
      borderSide: const BorderSide(color: AppColor.black100, width: 1),
    );
  }
}

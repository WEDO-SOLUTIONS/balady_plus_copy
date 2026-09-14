import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'base_view_model.dart';

class BaseView<T extends BaseViewModel> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget? child) builder;
  final Function(T) onModelReady;
  final Function()? onHideKeyboard;

  const BaseView({super.key, required this.builder, required this.onModelReady, this.onHideKeyboard});

  @override
  State<BaseView<T>> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseViewModel> extends State<BaseView<T>> {
  T model = locator<T>();

  @override
  void initState() {
    super.initState();
    widget.onModelReady(model);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !model.isLoading,
      child: GestureDetector(
        onTap: () => hideKeyboard(),
        child: ChangeNotifierProvider<T>.value(
          value: model,
          child: Consumer<T>(builder: widget.builder),
        ),
      ),
    );
  }

  void hideKeyboard() {
    FocusScope.of(context).unfocus();
    if (widget.onHideKeyboard != null) widget.onHideKeyboard!();
  }
}

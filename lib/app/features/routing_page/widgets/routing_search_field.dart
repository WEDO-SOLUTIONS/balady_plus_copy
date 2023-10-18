part of '../routing_overlay.dart';

class NavSearchField extends StatelessWidget {
  const NavSearchField(this.letter, {super.key});

  final String letter;

  @override
  Widget build(BuildContext context) {
    final model = context.watch<RoutingSearchViewModel>();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: TextField(
            // style: MapnessTypography.s,
            textAlign: TextAlign.end,
            textInputAction: TextInputAction.done,
            controller: model.searchController,
            onSubmitted: model.onSubmitTap,
            focusNode: model.searchFocusNode,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 13,
              ),
              isDense: true,
              suffixIconConstraints: BoxConstraints(
                maxHeight: 24,
                maxWidth: 24,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: model.clearControlState,
          builder: (_, visible, __) {
            return GestureDetector(
              onTap: model.onClearTap,
              child: !visible
                  ? const SizedBox.shrink()
                  : SizedBox(
                      width: 16,
                      height: 16,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xff212121).withOpacity(0.2),
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
            );
          },
        ),
        const SizedBox(
          width: 10,
        ),
        ValueListenableBuilder<bool>(
          valueListenable: model.cancelControlState,
          builder: (_, visible, __) {
            return !visible
                ? Center(
                    child: CustomTextWidget(
                      letter,
                      textStyle: AppStyle.appBarTitleTextStyle,
                    ),
                  )
                : GestureDetector(
                    onTap: model.onCancelTap,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(
                          start: 6.0, end: 6.0),
                      child: Text(
                        "cancel".tr(),
                        style: const TextStyle(
                          color: Color(0xFF1F4948),
                        ),
                      ),
                    ),
                  );
          },
        ),
      ],
    );
  }
}

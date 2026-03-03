# Breaking changes by release

The following guides are available. They're sorted by release and listed in alphabetical order:

### Released in UIKIT 4.0.0

# [StatefulBottomSheet] and [StatelessBottomSheet] 
- No longer have a function callbacks as a delegate. Now it's using [StatefulSheetDelegate] and [StatelessSheetDelegate].

## Migration example for lambda functions:

### Old
```dart
backgroundColorDelegate: (controller) =>
                Colors.black.withOpacity(Curves.easeIn.transform(controller.aspectRatio.clamp(0, 1)) * 0.7),
```

### New
```dart
backgroundColorDelegate: StatelessSheetDelegateFunction(
                function: (controller) =>
                    Colors.black.withOpacity(Curves.easeIn.transform(controller.aspectRatio.clamp(0, 1)) * 0.7)),
```

## Migration example for static functions:

### Old
```dart
static Color? backgroundColorDelegate(StatefulBottomSheetController<FourStateBottomSheet> controller) {
    return Colors.black.withOpacity(Curves.easeIn.transform(controller.aspectRatio.clamp(0, 1)) * 0.7);
}
```

### New
```dart
static const StatefulSheetDelegateFunction<Color?, FourStateBottomSheet> backgroundColorDelegate =
      StatefulSheetDelegateFunction<Color?, FourStateBottomSheet>(function: _backgroundColorDelegate);

static Color? _backgroundColorDelegate(StatefulBottomSheetController<FourStateBottomSheet> controller) {
    return Colors.black.withOpacity(Curves.easeIn.transform(controller.aspectRatio.clamp(0, 1)) * 0.7);
}
```

# [StatelessBottomSheet] - Use inside [SafeArea] widget
 - No longer fill the bottom safe area if no padding provided by [MediaQuery]. By default [SafeArea] using [Padding] from the [MediaQuery] and remove it from context. To support old behavior do not use [SafeArea] widget and use [Padding] widget with the padding from [MediaQuery.viewPaddingOf(context)].
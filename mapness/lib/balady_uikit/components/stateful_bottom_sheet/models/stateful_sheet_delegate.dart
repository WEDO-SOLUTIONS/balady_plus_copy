import 'package:mapness/balady_uikit/components/stateful_bottom_sheet/stateful_bottom_sheet.dart';

/// A sealed class that represents a delegate for the bottom sheet.
sealed class StatefulSheetDelegate<T> {
  const StatefulSheetDelegate();

  /// We need this method to get the value of the delegate if it is a static value.
  /// We want to avoid calling the function every time we need the value and we can use this method in [init()]
  /// to get the value of the delegate and store it in a variable.
  ///
  /// Example:
  /// ```dart
  /// class A {
  ///   double? value;
  ///   final StatefulSheetDelegate<T> valueDelegate;
  ///
  ///   A({required this.valueDelegate}) {
  ///     value = valueDelegate.getStaticValue();
  ///   }
  ///
  ///   ...
  ///
  ///   void foo() {
  ///     final z = value ?? valueDelegate.getValue(scrollController) ?? _defaultValue;
  ///   }
  /// }
  /// ```
  T? getStaticValue() {
    if (this is StatefulSheetDelegateValue<T>) {
      return (this as StatefulSheetDelegateValue<T>).value;
    }
    return null;
  }

  T? getValue<K>(StatefulBottomSheetController<K> controller) => switch (this) {
    final StatefulSheetDelegateValue<T> value => value.value,
    final StatefulSheetDelegateFunction<T, K> function => function.function(controller),
    _ => null,
  };
}

/// A delegate that holds a static value.
class StatefulSheetDelegateValue<T> extends StatefulSheetDelegate<T> {
  const StatefulSheetDelegateValue({required this.value});

  final T value;
}

/// A delegate that holds a function that uses the [StatefulBottomSheetController] to calculate the value.
class StatefulSheetDelegateFunction<T, K> extends StatefulSheetDelegate<T> {
  const StatefulSheetDelegateFunction({required this.function});

  final T? Function(StatefulBottomSheetController<K> controller) function;
}

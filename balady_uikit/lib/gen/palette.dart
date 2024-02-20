import 'dart:ui';

abstract class Palette {
  // Light
  Color get text_and_icons_base_primary;
  Color get text_and_icons_base_secondary;
  Color get text_and_icons_base_tertiary;
  Color get text_and_icons_base_inverse_primary;
  Color get text_and_icons_base_inverse_secondary;
  Color get text_and_icons_base_inverse_tertiary;
  Color get text_and_icons_status_accent;
  Color get text_and_icons_status_positive;
  Color get text_and_icons_status_attention;
  Color get text_and_icons_status_negative;
  Color get surface_base_primary;
  Color get surface_base_secondary;
  Color get surface_base_tertiary;
  Color get surface_contrast_low;
  Color get surface_base_inverse_primary;
  Color get surface_contrast_mid;
  Color get surface_contrast_high;
  Color get stroke_primary;
  Color get stroke_accent;
}

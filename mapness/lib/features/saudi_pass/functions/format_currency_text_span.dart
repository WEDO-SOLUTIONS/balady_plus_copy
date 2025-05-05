import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/rendering.dart';
import 'package:mapness/shared/providers/app_language.dart';

TextSpan formatCurrencyTextSpan(num amount, Language language, Locale locale, [double? iconSize]) => TextSpan(
      text: '$amount ',
      children: [
        switch (language) {
          Language.english => const TextSpan(text: 'SAR'),
          Language.arabic => GeneralIcons.sarSpan(style: GeneralIcons.sarSpan().style?.copyWith(fontSize: iconSize)),
        }
      ],
    );

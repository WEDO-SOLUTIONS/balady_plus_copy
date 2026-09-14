import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svg_provider;

DecorationImage calendarImage(String? url, String? defaultImage) => (url?.isEmpty ?? true)
    ? (defaultImage ?? "").endsWith(".svg")
          ? DecorationImage(
              image: svg_provider.Svg(defaultImage ?? "", source: svg_provider.SvgSource.asset),
              fit: BoxFit.fill,
            )
          : DecorationImage(image: AssetImage(defaultImage ?? ""), fit: BoxFit.fill)
    : (url!.endsWith(".svg"))
    ? DecorationImage(
        image: svg_provider.Svg(url, source: svg_provider.SvgSource.network),
        fit: BoxFit.fill,
        onError: (exception, stackTrace) => debugPrint(exception.toString()),
      )
    : DecorationImage(image: NetworkImage(url), fit: BoxFit.fill);

import 'package:flutter/material.dart';

import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svgProvider;

DecorationImage calendarImage(String? url, String? defaultImage) =>
    (url?.isEmpty ?? true)
        ? DecorationImage(
            image: svgProvider.Svg(defaultImage ?? "",
                source: svgProvider.SvgSource.asset),
            fit: BoxFit.fill,
          )
        : (url!.endsWith(".svg"))
            ? DecorationImage(
                image: svgProvider.Svg(
                  url,
                  source: svgProvider.SvgSource.network,
                ),
                fit: BoxFit.fill,
              )
            : DecorationImage(
                image: NetworkImage(url),
                fit: BoxFit.fill,
              );

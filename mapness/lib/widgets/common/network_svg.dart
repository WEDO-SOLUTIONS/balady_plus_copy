import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// `SvgPicture.network` re-reports a broken asset on EVERY rebuild:
/// flutter_svg caches the failed decode permanently (its cache clears the
/// pending entry only on success and registers no error handler), while
/// vector_graphics clears its own entry — so each rebuild re-enters, re-fails
/// on the cached rejection, and leaks one unhandled async error to the zone
/// reporter (~19k telemetry events a week from a handful of broken icons).
///
/// A process-wide blocklist of URLs that already failed once short-circuits
/// the whole path: the first failure still costs the library-leaked report,
/// every later rebuild renders the fallback for free.
class NetworkSvg extends StatelessWidget {
  const NetworkSvg(
    this.url, {
    this.width,
    this.height,
    this.colorFilter,
    this.fallback,
    super.key,
  });

  static final Set<String> _broken = <String>{};

  final String url;
  final double? width;
  final double? height;
  final ColorFilter? colorFilter;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    final placeholder = fallback ?? SizedBox(width: width, height: height);
    if (url.isEmpty || _broken.contains(url)) {
      return placeholder;
    }

    return SvgPicture.network(
      url,
      width: width,
      height: height,
      colorFilter: colorFilter,
      placeholderBuilder: (_) => placeholder,
      errorBuilder: (_, __, ___) {
        _broken.add(url);
        return placeholder;
      },
    );
  }
}

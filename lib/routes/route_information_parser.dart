import 'package:advanced_navigation/model/page_config.dart';
import 'package:flutter/material.dart';

class MyRouteInformationParser
    extends RouteInformationParser<PageConfiguration> {
  @override
  Future<PageConfiguration> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    // final uri = Uri.parse(routeInformation.location.toString());
    final uri = Uri.parse(routeInformation.uri.toString());

    if (uri.pathSegments.isEmpty) {
      // without path parameter => "/"
      return PageConfiguration.home();
    } else if (uri.pathSegments.length == 2) {
      // path parameter => "/aaa/bbb"
      final first = uri.pathSegments[0].toLowerCase();
      final second = uri.pathSegments[1].toLowerCase();
      final quoteId = int.tryParse(second) ?? 0;
      if (first == 'quote' && (quoteId >= 1 && quoteId <= 5)) {
        return PageConfiguration.detailQuote(second);
      } else {
        return PageConfiguration.unknown();
      }
    } else {
      return PageConfiguration.unknown();
    }
  }

  @override
  RouteInformation? restoreRouteInformation(PageConfiguration configuration) {
    if (configuration.isHomePage) {
      return RouteInformation(uri: Uri.parse('/'));
    } else if (configuration.isDetailPage) {
      return RouteInformation(
        uri: Uri.parse('/quote/${configuration.quoteId}'),
      );
    } else {
      return RouteInformation(uri: Uri.parse('/unknown'));
    }
  }
}

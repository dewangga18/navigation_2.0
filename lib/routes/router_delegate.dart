import 'package:advanced_navigation/model/quote.dart';
import 'package:advanced_navigation/screen/detail_quotes_screen.dart';
import 'package:advanced_navigation/screen/form_screen.dart';
import 'package:advanced_navigation/screen/quotes_list_screen.dart';
import 'package:flutter/material.dart';

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;

  MyRouterDelegate() : _navigatorKey = GlobalKey<NavigatorState>();

  String? selectedQuote;
  bool isForm = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quotes App',
      home: Navigator(
        key: navigatorKey,
        pages: [
          MaterialPage(
            key: const ValueKey("QuotesListPage"),
            child: QuotesListScreen(
              quotes: quotes,
              onTapped: (String id) {
                selectedQuote = id;
                notifyListeners();
              },
              toFormScreen: () {
                isForm = true;
                notifyListeners();
              },
            ),
          ),
          if (selectedQuote != null)
            MaterialPage(
              key: ValueKey("QuoteDetailsPage-$selectedQuote"),
              child: QuoteDetailsScreen(
                quoteId: selectedQuote!,
              ),
            ),
          if (isForm)
            MaterialPage(
              key: const ValueKey("FormScreen"),
              child: FormScreen(onSend: () {
                isForm = false;
                notifyListeners();
              }),
            ),
        ],
        onPopPage: (route, result) {
          final didPop = route.didPop(result);
          if (!didPop) {
            return false;
          }
          selectedQuote = null;
          isForm = false;
          notifyListeners();
          return true;
        },
      ),
    );
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(configuration) {
    throw UnimplementedError();
  }
}

import 'dart:developer';

import 'package:advanced_navigation/db/auth_repository.dart';
import 'package:advanced_navigation/model/page_config.dart';
import 'package:advanced_navigation/model/quote.dart';
import 'package:advanced_navigation/screen/detail_quotes_screen.dart';
import 'package:advanced_navigation/screen/login_screen.dart';
import 'package:advanced_navigation/screen/quotes_list_screen.dart';
import 'package:advanced_navigation/screen/register_screen.dart';
import 'package:advanced_navigation/screen/splash_screen.dart';
import 'package:flutter/material.dart';

class MyRouterDelegate extends RouterDelegate<PageConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;
  final AuthRepository authRepository;

  MyRouterDelegate(
    this.authRepository,
  ) : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  _init() async {
    isLoggedIn = await authRepository.isLoggedIn();
    notifyListeners();
  }

  List<Page> historyStack = [];
  bool? isLoggedIn;
  bool isRegister = false;

  String? selectedQuote;

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == null) {
      historyStack = _splashStack;
    } else if (isLoggedIn == true) {
      historyStack = _loggedInStack;
    } else {
      historyStack = _loggedOutStack;
    }
    return MaterialApp(
      title: 'Quotes App',
      home: Navigator(
        key: navigatorKey,
        pages: historyStack,
        onPopPage: (route, result) {
          final didPop = route.didPop(result);
          if (!didPop) {
            return false;
          }
          isRegister = false;
          selectedQuote = null;
          notifyListeners();
          return true;
        },
      ),
    );
  }

  List<Page> get _splashStack => const [
        MaterialPage(
          key: ValueKey("SplashPage"),
          child: SplashScreen(),
        ),
      ];

  List<Page> get _loggedOutStack => [
        MaterialPage(
          key: const ValueKey("LoginPage"),
          child: LoginScreen(
            onLogin: () {
              isLoggedIn = true;
              notifyListeners();
            },
            onRegister: () {
              isRegister = true;
              notifyListeners();
            },
          ),
        ),
        if (isRegister == true)
          MaterialPage(
            key: const ValueKey("RegisterPage"),
            child: RegisterScreen(
              onRegister: () {
                isRegister = false;
                notifyListeners();
              },
              onLogin: () {
                isRegister = false;
                notifyListeners();
              },
            ),
          ),
      ];

  List<Page> get _loggedInStack => [
        MaterialPage(
          key: const ValueKey("QuotesListPage"),
          child: QuotesListScreen(
            quotes: quotes,
            onTapped: (String quoteId) {
              selectedQuote = quoteId;
              notifyListeners();
            },
            onLogout: () {
              isLoggedIn = false;
              notifyListeners();
            },
          ),
        ),
        if (selectedQuote != null)
          MaterialPage(
            key: ValueKey(selectedQuote),
            child: QuoteDetailsScreen(
              quoteId: selectedQuote!,
            ),
          ),
      ];

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

   bool? isUnknown;

  @override
  Future<void> setNewRoutePath(PageConfiguration configuration) async {
    if (configuration.isUnknownPage) {
      isUnknown = true;
    } else if (configuration.isHomePage) {
      isUnknown = false;
      selectedQuote = null;
    } else if (configuration.isDetailPage) {
      isUnknown = false;
      selectedQuote = configuration.quoteId.toString();
    } else {
      log(' Could not set new route');
    }

    notifyListeners();
  }

  @override
  PageConfiguration? get currentConfiguration {
    if (isUnknown == true) {
      return PageConfiguration.unknown();
    } else if (selectedQuote == null) {
      return PageConfiguration.home();
    } else if (selectedQuote != null) {
      return PageConfiguration.detailQuote(selectedQuote!);
    } else {
      return null;
    }
  }
}

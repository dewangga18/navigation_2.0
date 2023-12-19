import 'package:advanced_navigation/common/url_strategy.dart';
import 'package:advanced_navigation/db/auth_repository.dart';
import 'package:advanced_navigation/provider/auth_provider.dart';
import 'package:advanced_navigation/routes/route_information_parser.dart';
import 'package:advanced_navigation/routes/router_delegate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {usePathUrlStrategy();
  runApp(const QuotesApp());
}

class QuotesApp extends StatefulWidget {
  const QuotesApp({super.key});

  @override
  State<QuotesApp> createState() => _QuotesAppState();
}

class _QuotesAppState extends State<QuotesApp> {
  late MyRouterDelegate myRouterDelegate;
  late AuthProvider authProvider;
  late MyRouteInformationParser myRouteInformationParser;

  @override
  void initState() {
    super.initState();
    final authRepository = AuthRepository();

    authProvider = AuthProvider(authRepository);
    myRouterDelegate = MyRouterDelegate(authRepository);
    myRouteInformationParser = MyRouteInformationParser();
  }

  String? selectedQuote;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => authProvider,
      child: MaterialApp.router(
        title: 'Quotes App',
        routerDelegate: myRouterDelegate,
        routeInformationParser: myRouteInformationParser,
        backButtonDispatcher: RootBackButtonDispatcher(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:psitool/first_page.dart';
import 'package:psitool/initial_page.dart';
import 'package:psitool/second_page.dart';
import 'package:psitool/setting_page.dart';
import 'package:psitool/third_page.dart';

void main() {
  runApp(const MyApp());
}

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();

class Setup {
  static final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    routes: [
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) {
          return InitialPage(location: state.fullPath ?? '/', child: child);
        },
        routes: [
          GoRoute(
            parentNavigatorKey: shellNavigatorKey,
            path: '/',
            builder: (context, state) => FirstPage(),
          ),
          GoRoute(
            parentNavigatorKey: shellNavigatorKey,
            path: '/second_page',
            builder: (context, state) => const SecondPage(),
            routes: [
              GoRoute(
                parentNavigatorKey: rootNavigatorKey,
                path: 'side_page_1',
                pageBuilder: (context, state) => CustomTransitionPage(
                  child: SidePage(
                    builder: (context, pop) => Scaffold(
                      appBar: AppBar(
                        automaticallyImplyLeading: false,
                        centerTitle: false,
                        title: Text('Side Page 1'),
                        actions: [
                          IconButton(onPressed: pop, icon: Icon(Icons.close)),
                        ],
                      ),
                      body: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            context.goNamed('SidePage2');
                          },
                          child: const Text('Go to Side Page 1'),
                        ),
                      ),
                    ),
                  ),
                  opaque: false,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) => child,
                ),
                routes: [
                  GoRoute(
                    parentNavigatorKey: rootNavigatorKey,
                    path: 'side_page_2',
                    name: 'SidePage2',
                    pageBuilder: (context, state) {
                      return CustomTransitionPage(
                        child: SidePage(
                          builder: (context, pop) => Scaffold(
                            appBar: AppBar(
                              title: Text('Side Page 2'),
                              automaticallyImplyLeading: false,
                              centerTitle: false,
                              actions: [
                                IconButton(
                                  onPressed: pop,
                                  icon: Icon(Icons.close),
                                ),
                              ],
                            ),
                            body: Center(
                              child: ElevatedButton(
                                onPressed: pop,
                                child: Text('Close'),
                              ),
                            ),
                          ),
                        ),
                        opaque: false,
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) =>
                                child,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            parentNavigatorKey: shellNavigatorKey,
            path: '/third_page',
            builder: (context, state) => ThirdPage(),
            routes: [
              GoRoute(
                parentNavigatorKey: rootNavigatorKey,
                path: 'settings',
                builder: (context, state) => SettingPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: Setup.router);
  }
}

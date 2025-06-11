import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key, required this.child, required this.location});

  final Widget child;
  final String location;

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  NavigationRailLabelType labelType = NavigationRailLabelType.all;
  bool showLeading = false;
  bool showTrailing = false;
  bool showNavigationRail = true;
  double groupAlignment = -1.0;

  final mapRoutes = {0: '/', 1: '/second_page', 2: '/third_page'};

  int get selectedIndex {
    final rootLocation = widget.location.split('/').sublist(0, 2).join('/');
    return mapRoutes.entries
        .firstWhere(
          (entry) => entry.value == rootLocation,
          orElse: () {
            return MapEntry(0, '/');
          },
        )
        .key;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Check if the screen width is less than 600 pixels
        final hiddenBottomNavigationBar = constraints.maxWidth < 600;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                setState(() {
                  showNavigationRail = !showNavigationRail;
                });
              },
              icon: Icon(Icons.menu),
            ),
          ),
          bottomNavigationBar: hiddenBottomNavigationBar
              ? BottomNavigationBar(
                  onTap: (index) {
                    final route = mapRoutes[index] ?? '';
                    context.go(route);
                  },
                  currentIndex: selectedIndex,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.favorite_border),
                      label: 'First',
                    ),
                    BottomNavigationBarItem(
                      icon: Badge(child: Icon(Icons.bookmark_border)),
                      label: 'Second',
                    ),
                    BottomNavigationBarItem(
                      icon: Badge(
                        label: Text('4'),
                        child: Icon(Icons.star_border),
                      ),
                      label: 'Third',
                    ),
                  ],
                )
              : null,
          body: SafeArea(
            child: Row(
              children: [
                if (!hiddenBottomNavigationBar)
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) => SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(-1, 0), // slide out to the left
                        end: Offset(0, 0),
                      ).animate(animation),
                      child: child,
                    ),
                    child: showNavigationRail
                        ? Card(
                            key: ValueKey('menu'),
                            color: Colors.lightBlue,
                            child: NavigationRail(
                              extended: true,
                              backgroundColor: Colors.transparent,
                              selectedIndex: selectedIndex,
                              groupAlignment: groupAlignment,
                              onDestinationSelected: (int index) {
                                final route = mapRoutes[index] ?? '';
                                context.go(route);
                              },

                              // labelType: labelType,
                              leading: showLeading
                                  ? FloatingActionButton(
                                      elevation: 0,
                                      onPressed: () {
                                        // Add your onPressed code here!
                                      },
                                      child: const Icon(Icons.add),
                                    )
                                  : const SizedBox(),
                              trailing: showTrailing
                                  ? IconButton(
                                      onPressed: () {
                                        // Add your onPressed code here!
                                      },
                                      icon: const Icon(
                                        Icons.more_horiz_rounded,
                                      ),
                                    )
                                  : const SizedBox(),
                              destinations: const <NavigationRailDestination>[
                                NavigationRailDestination(
                                  icon: Icon(Icons.favorite_border),
                                  selectedIcon: Icon(Icons.favorite),
                                  label: Text('First'),
                                ),
                                NavigationRailDestination(
                                  icon: Badge(
                                    child: Icon(Icons.bookmark_border),
                                  ),
                                  selectedIcon: Badge(child: Icon(Icons.book)),
                                  label: Text('Second'),
                                ),
                                NavigationRailDestination(
                                  icon: Badge(
                                    label: Text('4'),
                                    child: Icon(Icons.star_border),
                                  ),
                                  selectedIcon: Badge(
                                    label: Text('4'),
                                    child: Icon(Icons.star),
                                  ),
                                  label: Text('Third'),
                                ),
                              ],
                            ),
                          )
                        : SizedBox.shrink(key: ValueKey("empty")),
                  ),
                // const VerticalDivider(thickness: 1, width: 1),
                // This is the main content.
                Expanded(child: widget.child),
              ],
            ),
          ),
        );
      },
    );
  }
}

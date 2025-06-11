import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Page')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                context.go('/');
              },
              child: const Text('Back to Initial Page'),
            ),
            ElevatedButton(
              onPressed: () {
                context.go('/second_page/side_page_1');
              },
              child: const Text('Open Side Page'),
            ),
          ],
        ),
      ),
    );
  }
}

class SidePage extends StatefulWidget {
  const SidePage({super.key, required this.builder});

  final Widget Function(BuildContext context, VoidCallback pop) builder;

  @override
  State<SidePage> createState() => _SidePageState();
}

class _SidePageState extends State<SidePage> with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    controller.animateTo(1.0, curve: Curves.easeInOut);
    super.initState();
  }

  void pop() {
    controller.animateTo(0.0, curve: Curves.easeInOut).then((_) {
      context.pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Stack(
            children: [
              GestureDetector(
                onTap: pop,
                child: Container(
                  color: Colors.black.withValues(alpha: 0.5 * controller.value),
                ),
              ),
              Positioned(
                right: 0,
                height: MediaQuery.of(context).size.height,
                child: Transform.translate(
                  offset: Offset(300 * (1 - controller.value), 0),
                  child: Container(
                    width: 300,
                    color: Colors.blueGrey[100],
                    child: widget.builder(context, pop),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

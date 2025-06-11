

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingPage extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('Back to Initial Page'),
            ),
            const SizedBox(height: 20),
            const Text('Settings Page Content Here'),
          ],
        ),
      ),
    );
  }
}
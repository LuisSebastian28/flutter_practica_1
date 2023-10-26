import 'package:flutter/material.dart';
import 'package:guide_form/forms.dart';
import 'package:guide_form/preferencies.dart';

void main() {
  runApp(const _MyAppState());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_sync/hello_service.dart';
import 'package:flutter_sync/ui_kit/widgets/nav_rail.dart';

void main() {
  HelloService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NavRail(),
    );
  }
}

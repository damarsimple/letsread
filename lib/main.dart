import 'package:flutter/material.dart';
import 'package:sight_word/landing.dart';
import 'package:sight_word/tutorial.dart';
import 'package:sight_word/home.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sight Word',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Landing(),
        '/tutorial': (context) => const Tutorial(),
        '/home': (context) => const Home(),
      },
    );
  }
}

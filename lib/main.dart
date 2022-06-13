import 'package:flutter/material.dart';
import 'package:letsread/landing.dart';
import 'package:letsread/tutorial.dart';
import 'package:letsread/home.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Let\'s Read',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Landing(),
        '/tutorial': (context) => const Tutorial(),
        '/home': (context) => Home(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:momentum/pages/auth.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Momentum Mod',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey.shade900,
        cardColor: Colors.grey[850],
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: Colors.blue,
              brightness: Brightness.dark,
              surface: Colors.black,
              onSurface: Colors.white,
            ),
      ),
      home: const AuthPage(),
    );
  }
}

import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const CazaErroresApp());
}

class CazaErroresApp extends StatelessWidget {
  const CazaErroresApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gramaticador',

      builder: (context, child) {
        return Center(
          child: SizedBox(
            width: 390,
            child: child,
          ),
        );
      },

      home: const HomeScreen(),
    );
  }
}
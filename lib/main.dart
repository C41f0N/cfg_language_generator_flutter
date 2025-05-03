import 'package:cfg_language_generator_flutter/data/cfg_generator.dart';
import 'package:cfg_language_generator_flutter/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CfgGenerator(),
      builder: (context, widget1) {
        return MaterialApp(
          title: 'CFG String Generator',
          theme: ThemeData(colorScheme: ColorScheme.dark()),
          home: const HomeScreen(),
        );
      },
    );
  }
}

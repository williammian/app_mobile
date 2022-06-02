import 'package:app_mobile/screens/home_screen.dart';
import 'package:app_mobile/screens/itens/itens_list_screen.dart';
import 'package:app_mobile/screens/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'App Mobile',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const LoginScreen(message: ''),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(message: ''),
          '/home': (context) => const HomeScreen(),
          '/itens': (context) => const ItensListScreen()
        });
  }
}

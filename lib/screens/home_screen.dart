import 'package:app_mobile/widgets/nav_drawer.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Mobile'),
      ),
      drawer: NavDrawer(),
    );
  }
}

import 'package:flutter/material.dart';

class CaisseHomePage extends StatefulWidget {
  @override
  _CaisseHomePageState createState() => _CaisseHomePageState();
}

class _CaisseHomePageState extends State<CaisseHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Passer une commande'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bienvenue dans la page de commande',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
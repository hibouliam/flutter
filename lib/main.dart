import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Button Example',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Exemple de Bouton Flutter'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              // Action qui sera exécutée lors du clic sur le bouton
              print('Bouton cliqué!');
            },
            child: Text('Cliquez-moi'),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AlertMessages {
  BuildContext _context;
  String _title = '';
  String _text = '';

  AlertMessages(this._context);

  static AlertMessages of(BuildContext context) {
    return AlertMessages(context);
  }

  AlertMessages title(String title) {
    _title = title;
    return this;
  }

  AlertMessages text(String text) {
    _text = text;
    return this;
  }

  void show() {
    showDialog(
      context: _context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: Text(_title),
          content: Text(_text),
          actions: <Widget>[
            // define os botões na base do dialogo
            TextButton(
              child: const Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

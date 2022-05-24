import 'package:flutter/material.dart';

class ConfirmMessages {
  BuildContext _context;
  String _title = '';
  String _text = '';

  ConfirmMessages(this._context);

  static ConfirmMessages of(BuildContext context) {
    return ConfirmMessages(context);
  }

  ConfirmMessages title(String title) {
    _title = title;
    return this;
  }

  ConfirmMessages text(String text) {
    _text = text;
    return this;
  }

  Future<bool> show() async {
    return await showDialog(
      context: _context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_title),
          content: Text(_text),
          actions: <Widget>[
            TextButton(
              child: const Text('Confirmar'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );
  }
}

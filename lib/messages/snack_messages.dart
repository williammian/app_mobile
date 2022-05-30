import 'package:flutter/material.dart';

class SnackMessages {
  final BuildContext _context;
  String _text = '';
  Color _color = Colors.black54;

  SnackMessages(this._context);

  static SnackMessages of(BuildContext context) {
    return SnackMessages(context);
  }

  SnackMessages text(String text) {
    _text = text;
    return this;
  }

  void warning() {
    _color = Colors.orangeAccent;
    show();
  }

  void error() {
    _color = Colors.redAccent;
    show();
  }

  void success() {
    _color = Colors.lightGreen;
    show();
  }

  void show() {
    ScaffoldMessenger.of(_context).showSnackBar(SnackBar(
      content: Text(_text),
      duration: const Duration(seconds: 5),
      backgroundColor: _color,
    ));
  }
}

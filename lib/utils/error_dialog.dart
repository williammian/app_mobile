import 'package:app_mobile/exceptions/authorization_exception.dart';
import 'package:app_mobile/exceptions/validacao_exception.dart';
import 'package:app_mobile/messages/snack_messages.dart';
import 'package:app_mobile/screens/login_screen.dart';
import 'package:flutter/material.dart';

class ErrorDialog {
  final BuildContext _context;
  final Object _err;

  ErrorDialog(this._context, this._err);

  static ErrorDialog of(BuildContext context, Object err) {
    return ErrorDialog(context, err);
  }

  void defaultCatch() {
    if (_err is AuthorizationException) {
      Navigator.of(_context).push(MaterialPageRoute(
          builder: (context) => const LoginScreen(message: "")));
    } else if (_err is ValidacaoException) {
      SnackMessages.of(_context).text(_err.toString()).warning();
    } else {
      SnackMessages.of(_context).text(_err.toString()).error();
    }
  }
}

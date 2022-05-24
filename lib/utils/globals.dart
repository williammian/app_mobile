import 'package:app_mobile/model/usuario_model.dart';
import 'package:flutter/material.dart';

class Globals {
  static final Globals _globals = Globals._internal();
  factory Globals() => _globals;
  Globals._internal();
  static Globals get shared => _globals;

  late BuildContext globalContext;
  String servidor = '';
  String token = '';
  late Usuario? usuario;
}

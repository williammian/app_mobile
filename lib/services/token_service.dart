import 'package:app_mobile/model/usuario_model.dart';
import 'package:app_mobile/services/storage_service.dart';
import 'dart:convert' show json, base64, ascii;

class TokenService {
  static const String _key = 'token';

  final StorageService _storageService = StorageService();

  bool hasToken() {
    String token = getToken();
    return token.isNotEmpty;
  }

  Future<void> setToken(String token) async {
    await _storageService.setItem(_key, token);
  }

  String getToken() {
    return _storageService.getItem(_key);
  }

  Future<void> removeToken() async {
    await _storageService.deleteItem(_key);
  }

  dynamic getPayloadToken() {
    String token = getToken();
    if (token.isEmpty) throw Exception("Token vazio");

    var jwt = token.split(".");
    if (jwt.length != 3) throw Exception("Token inválido");

    var payload =
        json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));
    return payload;
  }

  bool isTokenValido() {
    dynamic payload = getPayloadToken();
    if (!DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000)
        .isAfter(DateTime.now())) {
      return false;
    }
    return true;
  }

  Usuario? getUsuario() {
    dynamic payload = getPayloadToken();
    dynamic user = json.decode(payload['sub']);
    if (user != null) {
      return Usuario.fromJson(user);
    }
    return null;
  }
}

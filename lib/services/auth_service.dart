import 'package:app_mobile/http/http_request.dart';
import 'package:app_mobile/model/usuario_model.dart';
import 'package:app_mobile/services/token_service.dart';

class AuthService {
  final TokenService _tokenService = TokenService();

  Future<void> login(String user, String senha) async {
    final json = {"email": user, "senha": senha};

    HttpRequest request =
        await HttpRequest.create().endPoint("auth").parseBody(json).post();

    dynamic body = request.parseResponse();

    await autenticar(body);
  }

  Future<void> autenticar(dynamic body) async {
    String token = body['token'];
    if (token.isEmpty) throw Exception("Token não obtido na autenticação.");
    await _tokenService.setToken(token);

    Usuario? usuario = _tokenService.getUsuario();
    if (usuario == null) {
      throw Exception("Usuário não encontrado no token ao autenticar.");
    }
  }

  Future<void> logout() async {
    _tokenService.removeToken();
  }
}

import 'dart:convert' show json, base64, ascii;

import 'package:app_mobile/http/http_request.dart';
import 'package:app_mobile/messages/snack_messages.dart';
import 'package:app_mobile/model/usuario_model.dart';
import 'package:app_mobile/services/storage_service.dart';
import 'package:app_mobile/utils/globals.dart';
import 'package:app_mobile/widgets/progress.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  final String message;
  const LoginScreen({Key? key, required this.message}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _tedServidor = TextEditingController();
  final _tedLogin = TextEditingController();
  final _tedSenha = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final StorageService _storageService = StorageService();
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
          backgroundColor: Colors.white,
          key: _scaffoldKey,
          body: Center(
              child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Login',
                        style: TextStyle(fontSize: 32.0, color: Colors.blue)),
                    Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
                        child: TextFormField(
                          controller: _tedServidor,
                          keyboardType: TextInputType.text,
                          style: TextStyle(fontSize: 18.0),
                          obscureText: false,
                          decoration: InputDecoration(
                            alignLabelWithHint: false,
                            icon: Icon(
                              FontAwesomeIcons.server,
                              size: 25.0,
                            ),
                            labelText: 'Servidor / API',
                            hintText: '',
                            contentPadding: EdgeInsets.only(
                              left: 5,
                              right: 5,
                              bottom: 5,
                              top: 5,
                            ),
                          ),
                        )),
                    Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
                        child: TextFormField(
                          controller: _tedLogin,
                          keyboardType: TextInputType.text,
                          style: TextStyle(fontSize: 18.0),
                          obscureText: false,
                          decoration: InputDecoration(
                            alignLabelWithHint: false,
                            icon: Icon(
                              FontAwesomeIcons.user,
                              size: 25.0,
                            ),
                            labelText: 'E-mail',
                            hintText: '',
                            contentPadding: EdgeInsets.only(
                              left: 5,
                              right: 5,
                              bottom: 5,
                              top: 5,
                            ),
                          ),
                        )),
                    Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
                        child: TextFormField(
                          controller: _tedSenha,
                          keyboardType: TextInputType.text,
                          style: TextStyle(fontSize: 18.0),
                          obscureText: true,
                          decoration: InputDecoration(
                            alignLabelWithHint: false,
                            icon: Icon(
                              FontAwesomeIcons.lock,
                              size: 25.0,
                            ),
                            labelText: 'Senha',
                            hintText: '',
                            contentPadding: EdgeInsets.only(
                              left: 5,
                              right: 5,
                              bottom: 5,
                              top: 5,
                            ),
                          ),
                        )),
                    Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
                        child: Visibility(
                          visible: !_carregando,
                          child: SizedBox(
                            width: double.maxFinite,
                            child: ElevatedButton(
                              child: Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.white),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.blue),
                              ),
                              onPressed: () => _onClickLogin(context),
                            ),
                          ),
                        )),
                    Visibility(
                        visible: _carregando,
                        child: Progress(
                          message: '',
                        ))
                  ],
                )),
          ))),
    );
  }

  _load() async {
    String servidor =
        await _storageService.getItem(StorageService.KEY_SERVIDOR);
    _tedServidor.text = servidor;
  }

  _onClickLogin(BuildContext context) async {
    try {
      if (_tedServidor.text.isEmpty) {
        SnackMessages.of(context)
            .text('Não foi informado o caminho para o servidor/API.')
            .warning();
        return;
      }

      if (_tedLogin.text.isEmpty) {
        SnackMessages.of(context).text('Não foi informado o e-mail.').warning();
        return;
      }

      if (_tedSenha.text.isEmpty) {
        SnackMessages.of(context).text('Não foi informada a senha.').warning();
        return;
      }

      await _storageService.setItem(
          StorageService.KEY_SERVIDOR, _tedServidor.text);
      Globals.shared.servidor = _tedServidor.text;

      setState(() {
        _carregando = true;
      });

      _login(_tedLogin.text, _tedSenha.text)
          .then((body) => _logar(body))
          .catchError((error) =>
              SnackMessages.of(context).text(error.toString()).error())
          .whenComplete(() => setState(() {
                _carregando = false;
              }));
    } catch (err) {
      SnackMessages.of(context).text(err.toString()).error();
    }
  }

  Future<dynamic> _login(String user, String senha) async {
    final json = {"email": user, "senha": senha};

    HttpRequest request =
        await HttpRequest.create().endPoint("auth").parseBody(json).post();

    return request.parseResponse();
  }

  _logar(dynamic body) {
    _processToken(body);
  }

  _processToken(dynamic body) {
    String token = body['token'];
    if (token.isNotEmpty) {
      var jwt = token.split(".");
      if (jwt.length != 3) {
      } else {
        var payload =
            json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));
        if (DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000)
            .isAfter(DateTime.now())) {
          //home

          dynamic user = json.decode(payload['sub']);
          Globals.shared.usuario = Usuario.fromJson(user);

          Globals.shared.token = token;
          Globals.shared.globalContext = context;
          Navigator.pushNamed(context, '/home');
        } else {
          //login
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  const LoginScreen(message: "Token de acesso inválido.")));
        }
      }
    } else {
      //login
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              const LoginScreen(message: "Token de acesso inválido.")));
    }
  }
}

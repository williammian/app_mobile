import 'package:app_mobile/exceptions/validacao_exception.dart';
import 'package:app_mobile/messages/snack_messages.dart';
import 'package:app_mobile/services/auth_service.dart';
import 'package:app_mobile/services/servidor_service.dart';
import 'package:app_mobile/utils/error_dialog.dart';
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

  final ServidorService _servidorService = ServidorService();
  final AuthService _authService = AuthService();

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
    String servidor = await _servidorService.getServidorAsync();
    _tedServidor.text = servidor;
  }

  _onClickLogin(BuildContext context) async {
    try {
      if (_tedServidor.text.isEmpty) {
        throw const ValidacaoException(
            "Não foi informado o caminho para o servidor/API.");
      }

      if (_tedLogin.text.isEmpty) {
        throw const ValidacaoException("Não foi informado o e-mail.");
      }

      if (_tedSenha.text.isEmpty) {
        throw const ValidacaoException("Não foi informada a senha.");
      }

      await _servidorService.setServidor(_tedServidor.text);

      setState(() {
        _carregando = true;
      });

      _authService
          .login(_tedLogin.text, _tedSenha.text)
          .then((value) => _navegarParaHome())
          .catchError((error) => ErrorDialog.of(context, error).defaultCatch())
          .whenComplete(() => setState(() {
                _carregando = false;
              }));
    } catch (err) {
      ErrorDialog.of(context, err).defaultCatch();
    }
  }

  _navegarParaHome() {
    Navigator.pushNamed(context, '/home');
  }
}

import 'package:app_mobile/services/auth_service.dart';
import 'package:app_mobile/services/token_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final TokenService _tokenService = TokenService();

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: <Widget>[
        SizedBox(
          height: 90.0,
          child: DrawerHeader(
              child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 8.0),
                child: Row(
                  children: [
                    Icon(FontAwesomeIcons.userCircle,
                        size: 18.0, color: Colors.blue),
                    Padding(
                      padding: EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                      child: Text(
                        _tokenService.getUsuario()!.nome,
                        style: TextStyle(color: Colors.blue, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.home),
          title: Text('Início'),
          onTap: () => Scaffold.of(context).openEndDrawer(),
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.boxesStacked),
          title: Text('Itens'),
          onTap: () => {},
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.powerOff),
          title: Text('Sair'),
          onTap: () => _onClickSair(context),
        ),
      ]),
    );
  }

  _onClickSair(BuildContext context) async {
    AuthService authService = AuthService();
    await authService.logout();
    Scaffold.of(context).openEndDrawer();
    Navigator.pushNamed(context, '/login');
  }
}

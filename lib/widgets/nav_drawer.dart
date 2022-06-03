import 'package:app_mobile/services/auth_service.dart';
import 'package:app_mobile/services/token_service.dart';
import 'package:app_mobile/utils/error_dialog.dart';
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
                padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 8.0),
                child: Row(
                  children: [
                    const Icon(FontAwesomeIcons.user,
                        size: 18.0, color: Colors.blue),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                      child: Text(
                        _tokenService.getUsuario()!.nome,
                        style:
                            const TextStyle(color: Colors.blue, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
        ),
        ListTile(
          leading: const Icon(FontAwesomeIcons.house),
          title: const Text('Início'),
          onTap: () => _onClickInicio(context),
        ),
        ListTile(
          leading: const Icon(FontAwesomeIcons.boxesStacked),
          title: const Text('Itens'),
          onTap: () => _onClickItens(context),
        ),
        ListTile(
          leading: const Icon(FontAwesomeIcons.powerOff),
          title: const Text('Sair'),
          onTap: () => _onClickSair(context),
        ),
      ]),
    );
  }

  _onClickInicio(BuildContext context) async {
    try {
      Scaffold.of(context).openEndDrawer();
    } catch (err) {
      ErrorDialog.of(context, err).defaultCatch();
    }
  }

  _onClickItens(BuildContext context) async {
    try {
      Navigator.pushNamed(context, '/itens');
    } catch (err) {
      ErrorDialog.of(context, err).defaultCatch();
    }
  }

  _onClickSair(BuildContext context) async {
    try {
      AuthService authService = AuthService();
      await authService.logout();
      Scaffold.of(context).openEndDrawer();
      Navigator.pushNamed(context, '/login');
    } catch (err) {
      ErrorDialog.of(context, err).defaultCatch();
    }
  }

  // teste(BuildContext context) {
  //   try {
  // ItemService itemService = ItemService();

  // itemService
  //     .excluir(16)
  //     .then((value) => print('item excluído'))
  //     .catchError((error) async {
  //   ErrorDialog.of(context, error).defaultCatch();
  // });

  // Item item =
  //     Item(16, 1, '997', 'Teste Y', DateTime.now(), true, 'B', 2.77);
  // itemService
  //     .atualizar(item)
  //     .then((itemAtualizado) => print(itemAtualizado))
  //     .catchError((error) async {
  //   ErrorDialog.of(context, error).defaultCatch();
  // });

  // Item item =
  //     Item(null, 1, '997', 'Teste X', DateTime.now(), true, 'A', 2.66);
  // itemService
  //     .adicionar(item)
  //     .then((itemAdicionado) => print(itemAdicionado))
  //     .catchError((error) async {
  //   ErrorDialog.of(context, error).defaultCatch();
  // });

  // itemService.listar(ItemFiltro()).then((page) {
  //   int totalPages = page['totalPages'];
  //   print('totalPages: $totalPages');
  //   int number = page['number'];
  //   print('number: $number');
  //   List<dynamic> content = page['content'];
  //   List<Item> itens =
  //       content.map((dynamic json) => Item.fromJson(json)).toList();
  //   for (Item item in itens) {
  //     print(item.toString());
  //   }
  // }).catchError((error) async {
  //   ErrorDialog.of(context, error).defaultCatch();
  // });
  //   } catch (err) {
  //     ErrorDialog.of(context, err).defaultCatch();
  //   }
  // }
}

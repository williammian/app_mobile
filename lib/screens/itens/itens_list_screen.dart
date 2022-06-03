import 'package:app_mobile/messages/confirm_messages.dart';
import 'package:app_mobile/messages/snack_messages.dart';
import 'package:app_mobile/models/item_model.dart';
import 'package:app_mobile/services/item_service.dart';
import 'package:app_mobile/utils/error_dialog.dart';
import 'package:app_mobile/widgets/progress.dart';
import 'package:flutter/material.dart';

class ItensListScreen extends StatefulWidget {
  const ItensListScreen({Key? key}) : super(key: key);

  @override
  State<ItensListScreen> createState() => _ItensListScreenState();
}

class _ItensListScreenState extends State<ItensListScreen> {
  final ItemService _itemService = ItemService();
  final ItemFiltro _itemFiltro = ItemFiltro();

  final TextEditingController _tedCodigoDescricao = TextEditingController();

  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;

  late List<Item> _itens;

  void _firstLoad(bool inLoad) async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      String codigoDescricao = '';
      if (_tedCodigoDescricao.text.isNotEmpty) {
        codigoDescricao = _tedCodigoDescricao.text;
      }
      _itemFiltro.codigoDescricao = codigoDescricao;
      _itemFiltro.page = 0;

      dynamic res = await _itemService.listar(_itemFiltro);
      List<dynamic> content = res['content'];

      setState(() {
        _itens = content.map((dynamic json) => Item.fromJson(json)).toList();
      });
    } catch (err) {
      if (inLoad) {
        print(err.toString());
      } else {
        ErrorDialog.of(context, err).defaultCatch();
      }
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true;
      });
      _itemFiltro.page += 1;
      try {
        String codigoDescricao = '';
        if (_tedCodigoDescricao.text.isNotEmpty) {
          codigoDescricao = _tedCodigoDescricao.text;
        }
        _itemFiltro.codigoDescricao = codigoDescricao;

        dynamic res = await _itemService.listar(_itemFiltro);
        List<dynamic> content = res['content'];

        if (content.isNotEmpty) {
          setState(() {
            List<Item> itensPage =
                content.map((dynamic json) => Item.fromJson(json)).toList();
            _itens.addAll(itensPage);
          });
        } else {
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        ErrorDialog.of(context, err).defaultCatch();
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _firstLoad(true);
    _controller = ScrollController()..addListener(_loadMore);
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Itens'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: () => _adicionar())
        ],
      ),
      body: _isFirstLoadRunning
          ? Progress()
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) {
                      _hasNextPage = true;
                      _firstLoad(false);
                    },
                    controller: _tedCodigoDescricao,
                    decoration: InputDecoration(
                      labelText: 'Código ou Descrição',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          _hasNextPage = true;
                          _firstLoad(false);
                        },
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _hasNextPage = true;
                        _itens = [];
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _controller,
                    itemCount: _itens.length,
                    itemBuilder: (_, index) => Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 10),
                      child: ListTile(
                        title: Text(_itens[index].codigo),
                        subtitle: Text(_itens[index].descricao),
                        trailing: const Icon(Icons.edit),
                        onTap: () => _alterar(_itens[index]),
                        onLongPress: () => _excluir(_itens[index]),
                      ),
                    ),
                  ),
                ),
                if (_isLoadMoreRunning == true) Progress(),
                if (_hasNextPage == false)
                  Container(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    color: Colors.amber,
                    child: const Center(
                      child: Text('Você buscou todo o conteúdo'),
                    ),
                  ),
              ],
            ),
    );
  }

  void _adicionar() {
    try {
      //adicionar
      SnackMessages.of(context).text("adicionar").show();
    } catch (err) {
      ErrorDialog.of(context, err).defaultCatch();
    }
  }

  void _alterar(Item item) {
    try {
      //alterar
      SnackMessages.of(context).text("alterar").show();
    } catch (err) {
      ErrorDialog.of(context, err).defaultCatch();
    }
  }

  void _excluir(Item item) {
    try {
      String codigo = item.codigo;
      String descricao = item.descricao;
      ConfirmMessages.of(context)
          .title("Exclusão de Item")
          .text("Confirma a exclusão do item $codigo $descricao ?")
          .show()
          .then((value) {
        if (value) {
          setState(() {
            _isFirstLoadRunning = true;
          });
          _itemService.excluir(item.id).whenComplete(() {
            setState(() {
              for (Item itemLista in _itens) {
                if (itemLista.id == item.id) {
                  _itens.remove(itemLista);
                  break;
                }
              }
              _isFirstLoadRunning = false;
            });
            SnackMessages.of(context)
                .text("Item excluído com sucesso")
                .success();
          }).catchError(
              (error) => ErrorDialog.of(context, error).defaultCatch());
        }
      });
    } catch (err) {
      ErrorDialog.of(context, err).defaultCatch();
    }
  }
}

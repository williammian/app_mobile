import 'package:app_mobile/messages/alert_messages.dart';
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
  ItemService itemService = ItemService();

  int _page = 0;
  int _size = 20;

  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;

  late List<Item> _itens;

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      ItemFiltro itemFiltro = ItemFiltro();
      itemFiltro.page = _page;
      itemFiltro.size = _size;
      dynamic res = await itemService.listar(itemFiltro);
      List<dynamic> content = res['content'];

      setState(() {
        _itens = content.map((dynamic json) => Item.fromJson(json)).toList();
      });
    } catch (err) {
      print(err.toString());
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
      _page += 1;
      try {
        ItemFiltro itemFiltro = ItemFiltro();
        itemFiltro.page = _page;
        itemFiltro.size = _size;
        dynamic res = await itemService.listar(itemFiltro);
        List<dynamic> content = res['content'];

        if (content.isNotEmpty) {
          setState(() {
            _itens =
                content.map((dynamic json) => Item.fromJson(json)).toList();
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
    _firstLoad();
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
      ),
      body: _isFirstLoadRunning
          ? Progress()
          : Column(
              children: [
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
}

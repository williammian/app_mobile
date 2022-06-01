import 'dart:convert';

import 'package:app_mobile/http/http_request.dart';
import 'package:app_mobile/models/item_model.dart';

class ItemService {
  final String urn = "itens";

  Future<dynamic> listar(ItemFiltro itemFiltro) async {
    String url = urn + "?codigoDescricao=" + itemFiltro.codigoDescricao;
    url = url + "&page=" + itemFiltro.page.toString();
    url = url + "&size=" + itemFiltro.size.toString();
    HttpRequest request = await HttpRequest.create().endPoint(url).get();
    dynamic page = request.parseResponse();
    return page;
  }

  Future<Item> adicionar(Item item) async {
    HttpRequest request =
        await HttpRequest.create().endPoint(urn).parseBody(item).post();
    dynamic json = request.parseResponse();
    Item itemAdicionado = Item.fromJson(json);
    return itemAdicionado;
  }

  Future<Item> atualizar(Item item) async {
    HttpRequest request = await HttpRequest.create()
        .endPoint(urn + "/" + item.id.toString())
        .parseBody(item)
        .put();
    dynamic json = request.parseResponse();
    Item itemAtualizado = Item.fromJson(json);
    return itemAtualizado;
  }

  Future<void> excluir(int id) async {
    await HttpRequest.create().endPoint(urn + "/" + id.toString()).delete();
  }
}

class ItemFiltro {
  String codigoDescricao = "";
  int page = 0;
  int size = 20;
}

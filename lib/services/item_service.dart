import 'package:app_mobile/http/http_request.dart';

class ItemService {
  final String urn = "itens";

  Future<dynamic> listar(ItemFiltro itemFiltro) async {
    String url = urn + "?codigoDescricao=" + itemFiltro.codigoDescricao;
    url = url + "&page=" + itemFiltro.page.toString();
    url = url + "&size=" + itemFiltro.size.toString();
    HttpRequest request = await HttpRequest.create().endPoint(url).get();
    dynamic body = request.parseResponse();
    return body;
  }

  Future<dynamic> adicionar(dynamic item) async {
    HttpRequest request =
        await HttpRequest.create().endPoint(urn).parseBody(item).post();
    dynamic body = request.parseResponse();
    return body;
  }

  Future<dynamic> atualizar(dynamic item) async {
    HttpRequest request = await HttpRequest.create()
        .endPoint(urn + "/" + item['id'])
        .parseBody(item)
        .put();
    dynamic body = request.parseResponse();
    return body;
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

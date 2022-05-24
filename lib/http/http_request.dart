import 'dart:convert';
import 'package:app_mobile/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:app_mobile/utils/globals.dart';

class HttpRequest {
  String _server = Globals.shared.servidor;
  late String _endPoint;
  late String _body;
  Map<String, String> _headers = {"Content-type": "application/json"};
  Encoding _encoding = utf8;
  int _timeOut = 60;
  late http.Response response;

  HttpRequest();

  static HttpRequest create() {
    HttpRequest request = HttpRequest();
    if (Globals.shared.token.isNotEmpty) {
      request._headers["Authorization"] = "Bearer " + Globals.shared.token;
    }
    return request;
  }

  HttpRequest server(String server) {
    _server = server;
    return this;
  }

  HttpRequest endPoint(String url) {
    if (!url.startsWith("/")) url = "/" + url;
    _endPoint = _server + url;
    return this;
  }

  HttpRequest parseBody(Object obj) {
    _body = jsonEncode(obj);
    return this;
  }

  HttpRequest setHeaders(Map<String, String> headers) {
    _headers = headers;
    return this;
  }

  HttpRequest setEncoding(Encoding encoding) {
    _encoding = encoding;
    return this;
  }

  HttpRequest setTimeOut(int timeOut) {
    _timeOut = timeOut;
    return this;
  }

  Future<HttpRequest> post() async {
    response = await http
        .post(Uri.parse(_endPoint),
            headers: _headers, body: _body, encoding: _encoding)
        .timeout(Duration(seconds: _timeOut),
            onTimeout: () => throw http.ClientException(
                "Tempo de processamento esgotado ao se conectar ao servidor/API"))
        .onError((error, stackTrace) =>
            throw http.ClientException("Erro ao se conectar ao servidor/API"));

    _processResponse();
    return this;
  }

  Future<HttpRequest> get() async {
    response = await http
        .get(Uri.parse(_endPoint), headers: _headers)
        .timeout(Duration(seconds: _timeOut),
            onTimeout: () => throw Exception(
                "Tempo de processamento esgotado ao se conectar ao servidor/API"))
        .onError((error, stackTrace) =>
            throw http.ClientException("Erro ao se conectar ao servidor/API"));

    _processResponse();
    return this;
  }

  Future<HttpRequest> put() async {
    response = await http
        .put(Uri.parse(_endPoint),
            headers: _headers, body: _body, encoding: _encoding)
        .timeout(Duration(seconds: _timeOut),
            onTimeout: () => throw http.ClientException(
                "Tempo de processamento esgotado ao se conectar ao servidor/API"))
        .onError((error, stackTrace) =>
            throw http.ClientException("Erro ao se conectar ao servidor/API"));

    _processResponse();
    return this;
  }

  Future<HttpRequest> patch() async {
    response = await http
        .patch(Uri.parse(_endPoint),
            headers: _headers, body: _body, encoding: _encoding)
        .timeout(Duration(seconds: _timeOut),
            onTimeout: () => throw http.ClientException(
                "Tempo de processamento esgotado ao se conectar ao servidor/API"))
        .onError((error, stackTrace) =>
            throw http.ClientException("Erro ao se conectar ao servidor/API"));

    _processResponse();
    return this;
  }

  Future<HttpRequest> delete() async {
    response = await http
        .delete(Uri.parse(_endPoint), headers: _headers)
        .timeout(Duration(seconds: _timeOut),
            onTimeout: () => throw http.ClientException(
                "Tempo de processamento esgotado ao se conectar ao servidor/API"))
        .onError((error, stackTrace) =>
            throw http.ClientException("Erro se conectar ao servidor/API"));

    _processResponse();
    return this;
  }

  void _processResponse() {
    if (response.statusCode >= 500) {
      throw Exception("Erro ao efetuar processamento no servidor/API.");
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      Navigator.of(Globals.shared.globalContext).push(MaterialPageRoute(
          builder: (context) => const LoginScreen(
              message:
                  "Você não tem permissão para executar esta ação ou token de acesso inválido.")));
    } else if (response.statusCode < 200 || response.statusCode > 299) {
      String msg = "Ocorreu um erro ao processar a sua solicitação.";

      dynamic retorno = response.bodyBytes.isEmpty
          ? null
          : jsonDecode(utf8.decode(response.bodyBytes));

      try {
        msg = retorno[0]['mensagemUsuario'];
      } catch (err) {}

      throw http.ClientException(msg);
    }
  }

  dynamic parseResponse() {
    try {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } catch (err) {
      return utf8.decode(response.bodyBytes);
    }
  }
}

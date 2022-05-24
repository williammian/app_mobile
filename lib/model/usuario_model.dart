import 'package:app_mobile/model/perfil_model.dart';

class Usuario {
  int id;
  String nome;
  String email;
  List<Perfil> perfis;

  Usuario(this.id, this.nome, this.email, this.perfis);

  Usuario.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nome = json['nome'],
        email = json['email'],
        perfis = jsonToPerfis(json['perfis']);

  Map<String, dynamic> toJson() => {'id': id, 'nome': nome, 'email': email};

  static jsonToPerfis(json) {
    List<Perfil> perfisList = [];
    if (json == null) return perfisList;
    json.forEach((element) {
      perfisList.add(Perfil.fromJson(element));
    });
    return perfisList;
  }
}

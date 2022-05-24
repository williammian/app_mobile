class Perfil {
  int id;
  String nome;

  Perfil(this.id, this.nome);

  Perfil.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nome = json['nome'];

  Map<String, dynamic> toJson() => {'id': id, 'nome': nome};
}

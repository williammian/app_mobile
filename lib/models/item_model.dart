import 'package:intl/intl.dart';

class Item {
  int? id;
  int tipo;
  String codigo;
  String descricao;
  DateTime dataCadastro;
  bool ativo;
  String abc;
  num preco;

  Item(this.id, this.tipo, this.codigo, this.descricao, this.dataCadastro,
      this.ativo, this.abc, this.preco);

  Item.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        tipo = json['tipo'],
        codigo = json['codigo'],
        descricao = json['descricao'],
        dataCadastro = DateTime.parse(json['dataCadastro']),
        ativo = json['ativo'],
        abc = json['abc'],
        preco = json['preco'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'tipo': tipo,
        'codigo': codigo,
        'descricao': descricao,
        'dataCadastro': DateFormat('yyyy-MM-dd').format(dataCadastro),
        'ativo': ativo,
        'abc': abc,
        'preco': preco
      };

  @override
  String toString() {
    return 'Item{id: $id, tipo: $tipo, codigo: $codigo, descricao: $descricao, dataCadastro: $dataCadastro, ativo: $ativo, abc: $abc, preco: $preco}';
  }

  static Item create() {
    return Item(null, 0, "", "", DateTime.now(), true, "A", 0.00);
  }
}

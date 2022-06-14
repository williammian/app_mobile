import 'package:app_mobile/exceptions/validacao_exception.dart';
import 'package:app_mobile/models/item_model.dart';
import 'package:app_mobile/services/item_service.dart';
import 'package:app_mobile/utils/error_dialog.dart';
import 'package:app_mobile/utils/utils.dart';
import 'package:app_mobile/widgets/progress.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItensCadScreen extends StatefulWidget {
  ItensCadScreen({Key? key, required this.id}) : super(key: key);

  int? id;

  @override
  State<ItensCadScreen> createState() => _ItensCadScreenState(id);
}

class _ItensCadScreenState extends State<ItensCadScreen> {
  final ItemService _itemService = ItemService();
  int? id;
  late Item item;

  int _tedTipo = 0;
  final TextEditingController _tedCodigo = TextEditingController();
  final TextEditingController _tedDescricao = TextEditingController();
  DateTime _tedDataCadastro = DateTime.now();
  bool _tedAtivo = true;
  String? _tedABC;
  final TextEditingController _tedPreco = TextEditingController();

  bool _carregando = false;

  _ItensCadScreenState(this.id);

  @override
  initState() {
    super.initState();
    _carregarItem(id);
  }

  Future<void> _carregarItem(int? id) async {
    if (id == null) {
      setState(() {
        item = Item.create();
        _exibirRegistro();
        _carregando = false;
      });
    } else {
      setState(() {
        _carregando = true;
      });
      await _itemService.buscar(id).then((value) {
        setState(() {
          item = value;
          _exibirRegistro();
          _carregando = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isNew = id == null;
    String tituloForm = isNew ? "Novo Item" : "Alteração de Item";

    return Scaffold(
        appBar: AppBar(
          title: Text(tituloForm),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () => _gravarRegistro(isNew),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
                  child: Progress(),
                ),
                visible: _carregando,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<int>(
                  value: _tedTipo,
                  decoration: const InputDecoration(labelText: 'Tipo'),
                  items: dropdownItemsTipos,
                  onChanged: (value) {
                    setState(() {
                      _tedTipo = value ?? 0;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _tedCodigo,
                  decoration: const InputDecoration(labelText: 'Código'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _tedDescricao,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DateTimeField(
                  initialValue: _tedDataCadastro,
                  decoration:
                      const InputDecoration(labelText: 'Data do Cadastro'),
                  format: DateFormat("dd/MM/yyyy"),
                  onShowPicker: (context, currentValue) {
                    return showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100));
                  },
                  onChanged: (value) {
                    _tedDataCadastro = value!;
                  },
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: _tedAtivo,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _tedAtivo = newValue!;
                        item.ativo = newValue;
                      });
                    },
                  ),
                  const Text('Ativo')
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  value: _tedABC,
                  decoration: const InputDecoration(labelText: 'Classificação'),
                  items: dropdownItemsABC,
                  onChanged: (String? newValue) {
                    setState(() {
                      _tedABC = newValue!;
                      item.abc = newValue;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _tedPreco,
                  decoration: const InputDecoration(labelText: 'Preço'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
            ],
          ),
        ));
  }

  List<DropdownMenuItem<int>> get dropdownItemsTipos {
    List<DropdownMenuItem<int>> menuItems = [
      const DropdownMenuItem(child: Text("Material"), value: 0),
      const DropdownMenuItem(child: Text("Produto"), value: 1),
      const DropdownMenuItem(child: Text("Mercadoria"), value: 2),
      const DropdownMenuItem(child: Text("Serviço"), value: 3),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<String>> get dropdownItemsABC {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(child: Text("A"), value: "A"),
      const DropdownMenuItem(child: Text("B"), value: "B"),
      const DropdownMenuItem(child: Text("C"), value: "C"),
    ];
    return menuItems;
  }

  _exibirRegistro() {
    _tedTipo = item.tipo;
    _tedCodigo.text = item.codigo;
    _tedDescricao.text = item.descricao;
    _tedDataCadastro = item.dataCadastro;
    _tedAtivo = item.ativo;
    _tedABC = item.abc;
    _tedPreco.text = Utils.formatCurrency(item.preco);
  }

  _comporRegistro() {
    item.tipo = _tedTipo;
    item.codigo = _tedCodigo.text;
    item.descricao = _tedDescricao.text;
    item.dataCadastro = _tedDataCadastro;
    item.ativo = _tedAtivo;
    item.abc = _tedABC!;
    item.preco = Utils.parseCurrency(_tedPreco.text);
  }

  _gravarRegistro(bool isNew) {
    try {
      setState(() {
        _carregando = true;
      });
      _comporRegistro();
      if (isNew) {
        _itemService
            .adicionar(item)
            .then((itemAdicionado) => Navigator.of(context).pop(1))
            .catchError((error) async {
          ErrorDialog.of(context, error).defaultCatch();
        }).whenComplete(() {
          setState(() {
            _carregando = false;
          });
        });
      } else {
        _itemService
            .atualizar(item)
            .then((itemAtualizado) => Navigator.of(context).pop(2))
            .catchError((error) async {
          ErrorDialog.of(context, error).defaultCatch();
        }).whenComplete(() {
          setState(() {
            _carregando = false;
          });
        });
      }
    } catch (error) {
      setState(() {
        _carregando = false;
      });
      ErrorDialog.of(context, error).defaultCatch();
    }
  }
}

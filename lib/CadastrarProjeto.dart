import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import 'BancoDados.dart';

class CadastroProjeto extends StatefulWidget {
  @override
  State<CadastroProjeto> createState() => _CadastroProjetoState();
}

class _CadastroProjetoState extends State<CadastroProjeto> {
  DateTime? dataInicial;
  DateTime? dataFinal;

  Banco _banco = Banco();
  List<Map<String, dynamic>> _pesquisadores = [];
  String? _pesquisadorSelecionado;
  List<String> _selectedResearcherIds = [];

  Future<void> _dataInicial(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dataInicial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != dataInicial) {
      setState(() {
        dataInicial = picked;
      });
    }
  }

  Future<void> _dataFinal(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      locale: Locale('pt', 'BR'),
      context: context,
      initialDate: dataFinal,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != dataFinal) {
      setState(() {
        dataFinal = picked;
      });
    }
  }

  Future<void> _carregarPesquisadores() async {
    try {
      List<Map<String, dynamic>> pesquisadores =
          await _banco.listarPesquisadores();
      setState(() {
        _pesquisadores = pesquisadores;
      });
    } catch (e) {
      // Trate qualquer erro aqui
      print('Erro ao carregar pesquisadores: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _carregarPesquisadores(); // Carregar a lista de pesquisadores ao iniciar o estado
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Projeto'),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xff004c9e),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
                labelText: 'Título',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
                labelText: 'Descrição',
              ),
              maxLines: 2,
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => _dataInicial(context),
                      child: Text(
                        dataInicial == null
                            ? 'Data Inicial'
                            : 'Inicio: ${dataInicial?.day}/${dataInicial?.month}/${dataInicial?.year}',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => _dataFinal(context),
                      child: Text(dataFinal == null
                          ? 'Data Final'
                          : 'Fim: ${dataFinal?.day}/${dataFinal?.month}/${dataFinal?.year}'),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 300,
              child: MultiSelectDialogField(
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade100),
                searchable: true,
                items: _pesquisadores
                    .map((pesquisador) => MultiSelectItem<String>(
                        pesquisador['nome'], pesquisador['nome']))
                    .toList(),
                onConfirm: (values) {
                  setState(() {
                    _selectedResearcherIds = values;
                  });
                },
                title: Text("Integrantes"),
                buttonText: Text("Integrantes"),
                selectedColor: Colors.blue,
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:imcflutter/Ajustes.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'BancoDados.dart';

class CadastroPesquisador extends StatefulWidget {
  @override
  _CadastroPesquisadorState createState() => _CadastroPesquisadorState();
}

AjustesState ajustesState = AjustesState();

class _CadastroPesquisadorState extends State<CadastroPesquisador> {
  var maskFormatter = MaskTextInputFormatter(mask: '###.###.###-##');

  Banco banco = Banco();

  @override
  void initState() {
    super.initState();
  }

  String _tipoSelecionado = 'Escolha';
  String _areaSelecionada = 'Escolha';

  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color(0xff004c9e),
          title: Text('Cadastrar Pesquisador'),
          foregroundColor: Colors.white,
          actions: [
            IconButton(
                onPressed: () async {
                  await banco.adicionarPesquisador(
                    _nomeController.text,
                    _cpfController.text,
                    _tipoSelecionado,
                    _areaSelecionada,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Pesquisador cadastrado com sucesso!')),
                  );
                  Navigator.pop(context, true);
                },
                icon: Icon(Icons.save))
          ]),
      body: Padding(
        padding: EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nomeController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
                labelText: 'Nome',
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _cpfController,
              keyboardType: TextInputType.number,
              inputFormatters: [maskFormatter],
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
                labelText: 'CPF',
              ),
            ),
            SizedBox(height: 20.0),
            DropdownButtonFormField<String>(
              value: _tipoSelecionado,
              borderRadius: BorderRadius.circular(20),
              onChanged: (String? newValue) {
                setState(() {
                  _tipoSelecionado = newValue!;
                });
              },
              items: <String>['Escolha', 'Aluno', 'Professor', 'Funcionário']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: 'Cargo',
              ),
            ),
            SizedBox(height: 20.0),
            DropdownButtonFormField<String>(
              value: _areaSelecionada,
              borderRadius: BorderRadius.circular(20),
              onChanged: (String? newValue) {
                setState(() {
                  _areaSelecionada = newValue!;
                });
              },
              items: <String>[
                'Escolha',
                'Ciência da Computação',
                'Astronomia',
                'Física',
                'Direito'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: 'Formação',
              ),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}

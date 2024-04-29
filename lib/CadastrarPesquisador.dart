import 'package:flutter/material.dart';
import 'package:imcflutter/Ajustes.dart';

import 'BancoDados.dart';

class CadastroPesquisador extends StatefulWidget {
  @override
  _CadastroPesquisadorState createState() => _CadastroPesquisadorState();
}
AjustesState ajustesState = AjustesState();
class _CadastroPesquisadorState extends State<CadastroPesquisador> {

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
        title: Text('Cadastrar Pesquisador'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nomeController,
              decoration: InputDecoration(
                labelText: 'Nome',
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _cpfController,
              keyboardType: TextInputType.number,
              maxLength: 11,
              decoration: InputDecoration(
                labelText: 'CPF',
              ),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: _tipoSelecionado,
              onChanged: (String? newValue) {
                setState(() {
                  _tipoSelecionado = newValue!;
                });
              },
              items: <String>['Escolha','Aluno', 'Professor', 'Funcionário']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Tipo',
              ),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: _areaSelecionada,
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
                labelText: 'Área do Conhecimento',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await banco.adicionarPesquisador(
                  _nomeController.text,
                  _cpfController.text,
                  _tipoSelecionado,
                  _areaSelecionada,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Pesquisador cadastrado com sucesso!')),
                );
                Navigator.pop(context);
              },
              child: Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}

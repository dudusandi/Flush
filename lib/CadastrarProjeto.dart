import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

class CadastroProjeto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Projeto'),
      ),
      body: Center(
        child: Text(
          'Formulário de Cadastro de Projeto Aqui',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
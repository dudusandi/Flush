import 'package:flutter/material.dart';

class CadastroProjeto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Projeto'),
      ),
      body: const Column(
        children: [
          TextField(
            decoration: InputDecoration(labelText: "Titulo"),
          ),
          TextField(
            decoration: InputDecoration(
              labelText: "Descrição",
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}

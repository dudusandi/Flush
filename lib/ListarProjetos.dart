import 'package:flush/CadastrarProjeto.dart';
import 'package:flutter/material.dart';

class ProjetosListScreen extends StatefulWidget {
  @override
  State<ProjetosListScreen> createState() => _ProjetosListScreenState();
}

class _ProjetosListScreenState extends State<ProjetosListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Projetos'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/cadastro_projeto');
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Lista de Projetos aqui',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

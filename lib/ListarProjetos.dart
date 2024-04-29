import 'package:flutter/material.dart';



class ProjetosListScreen extends StatelessWidget {
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
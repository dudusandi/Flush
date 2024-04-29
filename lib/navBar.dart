import 'package:flutter/material.dart';
import 'package:imcflutter/Ajustes.dart';
import 'package:imcflutter/BancoDados.dart';
import 'CadastrarPesquisador.dart';
import 'CadastrarProjeto.dart';
import 'Home.dart';
import 'ListarProjetos.dart';
import 'DadosPesquisador.dart';
import 'ListarPesquisadores.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Pesquisadores',
      initialRoute: '/',
      routes: {
        '/': (context) => Inicio(),
        '/detalhes': (context) => DadosPesquisador(),
        '/cadastro': (context) => CadastroPesquisador(),
        '/cadastro_projeto': (context) => CadastroProjeto(),
        '/ajustes': (context) => Ajustes(),
      },
    );
  }
}


class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  int _selectedIndex = 0;

  Banco banco = Banco();

  @override
  void initState() {
    super.initState();
  }

  final List<Widget> _pages = [
    HomePage(),
    PesquisadoresListScreen(),
    ProjetosListScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () async {
            await Navigator.pushNamed(context, '/ajustes');

          }, icon: const Icon(Icons.settings), color: Colors.white,)
        ],
        backgroundColor: const Color(0xff004c9e),
        title: const Text('Flush'),

        foregroundColor: Colors.white,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Pesquisadores',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Projetos',
          ),
        ],
      ),
    );
  }
}










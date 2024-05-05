import 'package:flutter/material.dart';
import 'package:flush/ajustes.dart';
import 'package:flush/database.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'cadastro_pesquisador.dart';
import 'cadastro_projeto.dart';
import 'home.dart';
import 'lista_projeto.dart';
import 'dados_pesquisador.dart';
import 'lista_pesquisadores.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Pesquisadores',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'), // English, UK
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => Inicio(),
        '/detalhes': (context) => DadosPesquisador(),
        '/cadastro': (context) => CadastroPesquisador(),
        '/cadastro_projeto': (context) => CadastroProjeto(),
        '/ajustes': (context) => Ajustes(),
        '/listapesquisadores': (context) => PesquisadoresListScreen()
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
    ListaProjeto(),
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
          IconButton(
            onPressed: () async {
              await Navigator.pushNamed(context, '/ajustes');
            },
            icon: const Icon(Icons.settings),
            color: Colors.white,
          )
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

import 'package:flutter/material.dart';
import 'package:imcflutter/DadosPesquisador.dart';
import 'package:postgres/postgres.dart';
import 'package:imcflutter/BancoDados.dart';


class PesquisadoresListScreen extends StatefulWidget {
  @override
  PesquisadoresListScreenState createState() => PesquisadoresListScreenState();
}

class PesquisadoresListScreenState extends State<PesquisadoresListScreen> {

  Banco banco = Banco();

  List<Map<String, dynamic>> pesquisadores = [];

  bool _isLoading = true;

  @override
  void initState()   {
    super.initState();
    atualizarListaPesquisadores();
  }

  Future<void> atualizarListaPesquisadores() async {

    banco.conectarbanco();
    Connection conn = await banco.conectarbanco();

    setState(() {
      pesquisadores.clear();
      _isLoading = true;
    });

     final results = await conn.execute(
      Sql.named('SELECT * FROM pesquisadores ORDER BY nome'),
    );

    for (var row in results) {
      var pesquisador = {
        'nome': row[0],
        'areaConhecimento': row[2],
        'tipoConhecimento': row[3],
        'cpf': row[1]
      };
      pesquisadores.add(pesquisador);
    }

    await conn.close();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pesquisadores'),
        actions: [
          IconButton(
            onPressed: () {atualizarListaPesquisadores();},
            icon: Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () async {
              Navigator.pushNamed(context, '/cadastro').then((value) => setState(() {
                Future.delayed(Duration(milliseconds: 300), () {
                  atualizarListaPesquisadores();
                });
              }));
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: _isLoading ?
      Center(
        child: CircularProgressIndicator(),
      ) :
      ListView.builder(
        itemCount: pesquisadores.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(pesquisadores[index]['nome']),
            subtitle: Text(pesquisadores[index]['areaConhecimento']),
            onTap: () async {
              await Navigator.push(context, MaterialPageRoute(
                  builder: (context) => DadosPesquisador(),settings: RouteSettings(
                  arguments: pesquisadores[index])));
            },
          );
        },
      ),
    );
  }
}
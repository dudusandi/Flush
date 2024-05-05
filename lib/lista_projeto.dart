import 'package:flush/dados_projeto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:postgres/postgres.dart';

import 'database.dart';

class ListaProjeto extends StatefulWidget {
  const ListaProjeto({super.key});

  @override
  State<ListaProjeto> createState() => _ListaProjetoState();
}

class _ListaProjetoState extends State<ListaProjeto> {
  Banco banco = Banco();
  List<Map<String, dynamic>> pesquisas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    atualizarListaPesquisas();
  }

  Future<void> atualizarListaPesquisas() async {
    Connection conn = await banco.conectarbanco();

    setState(() {
      pesquisas.clear();
      _isLoading = true;
    });

    final results = await conn.execute(
      Sql.named('SELECT * FROM pesquisas ORDER BY titulo'),
    );

    for (var row in results) {
      var dataInicial = row[2];
      var dataFinal = row[3];

      var pesquisa = {
        'titulo': row[0],
        'descricao': row[1],
        'datainicial': DateFormat('dd/MM/yyyy').format(dataInicial as DateTime),
        'datafinal': DateFormat('dd/MM/yyyy').format(dataFinal as DateTime),
        'pesquisadores': row[4]
      };
      pesquisas.add(pesquisa);
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
        title: const Text('Pesquisadores'),
        actions: [
          IconButton(
            onPressed: () {
              atualizarListaPesquisas();
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () async {
              Navigator.pushNamed(context, '/cadastro_projeto').then(
                (value) => setState(() {
                  value == true ? atualizarListaPesquisas() : null;
                }),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: pesquisas.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(pesquisas[index]['titulo']),
                  subtitle: Text(pesquisas[index]['datainicial']),
                  onTap: () async {
                    await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DadosProjeto(),
                                settings:
                                    RouteSettings(arguments: pesquisas[index])))
                        .then(
                      (value) => setState(() {
                        if (value == true) {
                          atualizarListaPesquisas();
                        }
                      }),
                    );
                  },
                );
              },
            ),
    );
  }
}

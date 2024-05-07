import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:postgres/postgres.dart';
import '../data/database.dart';

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
      var dataInicial = row[3];
      var dataFinal = row[4];

      var pesquisa = {
        'titulo': row[1],
        'descricao': row[2],
        'datainicial': DateFormat('dd/MM/yyyy').format(dataInicial as DateTime),
        'datafinal': DateFormat('dd/MM/yyyy').format(dataFinal as DateTime),
        'pesquisadores': row[5]
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
        title: const Text('Projetos'),
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
                    await Navigator.pushNamed(context, '/dadosprojeto',
                            arguments: pesquisas[index])
                        .then((value) => setState(() {
                              value == true ? atualizarListaPesquisas() : null;
                            }));
                  },
                );
              },
            ),
    );
  }
}

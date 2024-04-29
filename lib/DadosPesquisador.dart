import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'BancoDados.dart';

class DadosPesquisador extends StatefulWidget {
  @override
  State<DadosPesquisador> createState() => _DadosPesquisadorState();
}
class _DadosPesquisadorState extends State<DadosPesquisador> {
  @override
  Widget build(BuildContext context) {

    final Map<String, dynamic> data = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    Banco banco = Banco();


    Future<void> removerPesquisador(String nome) async {
      Connection conn = await banco.conectarbanco();

      await conn.execute('''
      DELETE FROM pesquisadores 
      WHERE nome = '$nome'
      '''
      );
      await conn.close();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Nome: ${data["nome"]}',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'Área: ${data["areaConhecimento"]}',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await banco.conectarbanco();
                await removerPesquisador(data['nome']);
                Navigator.pop(context);
              },
              child: const Text('Remover'),
            ),
          ],
        ),
      ),
    );
  }
}
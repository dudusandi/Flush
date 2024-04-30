import 'package:flutter/material.dart';
import 'BancoDados.dart';

class DadosPesquisador extends StatefulWidget {
  @override
  State<DadosPesquisador> createState() => _DadosPesquisadorState();
}

class _DadosPesquisadorState extends State<DadosPesquisador> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    Banco banco = Banco();

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes'),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xff004c9e),
        actions: [
          IconButton(
              onPressed: () async {
                await banco.removerPesquisador(data['nome']);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.indigo.shade100),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade100),
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(15),
                width: double.infinity,
                child: Text(
                  'Nome: ${data["nome"]}',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.indigo.shade100),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade100),
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(15),
                width: double.infinity,
                child: Text(
                  'Cargo: ${data["areaConhecimento"]}',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.indigo.shade100),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade100),
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(15),
                width: double.infinity,
                child: Text(
                  'Formação: ${data["tipoConhecimento"]}',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.indigo.shade100),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade100),
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(15),
                width: double.infinity,
                child: Text(
                  'CPF: ${data["cpf"]}',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Image(
            image: AssetImage('assets/logoucs.png'),
            width: 100,
            height: 100,
            filterQuality: FilterQuality.high,
            isAntiAlias: true,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20, right: 5, left: 10),
          child: Text(
            textAlign: TextAlign.justify,
            "Seja bem vindo ao Flush, o sistema de Pesquisas e Inovação da UCS. Aqui você poderá cadastrar os pesquisadores da institução, seus respectivos projetos e conectá-los a empresas investidoras.",
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: ElevatedButton(
            child: Text('Cadastrar Pesquisador'),
            onPressed: () {
              Navigator.pushNamed(context, '/cadastro');
            },
          ),
        ),
        Padding(
            padding: EdgeInsets.only(top: 10),
            child: ElevatedButton(
                child: Text('Cadastrar Projeto'),
                onPressed: () {
                  Navigator.pushNamed(context, '/cadastro_projeto');
                })),
      ],
    ));
  }
}

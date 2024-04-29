import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'BancoDados.dart';
import 'navBar.dart';

class Ajustes extends StatefulWidget {
  

  @override
  AjustesState createState() => AjustesState();
}

class AjustesState extends State<Ajustes> {

  String? _selectedItem;


  final List<DropdownMenuItem<String>> _items = [
    const DropdownMenuItem(
      value: 'ativado',
      child: Text('Ativado'),
    ),
    const DropdownMenuItem(
      value: 'desativado',
      child: Text('Desativado'),
    ),
    // ... outros itens
  ];

  final TextEditingController _hostController = TextEditingController();
  final TextEditingController _portaController = TextEditingController();
  final TextEditingController _databaseController = TextEditingController();
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();


  bool passwordVisible=true;

  Banco banco = Banco();


  @override
  void initState() {

    super.initState();
    carregarConfiguracoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () async {
            await salvarConfiguracoes();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Inicio()),
                  (Route<dynamic> route) => false,);
            try {
              await banco.criarbanco();
              if(mounted){
            setState(() {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Banco Criado")),
              );
            });
    }
            } catch (e) {
              setState(() {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
              });
            }
          },

              icon: const Icon(Icons.save))
        ],
        title: const Text('Ajustes'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Servidor SQL:",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextField(
                  controller: _hostController,
                  decoration: InputDecoration(
                    labelText: "Host",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    prefixIcon: const Icon(Icons.computer),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextField(
                  controller: _portaController,
                  decoration: InputDecoration(
                    labelText: "Porta",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    prefixIcon: const Icon(Icons.people),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextField(
                  controller: _databaseController,
                  decoration: InputDecoration(
                    labelText: "Database",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    prefixIcon: const Icon(Icons.storage),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextField(
                  controller: _usuarioController,
                  decoration: InputDecoration(
                    labelText: "Usuario",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    prefixIcon: const Icon(Icons.people),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextField(
                  controller: _senhaController,
                  obscureText: passwordVisible,
                  decoration: InputDecoration(
                    labelText: "Senha",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusColor: Colors.blue,
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(
                              () {
                            passwordVisible = !passwordVisible;
                          },
                        );
                      },
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: DropdownButtonFormField<String>(
                  value: _selectedItem,
                  borderRadius: BorderRadius.circular(20),
                  decoration: InputDecoration(
                      labelText: 'SSL',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      floatingLabelBehavior: FloatingLabelBehavior.always
        
                  ),
                  items: _items,
                  onChanged: (String? newValue) {
                  setState(() {
                    _selectedItem = newValue;
                  });
                },),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future carregarConfiguracoes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {

      _hostController.text = prefs.getString('host') ?? '';
      _portaController.text = prefs.getString('porta') ?? '';
      _databaseController.text = prefs.getString('database') ?? '';
      _usuarioController.text = prefs.getString('usuario') ?? '';
      _senhaController.text = prefs.getString('senha') ?? '';
      _selectedItem = prefs.getString('itemSelecionado') ?? '';
      
    });
  }

  Future salvarConfiguracoes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('host', _hostController.text);
    await prefs.setString('porta', _portaController.text);
    await prefs.setString('database', _databaseController.text);
    await prefs.setString('usuario', _usuarioController.text);
    await prefs.setString('senha', _senhaController.text);
    await prefs.setString('itemSelecionado', _selectedItem!);

  }

}

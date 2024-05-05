import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database.dart';
import 'navBar.dart';

class Ajustes extends StatefulWidget {
  const Ajustes({super.key});

  @override
  AjustesState createState() => AjustesState();
}

class AjustesState extends State<Ajustes> {
  Future<void> carregarConfiguracoes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _hostController.text = prefs.getString('host') ?? '';
      _portaController.text = prefs.getString('porta') ?? '';
      _databaseController.text = prefs.getString('database') ?? '';
      _usuarioController.text = prefs.getString('usuario') ?? '';
      _senhaController.text = prefs.getString('senha') ?? '';
      _selectedItem = prefs.getString('itemSelecionado') ?? 'ativado';
    });
  }

  Future<void> salvarConfiguracoes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('host', _hostController.text);
    await prefs.setString('porta', _portaController.text);
    await prefs.setString('database', _databaseController.text);
    await prefs.setString('usuario', _usuarioController.text);
    await prefs.setString('senha', _senhaController.text);
    await prefs.setString('itemSelecionado', _selectedItem);
  }

  String _selectedItem = "";

  final List<DropdownMenuItem<String>> _items = [
    const DropdownMenuItem(
      value: "ativado",
      child: Text('Ativado'),
    ),
    const DropdownMenuItem(
      value: "desativado",
      child: Text('Desativado'),
    ),
    // ... outros itens
  ];

  final TextEditingController _hostController = TextEditingController();
  final TextEditingController _portaController = TextEditingController();
  final TextEditingController _databaseController = TextEditingController();
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  bool passwordVisible = true;

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
        backgroundColor: const Color(0xff004c9e),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () async {
                await salvarConfiguracoes();
                try {
                  await banco.criarbanco();
                  setState(() {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Conectado ao Banco!")),
                    );
                  });
                } catch (e) {
                  setState(() {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  });
                }
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Inicio()),
                  (Route<dynamic> route) => false,
                );
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
              ),
              TextField(
                keyboardType: TextInputType.url,
                autocorrect: false,
                controller: _hostController,
                decoration: InputDecoration(
                  labelText: "Host",
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  prefixIcon: const Icon(Icons.computer),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextField(
                  controller: _portaController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Porta",
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
                  value: _selectedItem.isEmpty ? 'ativado' : _selectedItem,
                  borderRadius: BorderRadius.circular(20),
                  decoration: InputDecoration(
                    labelText: 'SSL',
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                  ),
                  items: _items,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedItem = newValue!;
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

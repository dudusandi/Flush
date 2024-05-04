import 'package:postgres/postgres.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Banco {
  var _host;
  var _database;
  var _usuario;
  var _senha;
  var _selectedItem;
  var _ssl;
  var _port;
  var _portaController;

  get host => _host;
  set host(value) {
    _host = value;
  }

  get database => _database;
  set database(value) {
    _database = value;
  }

  get usuario => _usuario;
  set usuario(value) {
    _usuario = value;
  }

  get senha => _senha;
  set senha(value) {
    _senha = value;
  }

  get selectedItem => _selectedItem;
  set selectedItem(value) {
    _selectedItem = value;
  }

  get ssl => _ssl;
  set ssl(value) {
    _ssl = value;
  }

  get port => _port;
  set port(value) {
    _port = value;
  }

  get portaController => _portaController;
  set portaController(value) {
    _portaController = value;
  }

  Future<Connection> conectarbanco() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _host = prefs.getString('host') ?? '';
    _portaController = prefs.getString('porta') ?? '';
    _database = prefs.getString('database') ?? '';
    _usuario = prefs.getString('usuario') ?? '';
    _senha = prefs.getString('senha') ?? '';
    _selectedItem = prefs.getString('itemSelecionado');

    SslMode sslMode() {
      return _selectedItem == 'ativado' ? SslMode.require : SslMode.disable;
    }

    try {
      final conn = await Connection.open(
        Endpoint(
            host: _host,
            database: _database,
            username: _usuario,
            password: _senha,
            port: int.parse(_portaController)),
        settings: ConnectionSettings(sslMode: sslMode()),
      );

      return conn;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> criarbanco() async {
    Connection conn = await conectarbanco();

    await conn.execute('''
    CREATE TABLE IF NOT EXISTS public.pesquisadores (
    nome TEXT,
    cpf TEXT,
    tipo TEXT,
    areaconhecimento TEXT,
    CONSTRAINT pesquisadores_pkey PRIMARY KEY (cpf)
)
     ''');
    await conn.close();
  }

  Future<void> adicionarPesquisador(
      String nome, String cpf, String tipo, String area) async {
    Connection conn = await conectarbanco();

    await conn.execute('''
      INSERT INTO pesquisadores (nome, cpf, tipo, areaconhecimento) 
      VALUES ('$nome', '$cpf', '$tipo', '$area')
      ''');
    await conn.close();
  }

  Future<void> removerPesquisador(String nome) async {
    Connection conn = await conectarbanco();

    await conn.execute('''
      DELETE FROM pesquisadores 
      WHERE nome = '$nome'
      ''');
    await conn.close();
  }

  Future<List<Map<String, dynamic>>> listarPesquisadores() async {
    Connection conn = await conectarbanco();

    try {
      final results = await conn.execute(
        Sql.named('SELECT * FROM pesquisadores ORDER BY nome'),
      );
      List<Map<String, dynamic>> pesquisadores = [];

      for (var row in results) {
        var pesquisador = {
          'nome': row[0],
        };
        pesquisadores.add(pesquisador);
      }

      await conn.close();
      return pesquisadores;
    } catch (e) {
      await conn.close();
      throw e;
    }
  }
}

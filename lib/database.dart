import 'package:postgres/postgres.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Banco {
  String? host;
  String? database;
  String? usuario;
  String? senha;
  String? selectedItem;
  String? ssl;
  String? port;
  String? portaController;

  Future<Connection> conectarbanco() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    host = prefs.getString('host') ?? '';
    portaController = prefs.getString('porta') ?? '';
    database = prefs.getString('database') ?? '';
    usuario = prefs.getString('usuario') ?? '';
    senha = prefs.getString('senha') ?? '';
    selectedItem = prefs.getString('itemSelecionado');

    SslMode sslMode() {
      return selectedItem == 'ativado' ? SslMode.require : SslMode.disable;
    }

    try {
      final conn = await Connection.open(
        Endpoint(
            host: host!,
            database: database!,
            username: usuario,
            password: senha,
            port: int.parse(portaController!)),
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
    projeto TEXT,
    CONSTRAINT pesquisadores_pkey PRIMARY KEY (cpf)
)
     ''');

    await conn.execute('''
    CREATE TABLE IF NOT EXISTS public.pesquisas(
    titulo TEXT,
    descricao TEXT,
    datainicio DATE,
    datafim DATE,
    pesquisadores TEXT
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

  Future<void> removerPesquisa(String titulo) async {
    Connection conn = await conectarbanco();

    await conn.execute('''
      DELETE FROM pesquisas
      WHERE titulo = '$titulo'
      ''');
    await conn.close();
  }

  Future<void> salvarProjeto(String titulo, String descricao, String dataInicio,
      String dataFim, List<String> pesquisadores) async {
    Connection conn = await conectarbanco();

    try {
      await conn.execute('''
      INSERT INTO public.pesquisas (titulo, descricao, datainicio, datafim, pesquisadores)
      VALUES ('$titulo', '$descricao', '$dataInicio', '$dataFim', '$pesquisadores')
    ''');
    } catch (e) {
      throw Exception('Erro ao salvar projeto');
    }
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
      rethrow;
    }
  }
}

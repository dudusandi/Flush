import 'package:postgres/postgres.dart';
import 'package:shared_preferences/shared_preferences.dart';



class Banco{

  var _host;

  get host => _host;

  set host(value) {
    _host = value;
  }
  var _database;

  get database => _database;

  set database(value) {
    _database = value;
  }
  var _usuario;

  get usuario => _usuario;

  set usuario(value) {
    _usuario = value;
  }
  var _senha;

  get senha => _senha;

  set senha(value) {
    _senha = value;
  }

  var _selectedItem;

  get selectedItem => _selectedItem;

  set selectedItem(value) {
    _selectedItem = value;
  }

  var _ssl;

  get ssl => _ssl;

  set ssl(value) {
    _ssl = value;
  }

  var _port;

  get port => _port;

  set port(value) {
    _port = value;
  }

  var _portaController;

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
        final conn = await Connection.open(Endpoint(

            host: _host,
            database: _database,
            username: _usuario,
            password: _senha,
            port: int.parse(_portaController)

        ),

          settings: ConnectionSettings(sslMode: sslMode()),
        );

        return conn;
      }catch (e){
        return Future.error(e);

      }
  }

  Future<void> criarbanco() async {

      Connection conn = await conectarbanco();

      await conn.execute(
          '''
      CREATE TABLE IF NOT EXISTS public.pesquisadores(
    nome text COLLATE pg_catalog."default" NOT NULL,
    cpf text COLLATE pg_catalog."default" NOT NULL,
    tipo text COLLATE pg_catalog."default" NOT NULL,
    areaconhecimento text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT pesquisadores_pkey PRIMARY KEY (nome)
)
     '''
      );
      print("Banco Criado");
      await conn.close();

  }

  Future<void> adicionarPesquisador(
      String nome, String cpf, String tipo, String area) async {

    Connection conn = await conectarbanco();

    await conn.execute('''
      INSERT INTO pesquisadores (nome, cpf, tipo, areaconhecimento) 
      VALUES ('$nome', '$cpf', '$tipo', '$area')
      '''
    );
    await conn.close();
  }

}
import 'package:minhas_anotacoes/model/Anotacao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AnotacaoHelper {

  static final String tableName = "anotacao";
  static final AnotacaoHelper _anotacaoHelper = AnotacaoHelper._internal();
  static final String columnId = "id";
  static final String columnTitle = "title";
  static final String columnDescription = "description";
  static final String columnData = "data";
   Database? _db;

  factory AnotacaoHelper(){
    return _anotacaoHelper;
  }

  AnotacaoHelper._internal(){
  }

  get db async {

    if( _db != null ){
      return _db;
    }else{
      _db = await inicializarDB();
      return _db;
    }

  }

  _onCreate(Database db, int version) async {

    String sql = "CREATE TABLE $tableName ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT, "
        "title VARCHAR, "
        "description TEXT, "
        "data DATETIME ) ";
    await db.execute(sql);
  }

  inicializarDB() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "banco_minhas_anotacoes.db");

    var db = await openDatabase(localBancoDados, version: 1, onCreate: _onCreate);
    return db;
  }

  Future<int> saveNote(Note note) async {

    var bancoDados = await db;
    int results = await bancoDados.insert(tableName, note.toMap() );
    return results;
  }

  recoverNote() async {

    var bancoDados = await _db;
    String sql = "SELECT * FROM $tableName ORDER BY data DESC ";
    Future<List> anotacoes = await bancoDados.rawQuery(sql);
    return anotacoes;

  }

}

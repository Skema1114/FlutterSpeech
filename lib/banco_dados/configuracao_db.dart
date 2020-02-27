import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dao/Configuracao_DAO.dart';

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'configInteligencia.db');

  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(ConfiguracaoDAO.tableSqlContato);
    },
    version: 1,
  );
}